<#
.SYNOPSIS
Runs every .sql file in this portfolio against a disposable, throwaway local
MySQL instance and reports pass/fail per file.

.DESCRIPTION
Initializes a fresh MySQL data directory in a temp location, starts mysqld on
a non-default port, runs each .sql file against it in dependency order (e.g.
HR.sql before the assignment files that need it), reports results, then stops
the server and deletes the temp data directory. Never touches any existing
MySQL install, Windows service, or data directory on the machine — everything
it starts and stops is matched by its own command line, never by process name.

.PARAMETER RepoRoot
Path to the sql-portfolio directory. Defaults to the parent of this script's
own folder (works out of the box if this script stays in sql-portfolio/scripts/).

.PARAMETER MysqlBaseDir
Path to a MySQL Server install (the folder containing bin\mysqld.exe and
bin\mysql.exe). Auto-detected under "C:\Program Files\MySQL" if not given.

.PARAMETER Port
TCP port for the throwaway server. Default 3307 (not MySQL's default 3306,
to avoid any chance of colliding with a real instance).

.EXAMPLE
pwsh -File .\verify_sql.ps1
#>

param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$MysqlBaseDir,
    [int]$Port = 3307
)

$ErrorActionPreference = "Continue"
$PSNativeCommandUseErrorActionPreference = $false

if (-not $MysqlBaseDir) {
    $candidate = Get-ChildItem "C:\Program Files\MySQL" -Directory -Filter "MySQL Server *" -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending | Select-Object -First 1
    if ($candidate) { $MysqlBaseDir = $candidate.FullName }
}
if (-not $MysqlBaseDir -or -not (Test-Path $MysqlBaseDir)) {
    throw "Could not find a MySQL Server install. Pass -MysqlBaseDir 'C:\Program Files\MySQL\MySQL Server X.Y' explicitly."
}

$Mysqld = Join-Path $MysqlBaseDir "bin\mysqld.exe"
$MysqlCli = Join-Path $MysqlBaseDir "bin\mysql.exe"
if (-not (Test-Path $Mysqld)) { throw "mysqld.exe not found at $Mysqld" }
if (-not (Test-Path $MysqlCli)) { throw "mysql.exe not found at $MysqlCli" }

$DataDir = Join-Path $env:TEMP "sql-portfolio-verify-mysql-data"
if (Test-Path $DataDir) { Remove-Item -Recurse -Force $DataDir }
New-Item -ItemType Directory -Path $DataDir | Out-Null

Write-Output "Using MySQL install: $MysqlBaseDir"
Write-Output "Initializing throwaway MySQL data directory at $DataDir ..."
& $Mysqld --initialize-insecure --datadir="$DataDir" --basedir="$MysqlBaseDir" 2>&1 | Out-Null

