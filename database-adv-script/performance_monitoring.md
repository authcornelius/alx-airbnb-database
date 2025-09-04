# Database Performance Monitoring and Refinement

## Objective
The goal is to continuously monitor and refine database performance by analyzing query execution plans and applying schema optimizations.

## Tools Used
- `EXPLAIN` / `EXPLAIN ANALYZE` (PostgreSQL)
- `SHOW PROFILE` (MySQL alternative)

## Queries Monitored
### 1. Fetch all bookings with user and property details
```sql
EXPLAIN ANALYZE
SELECT b.id, b.start_date, b.end_date, u.name, p.title
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
WHERE b.start_date BETWEEN '2024-06-01' AND '2024-06-30';
