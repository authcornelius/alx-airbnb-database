# Partitioning Performance Report

## Objective
The `bookings` table was partitioned by `start_date` using **RANGE partitioning**.  
This approach ensures queries that filter by date only scan the relevant partitions, reducing query time.

## Setup
- Original table: `bookings`
- Partitioned table: `bookings_partitioned`
- Partitions: `bookings_2023`, `bookings_2024`, `bookings_future`

## Queries Tested
```sql
-- Query without partitioning
EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE start_date BETWEEN '2024-05-01' AND '2024-05-31';

-- Query with partitioning
EXPLAIN ANALYZE
SELECT *
FROM bookings_partitioned
WHERE start_date BETWEEN '2024-05-01' AND '2024-05-31';