Write-Output "Starting mysqld on port $Port ..."
$proc = Start-Process -FilePath $Mysqld -ArgumentList @(
    "--datadir=`"$DataDir`"",
    "--basedir=`"$MysqlBaseDir`"",
    "--port=$Port",
    "--bind-address=127.0.0.1",
    "--skip-networking=0",
    "--pid-file=`"$DataDir\mysqld.pid`"",
    "--socket=`"$DataDir\mysql.sock`"",
    "--log-error=`"$DataDir\mysqld_err.log`""
) -PassThru -WindowStyle Hidden
$serverPid = $proc.Id

function Stop-ThrowawayServer {
    # Only ever targets the exact PID launched above, re-verified by matching
    # its command line to our throwaway datadir. Never stops mysqld by name —
    # this must never touch a real, pre-existing MySQL instance.
    $p = Get-CimInstance Win32_Process -Filter "ProcessId=$serverPid" -ErrorAction SilentlyContinue
    if ($p -and $p.CommandLine -like "*$DataDir*") {
        try { & $MysqlCli --host=127.0.0.1 --port=$Port --user=root -e "SHUTDOWN;" 2>&1 | Out-Null } catch {}
        Start-Sleep -Seconds 2
        $p2 = Get-CimInstance Win32_Process -Filter "ProcessId=$serverPid" -ErrorAction SilentlyContinue
        if ($p2 -and $p2.CommandLine -like "*$DataDir*") {
            Stop-Process -Id $serverPid -Force -ErrorAction SilentlyContinue
        }
    }
}

$failCount = 0

try {
    $ready = $false
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Seconds 1
        & $MysqlCli --host=127.0.0.1 --port=$Port --user=root -e "SELECT 1;" 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $ready = $true; break }
    }
    if (-not $ready) {
        Write-Output "Server failed to become ready. Log:"
        Get-Content "$DataDir\mysqld_err.log" -ErrorAction SilentlyContinue
        throw "mysqld did not become ready in time"
    }
    Write-Output "Server ready."

    # Ordered so cross-file dependencies (HR.sql before its dependents,
    # Mavenmovies.sql before files that USE mavenmovies, sakila schema before
    # sakila data, etc.) run in the right order.
    $files = @(
        "module-1\datetime-functions\SQL_DateTimeFunc_QandA_Dec092024.sql",
        "module-1\datetime-functions\SQL_DateTimeFunc_Examples_Dec092024.sql",
        "module-1\joins\SQL_JOINFunc_QandA_Dec292024.sql",
        "module-1\window-functions\SQL_WINDOWS_Func_QandA_Jan032025.sql",
        "module-2\databases\HR.sql",
        "module-2\databases\PETSTORE.sql",
        "module-2\databases\LUCKY_SHRUB.sql",
        "module-2\databases\luckyshrub_db.sql",
        "module-2\databases\New_8.sql",
        "module-2\assignments\Joins_Class_Work.sql",
        "module-2\assignments\Mavenmovies.sql",
        "module-2\assignments\Sub_Queries_Assigement.sql",
        "module-2\assignments\MAVENMOVIES_ASSIGNMENT.sql",
        "module-2\assignments\Joins_Assignment_1.sql",
        "case-studies\Case Study #1 - Danny_s Diner.sql",
        "case-studies\Case Study #1 - Danny_s Diner_Solutions.sql",
        "case-studies\Case Study #2 - Pizza Runner.sql",
        "case-studies\Case Study #2 - Pizza Runner_Solution.sql",
        "case-studies\Case Study #3 - Foodie-Fi.sql",
        "case-studies\Case Study #4  Data Bank.sql",
        "case-studies\Case Study #5 - Data Mart.sql",
        "case-studies\Case Study #6 - Clique Bait.sql",
        "case-studies\Case Study #7 - Balanced Tree Clothing Co..sql",
        "case-studies\Case Study 8 Fresh Segments.sql",
        "reference\maven_advanced_sql_demo.sql",
        "reference\sakila-db\sakila-schema.sql",
        "reference\sakila-db\sakila-data.sql"
    )

    $results = @()

    foreach ($rel in $files) {
        $path = Join-Path $RepoRoot $rel
        if (-not (Test-Path $path)) {
            $results += [pscustomobject]@{ File = $rel; Status = "MISSING"; Detail = "file not found" }
            continue
        }

        $content = Get-Content -Raw -Encoding UTF8 $path

        # If the file creates its own database without IF NOT EXISTS, drop it
        # first so re-runs and cross-file ordering never collide.
        $m = [regex]::Match($content, '(?im)^\s*CREATE\s+(?:DATABASE|SCHEMA)\s+(?:IF\s+NOT\s+EXISTS\s+)?`?([A-Za-z0-9_]+)`?\s*;')
        if ($m.Success) {
            $dbName = $m.Groups[1].Value
            & $MysqlCli --host=127.0.0.1 --port=$Port --user=root -e "DROP DATABASE IF EXISTS $dbName;" 2>&1 | Out-Null
        }

        $errFile = [System.IO.Path]::GetTempFileName()
        $content | & $MysqlCli --host=127.0.0.1 --port=$Port --user=root --default-character-set=utf8mb4 2> $errFile | Out-Null
        $exitCode = $LASTEXITCODE
        $errText = Get-Content -Raw $errFile -ErrorAction SilentlyContinue
        Remove-Item $errFile -ErrorAction SilentlyContinue

        if ($exitCode -eq 0) {
            $results += [pscustomobject]@{ File = $rel; Status = "PASS"; Detail = "" }
        } else {
            $firstErrLine = ($errText -split "`n" | Where-Object { $_ -match "ERROR" } | Select-Object -First 1)
            $results += [pscustomobject]@{ File = $rel; Status = "FAIL"; Detail = $firstErrLine }
        }
    }

    Write-Output ""
    Write-Output "===== RESULTS ====="
    $results | ForEach-Object {
        "{0,-70} {1}" -f $_.File, $_.Status
        if ($_.Status -eq "FAIL" -or $_.Status -eq "MISSING") { "    $($_.Detail)" }
    }

    $passCount = ($results | Where-Object { $_.Status -eq "PASS" }).Count
    $failCount = ($results | Where-Object { $_.Status -ne "PASS" }).Count
    Write-Output ""
    Write-Output "$passCount passed, $failCount failed/missing out of $($results.Count)"
}
finally {
    Write-Output ""
    Write-Output "Stopping throwaway mysqld (PID $serverPid) and removing its data directory ..."
    Stop-ThrowawayServer
    Remove-Item -Recurse -Force $DataDir -ErrorAction SilentlyContinue
    Write-Output "Done."
}

exit $failCount
