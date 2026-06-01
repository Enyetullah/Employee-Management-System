# Employee Management System SQL Project

## Project Overview

This project is a PostgreSQL-based employee management database. It stores information about employees, organizations, job roles, employee types, address categories, and employee work assignments.

The goal of this project is to demonstrate relational database design, PostgreSQL syntax, normalized tables, foreign keys, views, and practical reporting queries.

## Skills Demonstrated

- PostgreSQL database design
- Schema creation
- Relational table design
- Primary keys and foreign keys
- Data cleaning and restructuring
- SQL joins
- Views
- Aggregation with `GROUP BY`
- Filtering with `WHERE`
- `HAVING` clauses
- Window functions with `RANK()`
- PostgreSQL `FILTER` syntax
- Portfolio-style reporting queries

## Database Tables

| Table | Purpose |
|---|---|
| `address_type` | Stores address categories for employee contact records |
| `person` | Stores employee contact and profile information |
| `employee_role` | Stores job role information |
| `employee_type` | Stores employee classification and pay-frequency information |
| `organization` | Stores organization and business unit information |
| `employee` | Connects each person to a role, employee type, and organization |

## Views

| View | Purpose |
|---|---|
| `employee_profile` | Combines employee, person, role, type, organization, and address details into one readable view |
| `organization_workforce_summary` | Summarizes employee counts by organization and employment status |

## Database Relationships

```text
address_type 1 ──── many person
person       1 ──── 1 employee
employee_role 1 ──── many employee
employee_type 1 ──── many employee
organization  1 ──── many employee
```

## Example Questions Answered

- Which employees are currently active?
- How many employees are assigned to each organization?
- Which job roles are most common?
- How are employees distributed by pay frequency?
- Which employees work outside their home country?
- What devices are used across employee records?
- Which organizations have more than five employees?
- How can employees be ranked within each organization by benefit rate?
- What is the average age by employee type?

## Technologies Used

- SQL
- PostgreSQL
- Relational database design

## How to Run in pgAdmin

1. Open pgAdmin.
2. Connect to your PostgreSQL server.
3. Open the default `postgres` database.
4. Open the Query Tool.
5. Open `employee_management_system_postgresql.sql`.
6. Click the Execute button or press `F5`.
7. Refresh `Schemas` and open the `employee_management_system` schema.

## Author

Enyetullah Rahimullah
