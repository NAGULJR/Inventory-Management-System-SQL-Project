# Inventory Management System (IMS) – MySQL Project

**Author:** Nagulraj A

This repository contains a complete Inventory Management System designed in MySQL, featuring a 10-table normalized schema, sample data, stored procedures, triggers, views, indexes, and 30+ scenario queries for interview practice.

## Structure

- `sql/clean/` : Cleaned, formatted SQL files ready to run in MySQL Workbench.
- `sql/raw/` : Raw SQL collected from project inputs (unaltered except header).
- `docs/IMS_ERD.png` : ER Diagram (compact cluster layout).
- `README.md` : Project overview and instructions.

## Quick start (use the clean SQL files):
1. Open MySQL Workbench.
2. Run: `SOURCE sql/clean/01_create_database.sql;`
3. Then run in order:
   - `SOURCE sql/clean/02_create_tables.sql;`
   - `SOURCE sql/clean/03_insert_data.sql;`
   - `SOURCE sql/clean/04_stored_procedures.sql;`
   - `SOURCE sql/clean/05_triggers.sql;`
   - `SOURCE sql/clean/06_indexes_and_views.sql;`
   - `SOURCE sql/clean/07_scenario_queries.sql;` (for practice queries)

## Notes
- All table names standardized to `order_items` (snake_case, lowercase) for portability across OS.
- Triggers and procedures include DELIMITER statements where required.
- Use the `raw/` folder if you need the original unmodified SQL snippets.

---
