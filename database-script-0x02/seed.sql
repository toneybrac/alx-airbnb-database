-- Insert sample data into User table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
    ('550e8400-e29b-41d4-a716-446655440000', 'John', 'Doe', 'john.doe@example.com', 'hashed_password_123', '+12345678901', 'guest', '2025-10-01 10:00:00'),
    ('550e8400-e29b-41d4-a716-446655440001', 'Jane', 'Smith', 'jane.smith@example.com', 'hashed_password_456', '+12345678902', 'host', '2025-10-01 11:00:00'),
    ('550e8400-e29b-41d4-a716-446655440002', 'Alice', 'Johnson', 'alice.johnson@example.com', 'hashed_password_789', '+12345678903', 'guest', '2025-10-02 12:00:00'),
    ('550e8400-e29b-41d4-a716-446655440003', 'Bob', 'Brown', 'bob.brown@example.com', 'hashed_password_101', '+12345678904', 'host', '2025-10-02 13:00:00'),
    ('550e8400-e29b-41d4-a716-446655440004', 'Admin', 'User', 'admin@example.com', 'hashed_password_999', '+12345678905', 'admin', '2025-10-03 14:00:00');

-- Insert sample data into Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
    ('6b7c9a2f-4e5b-4f3c-9a1e-7b8c9d0e1f2a', '550e8400-e29b-41d4-a716-446655440001', 'Cozy Beach Cottage', 'A charming cottage by the sea with 2 bedrooms and ocean views.', '123 Ocean Dr, Miami, FL 33101', 150.00, '2025-10-05 09:00:00', '2025-10-05 09:00:00'),
    ('6b7c9a2f-4e5b-4f3c-9a1e-7b8c9d0e1f2b', '550e8400-e29b-41d4-a716-446655440001', 'Downtown Loft', 'Modern loft in the heart of the city with skyline views.', '456 City St, New York, NY 10001', 200.00, '2025-10-06 10:00:00', '2025-10-06 10:00:00'),
    ('6b7c9a2f-4e5b-4f3c-9a1e-7b8c9d0e1f2c', '550e8400-e29b-41d4-a716-446655440003', 'Mountain Cabin', 'Rustic cabin in the mountains, perfect for a getaway.', '789 Hill Rd, Denver, CO 80201', 120.00, '2025-10-07 11:00:00', '2025-10-07 11:00:00');

-- Insert sample data into Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
    ('8a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3d', '6b7c9a2f-4e5b-4f3c-9a1e-7b8c9d0e1f2a', '550e8400-e29b-41d4-a716-446655440000', '2025-11-01', '2025-11-03', 300.00, 'confirmed', '2025-10-10 08:00:00'),
    ('8a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3e', '6b7c9a2f-4e5b-4f3c-9a1e-7b8c9d0e1f2b', '550e8400-e29b-41d4-a716-446655440002', '2025-11-05', '2025-11-07', 400.00, 'pending', '2025-10-11 09:00:00'),
    ('8a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3f', '6b7c9a2f-4e5b-4f3c-9a1e-7b8c9d0e1f2c', '550e8400-e29b-41d4-a716-446655440000', '2025-11-10', '2025-11-12', 240.00, 'canceled', '2025-10-12 10:00:00');

-- Insert sample data into Payment table
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
    ('9b0c1d2e-3f4a-5b6c-7d8e-9f0a1b2c3d4e', '8a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3d', 300.00, '2025-10-10 09:00:00', 'credit_card'),
    ('9b0c1d2e-3f4a-5b6c-7d8e-9f0a1b2c3d4f', '8a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3e', 400.00, '2025-10-11 10:00:00', 'paypal');

-- Insert sample data into Review table
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
    ('0c1d2e3f-4a5b-5c6d-7e8f-0a1b2c3d4e5f', '6b7c9a2f-4e5b-4f3c-9a1e-7b8c9d0e1f2a', '550e8400-e29b-41d4-a716-446655440000', 5, 'Amazing stay! The beach views were stunning.', '2025-11-04 12:00:00'),
    ('0c1d2e3f-4a5b-5c6d-7e8f-0a1b2c3d4e5g', '6b7c9a2f-4e5b-4f3c-9a1e-7b8c9d0e1f2b', '550e8400-e29b-41d4-a716-446655440002', 4, 'Great location, but parking was limited.', '2025-11-08 13:00:00');

-- Insert sample data into Message table
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
    ('1d2e3f4a-5b6c-6d7e-8f9a-0b1c2d3e4f5a', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'Hi, is the beach cottage available for next week?', '2025-10-09 14:00:00'),
    ('1d2e3f4a-5b6c-6d7e-8f9a-0b1c2d3e4f5b', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Yes, it’s available! Please let me know your preferred dates.', '2025-10-09 15:00:00'),
    ('1d2e3f4a-5b6c-6d7e-8f9a-0b1c2d3e4f5c', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Can you provide more details about the loft’s amenities?', '2025-10-10 16:00:00');
