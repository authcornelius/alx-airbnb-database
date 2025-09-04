-- Create index on Users table (frequently used in JOINs and WHERE clauses)
CREATE INDEX idx_users_id ON users(id);
CREATE INDEX idx_users_email ON users(email);

-- Create index on Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_start_date ON bookings(start_date);

-- Create index on Properties table
CREATE INDEX idx_properties_id ON properties(id);
CREATE INDEX idx_properties_name ON properties(name);

-- Create index on Reviews table (useful for filtering by property)
CREATE INDEX idx_reviews_property_id ON reviews(property_id);
