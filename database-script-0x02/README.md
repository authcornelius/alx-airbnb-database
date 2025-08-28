# Database Seeding - Airbnb Clone

This directory contains the **sample data seeding script** for the `alx-airbnb-database`.

## 📌 Files
- **seed.sql** → SQL script to insert sample data into the database.
- **README.md** → Documentation for running the script.

## 📊 Entities Covered
- Users
- Properties
- Bookings
- Payments

## 🚀 How to Run
1. Make sure the database schema has already been created from `database-script-0x01/schema.sql`.
2. Connect to your database (PostgreSQL/MySQL depending on setup).
3. Run:
   ```bash
   psql -U <username> -d <database> -f seed.sql
