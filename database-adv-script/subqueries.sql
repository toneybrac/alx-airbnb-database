-- 1. Non-correlated subquery: Find all properties where the average rating is greater than 4.0
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.description,
    (SELECT AVG(r.rating) 
     FROM Review r 
     WHERE r.property_id = p.property_id) AS average_rating
FROM Property p
WHERE (SELECT AVG(r.rating) 
       FROM Review r 
       WHERE r.property_id = p.property_id) > 4.0
ORDER BY average_rating DESC;

-- Alternative non-correlated subquery using HAVING with subquery in FROM
SELECT 
    property_stats.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    property_stats.average_rating
FROM (
    SELECT 
        r.property_id,
        AVG(r.rating) AS average_rating
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
) AS property_stats
JOIN Property p ON property_stats.property_id = p.property_id
ORDER BY property_stats.average_rating DESC;

-- 2. Correlated subquery: Find users who have made more than 3 bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_bookings
FROM User u
WHERE (SELECT COUNT(*) 
       FROM Booking b 
       WHERE b.user_id = u.user_id) > 3
ORDER BY total_bookings DESC;
