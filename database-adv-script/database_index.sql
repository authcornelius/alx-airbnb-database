-- ==========================
-- Create Indexes
-- ==========================

-- Users table
CREATE INDEX idx_users_id ON users(id);
CREATE INDEX idx_users_email ON users(email);

-- Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_start_date ON bookings(start_date);

-- Properties table
CREATE INDEX idx_properties_id ON properties(id);
CREATE INDEX idx_properties_name ON properties(name);

-- Reviews table
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- ==========================
-- Performance Measurement
-- ==========================

-- Query 1: Join users and bookings
EXPLAIN ANALYZE
SELECT u.name, b.start_date, b.end_date
FROM users u
JOIN bookings b ON u.id = b.user_id
WHERE b.start_date > '2025-01-01';

-- Query 2: Property search by name
EXPLAIN ANALYZE
SELECT *
FROM properties
WHERE name LIKE 'Beach%';

-- Query 3: Count reviews per property
EXPLAIN ANALYZE
SELECT p.name, COUNT(r.id) AS review_count
FROM properties p
LEFT JOIN reviews r ON p.id = r.property_id
GROUP BY p.name;
