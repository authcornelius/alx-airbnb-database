-- Insert sample Users
INSERT INTO Users (id, name, email, password, created_at)
VALUES 
(1, 'John Doe', 'john@example.com', 'hashed_password_123', NOW()),
(2, 'Jane Smith', 'jane@example.com', 'hashed_password_456', NOW()),
(3, 'Michael Brown', 'michael@example.com', 'hashed_password_789', NOW());

-- Insert sample Properties
INSERT INTO Properties (id, user_id, title, description, location, price_per_night, created_at)
VALUES
(1, 1, 'Cozy Apartment in Lagos', 'A 2-bedroom apartment with sea view', 'Lagos, Nigeria', 75.00, NOW()),
(2, 2, 'Modern Loft in Nairobi', 'A stylish loft in the city center', 'Nairobi, Kenya', 100.00, NOW()),
(3, 3, 'Beach House in Accra', 'Perfect getaway with ocean views', 'Accra, Ghana', 150.00, NOW());

-- Insert sample Bookings
INSERT INTO Bookings (id, user_id, property_id, start_date, end_date, total_price, status, created_at)
VALUES
(1, 2, 1, '2025-09-01', '2025-09-05', 300.00, 'confirmed', NOW()),
(2, 3, 2, '2025-09-10', '2025-09-12', 200.00, 'pending', NOW()),
(3, 1, 3, '2025-10-01', '2025-10-07', 900.00, 'confirmed', NOW());

-- Insert sample Payments
INSERT INTO Payments (id, booking_id, amount, payment_date, method, status)
VALUES
(1, 1, 300.00, NOW(), 'credit_card', 'completed'),
(2, 2, 200.00, NOW(), 'paypal', 'pending'),
(3, 3, 900.00, NOW(), 'credit_card', 'completed');
