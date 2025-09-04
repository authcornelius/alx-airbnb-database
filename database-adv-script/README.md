# SQL Joins Queries – Airbnb Database

This project contains advanced SQL queries demonstrating different types of **JOINs** using the Airbnb database schema.

## 📂 Files
- **joins_queries.sql** → Contains SQL queries for INNER JOIN, LEFT JOIN, and FULL OUTER JOIN.
- **README.md** → Documentation.

## 🔑 Queries Implemented

### 1. INNER JOIN
Retrieve all bookings and the respective users who made those bookings.
```sql
SELECT b.id, b.property_id, b.start_date, b.end_date, u.id, u.name, u.email
FROM bookings b
INNER JOIN users u ON b.user_id = u.id;
