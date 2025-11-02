-- Initial Complex Query: Retrieve all bookings with user, property, and payment details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created,
    
    -- Host details
    host.user_id AS host_id,
    host.first_name AS host_first_name,
    host.last_name AS host_last_name,
    host.email AS host_email,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.payment_date,
    
    -- Review details (if exists)
    r.review_id,
    r.rating,
    r.comment AS review_comment
    
FROM Booking b
-- Join with User table (guest information)
INNER JOIN User u ON b.user_id = u.user_id
-- Join with Property table
INNER JOIN Property p ON b.property_id = p.property_id
-- Join with User table again for host information
INNER JOIN User host ON p.host_id = host.user_id
-- Left join with Payment table (not all bookings may have payments)
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
-- Left join with Review table (not all bookings may have reviews)
LEFT JOIN Review r ON b.property_id = r.property_id AND b.user_id = r.user_id
ORDER BY b.created_at DESC;

-- Optimized Query Version 1: Reduced joins and selected columns only
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created,
    
    -- Essential user details only
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    -- Essential property details only
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Essential host details only
    host.first_name AS host_first_name,
    host.last_name AS host_last_name,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method
    
FROM Booking b
-- Join with User table (guest information)
INNER JOIN User u ON b.user_id = u.user_id
-- Join with Property table
INNER JOIN Property p ON b.property_id = p.property_id
-- Join with User table again for host information
INNER JOIN User host ON p.host_id = host.user_id
-- Left join with Payment table
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- Optimized Query Version 2: With pagination and date filtering
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    -- User details
    u.first_name,
    u.last_name,
    u.email,
    
    -- Property details
    p.name AS property_name,
    p.location,
    
    -- Host details
    host.first_name AS host_first_name,
    host.last_name AS host_last_name,
    
    -- Payment details
    pay.payment_method,
    pay.amount AS payment_amount
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User host ON p.host_id = host.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)  -- Recent bookings only
ORDER BY b.created_at DESC
LIMIT 50 OFFSET 0;  -- Pagination

-- Optimized Query Version 3: Separate queries for different data needs
-- Main booking information
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    host.first_name AS host_first_name,
    host.last_name AS host_last_name
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User host ON p.host_id = host.user_id
WHERE b.created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
ORDER BY b.created_at DESC
LIMIT 50;

-- Payment information (separate query)
SELECT 
    booking_id,
    payment_id,
    amount,
    payment_method,
    payment_date
FROM Payment
WHERE booking_id IN (
    SELECT booking_id FROM Booking 
    WHERE created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
    ORDER BY created_at DESC 
    LIMIT 50
);

-- Review information (separate query)
SELECT 
    property_id,
    user_id,
    review_id,
    rating,
    comment
FROM Review
WHERE (property_id, user_id) IN (
    SELECT property_id, user_id FROM Booking 
    WHERE created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
    ORDER BY created_at DESC 
    LIMIT 50
);

-- Query for specific use case: Confirmed bookings with payments
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    p.location,
    pay.payment_method,
    pay.amount
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed'
AND b.start_date >= CURDATE()
ORDER BY b.start_date ASC;
