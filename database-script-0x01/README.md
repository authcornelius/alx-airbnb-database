# Database Schema (DDL)

## 🎯 Objective
Define the Airbnb-like database schema using SQL `CREATE TABLE` statements with proper constraints and indexing.

---

## 📂 Files
- **schema.sql** → Contains all `CREATE TABLE` statements with primary keys, foreign keys, and indexes.
- **README.md** → Documentation of schema design decisions.

---

## 🏗️ Schema Overview
The schema is normalized (3NF) and includes the following entities:

1. **Users** → Stores user details (hosts & guests).
2. **Listings** → Represents properties listed by users.
3. **Bookings** → Captures reservations made by guests.
4. **Reviews** → Allows users to leave reviews on bookings.

---

## ⚙️ Key Design Decisions
- **Primary Keys**: Auto-incrementing `SERIAL` IDs for uniqueness.
- **Foreign Keys**: Enforce relationships (`Users` ↔ `Listings`, `Bookings`, `Reviews`).
- **Constraints**:  
  - Unique emails in `Users`  
  - Ratings between 1 and 5 in `Reviews`  
- **Indexes**: Added on frequently queried columns (`location`, `start_date`, `rating`) for performance.

---

## 🚀 Usage
Run the schema file in PostgreSQL:

```bash
psql -U <username> -d <database_name> -f schema.sql
