# 🗃️ SQL & Database Portfolio

A comprehensive collection of SQL assignments, case studies, database projects, and reference materials from a **Data Science training program** — covering MySQL fundamentals through advanced concepts including joins, window functions, subqueries, and real-world case studies.

---

## 📁 Project Structure

```
sql-portfolio/
├── module-1/                   # SQL coursework — advanced topics
│   ├── datetime-functions/     # Date/time function exercises
│   ├── joins/                  # JOIN operations and queries
│   └── window-functions/       # Window functions (ROW_NUMBER, RANK, etc.)
├── module-2/                   # SQL coursework — databases & assignments
│   ├── databases/              # Database creation scripts (HR, PetStore, etc.)
│   └── assignments/            # Graded assignments (Joins, Subqueries, Maven)
├── case-studies/               # 8 real-world SQL case studies
├── reference/                  # Learning resources
│   ├── cheat-sheets/           # SQL quick reference guides
│   ├── interview-prep/         # Interview questions & answers
│   ├── books/                  # MySQL reference manuals
│   └── sakila-db/              # MySQL sample database
├── notes/                      # Class notes and documentation
├── datasets/                   # CSV data files for exercises
├── .gitignore
└── README.md
```

---

## 📋 Coursework — Module 1

| Topic | Files | Key Concepts |
|-------|-------|-------------|
| DateTime Functions | Examples + Q&A | DATE_FORMAT, DATEDIFF, DATE_ADD, EXTRACT, NOW() |
| JOINs | Q&A exercises | INNER, LEFT, RIGHT, FULL, CROSS, SELF joins |
| Window Functions | Q&A exercises | ROW_NUMBER, RANK, DENSE_RANK, NTILE, LAG, LEAD |

---

## 📋 Coursework — Module 2

### Database Scripts
| Database | Description |
|----------|-------------|
| HR.sql | Human Resources database — employees, departments, jobs |
| PETSTORE.sql | Pet store inventory and sales |
| LUCKY_SHRUB.sql | Garden center business database |
| luckyshrub_db.sql | Lucky Shrub variant |
| New_8.sql | Additional practice database |

### Assignments
| Assignment | Topic |
|-----------|-------|
| Joins Assignment 1 | Multi-table JOINs practice |
| Joins Class Work | In-class JOIN exercises |
| Maven Movies | Movie rental database queries |
| Maven Movies Assignment | Graded movie database project |
| Sub-Queries Assignment | Nested queries and subqueries |

---

## 🔍 Case Studies (8 Real-World Projects)

| # | Case Study | Domain | Key Skills |
|---|-----------|--------|-----------|
| 1 | Danny's Diner | Restaurant | Joins, aggregation, CTEs |
| 2 | Pizza Runner | Food delivery | Data cleaning, joins, temp tables |
| 3 | Foodie-Fi | Subscription | Window functions, date analysis |
| 4 | Data Bank | Banking | Running totals, customer metrics |
| 5 | Data Mart | Retail | Before/after analysis, CTEs |
| 6 | Clique Bait | E-commerce | Funnel analysis, click tracking |
| 7 | Balanced Tree Clothing | Fashion retail | Sales analysis, reporting |
| 8 | Fresh Segments | Digital marketing | Interest analysis, rankings |

---

## 📚 Reference Materials

### Cheat Sheets
- MySQL Cheat Sheets (multiple versions)
- SQL Command Reference (W3Schools)
- SQL Quick Reference Markdown

### Interview Preparation
- MySQL Interview Questions & Answers
- SQL Interview Questions & Answers
- Oracle Interview Questions
- PL-SQL Interview Questions
- SQL Server Interview Questions
- Top 60+ DBMS Interview Questions

### Books & Manuals
- MySQL 8.0 Reference Manual
- High Performance MySQL (3rd Edition)
- Database Systems Lecture Notes
- Seven Databases in Seven Weeks

### Sample Database
- Sakila DB (schema + data) — MySQL's official sample database

---

## 🔧 Tools

- **MySQL Server 8.4** — Database engine
- **MySQL Workbench** — Visual SQL editor and database design
- **Jupyter Notebooks** — For SQL + Python integration

---

## 📌 How to Use

1. Install MySQL Server and MySQL Workbench
2. Import database scripts from `module-2/databases/`
3. Run assignment `.sql` files in Workbench
4. Case studies include both questions and solutions

Every `.sql` file in this repo creates its own database (or reuses one created
by another file in this repo, e.g. `HR.sql` or `Mavenmovies.sql`) and seeds its
own data, so each file runs standalone once its dependency (if any) has been
run first — no external setup or manually-loaded datasets required.

---

## ✅ Verifying This Repo Runs

All 27 `.sql` files in this repo are verified to run cleanly against a real
MySQL 8.4 instance. You can reproduce that verification locally:

**Requirements:** MySQL Server installed on Windows (any recent 8.x — the
verifier auto-detects the newest install under `C:\Program Files\MySQL`), and
PowerShell 7+ (`pwsh`; Windows PowerShell 5.1 is not supported).

```powershell
pwsh -File .\scripts\verify_sql.ps1
```

This script:
- Initializes a **fresh, throwaway** MySQL data directory in your temp folder
  and starts `mysqld` on port 3307 (not MySQL's default 3306).
- Runs every `.sql` file in this repo against it, in dependency order, and
  prints PASS/FAIL per file.
- Shuts down the throwaway server and deletes its data directory when done.

It never touches any MySQL install, Windows service, or database already on
your machine — the server it starts is isolated by its own dedicated data
directory and port, and it is only ever stopped by matching its own process
ID against that data directory path, never by process name.

---

## 📜 License

This repository contains coursework and study materials compiled during a data analytics training program. For educational reference only.
