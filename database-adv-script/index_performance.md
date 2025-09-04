# Index Performance Analysis

## Introduction
Indexes help optimize queries by reducing full table scans on frequently used columns.  
We identified columns in Users, Bookings, Properties, and Reviews that are often used in `WHERE`, `JOIN`, and `ORDER BY` clauses.

## Indexes Implemented
- **Users**
  - `idx_users_id` → Improves joins on `users.id`
  - `idx_users_email` → Optimizes lookups by email

- **Bookings**
  - `idx_bookings_user_id` → Faster joins with users
  - `idx_bookings_property_id` → Faster joins with properties
  - `idx_bookings_start_date` → Optimizes date range queries

- **Properties**
  - `idx_properties_id` → Speeds up joins with bookings
  - `idx_properties_name` → Improves search by name

- **Reviews**
  - `idx_reviews_property_id` → Optimizes review lookups by property

## Performance Measurement

### Example 1: Users and Bookings Join
```sql
EXPLAIN ANALYZE
SELECT u.name, b.start_date, b.end_date
FROM users u
JOIN bookings b ON u.id = b.user_id
WHERE b.start_date > '2025-01-01';
