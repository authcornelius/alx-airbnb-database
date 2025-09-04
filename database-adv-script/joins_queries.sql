-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings
SELECT 
    b.id AS booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email
FROM bookings b
INNER JOIN users u
    ON b.user_id = u.id;

-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties with no reviews
SELECT 
    p.id AS property_id,
    p.name AS property_name,
    r.id AS review_id,
    r.rating AS review_rating,
    r.comment AS review_comment
FROM properties p
LEFT JOIN reviews r
    ON p.id = r.property_id
ORDER BY p.id;


-- 3. FULL OUTER JOIN: Retrieve all users and all bookings
-- Note: FULL OUTER JOIN is not supported in MySQL. 
-- If using PostgreSQL, use the query below:
SELECT 
    u.id AS user_id,
    u.name AS user_name,
    b.id AS booking_id,
    b.property_id,
    b.start_date,
    b.end_date
FROM users u
FULL OUTER JOIN bookings b
    ON u.id = b.user_id;

-- MySQL Alternative for FULL OUTER JOIN (using UNION of LEFT and RIGHT JOINs)
-- Uncomment this if using MySQL:
-- SELECT 
--     u.id AS user_id,
--     u.name AS user_name,
--     b.id AS booking_id,
--     b.property_id,
--     b.start_date,
--     b.end_date
-- FROM users u
-- LEFT JOIN bookings b
--     ON u.id = b.user_id
-- UNION
-- SELECT 
--     u.id AS user_id,
--     u.name AS user_name,
--     b.id AS booking_id,
--     b.property_id,
--     b.start_date,
--     b.end_date
-- FROM users u
-- RIGHT JOIN bookings b
--     ON u.id = b.user_id;
