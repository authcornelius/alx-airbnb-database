# Query Optimization Report

## Initial Query
The initial query retrieved all bookings along with user, property, and payment details.  
It included all columns from multiple tables and used `JOIN` on every relationship.  

**Issues:**
- Retrieved unnecessary fields (e.g., multiple IDs, full payment details).
- Payments were joined as an `INNER JOIN`, which excluded bookings without payments.
- The query scanned large tables without fully leveraging indexes.

---

## Refactored Query
The optimized query applies:
1. **Selective Columns** → Only retrieves the required fields (`user_name`, `property_name`, `amount`).
2. **Join Strategy** → Replaced `INNER JOIN` on payments with `LEFT JOIN` to avoid excluding unpaid bookings.
3. **Index Usage** → Relies on indexes (`user_id`, `property_id`, `booking_id`) for faster lookups.

---

## Performance Comparison
Using `EXPLAIN ANALYZE`:
- The initial query showed multiple full table scans and higher execution cost.  
- The refactored query reduced execution time by avoiding unnecessary joins and columns, while indexes improved lookup speed.

---

## Conclusion
By reducing joins, selecting only necessary columns, and ensuring proper index usage, the refactored query runs more efficiently and scales better with larger datasets.
