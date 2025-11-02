-- Indexes for User table
-- Primary key index already exists on user_id

-- Index for email (frequent lookups, authentication)
CREATE INDEX idx_user_email_lookup ON User(email);

-- Index for role-based queries (admin reports, user segmentation)
CREATE INDEX idx_user_role ON User(role);

-- Composite index for user search and filtering
CREATE INDEX idx_user_name_search ON User(first_name, last_name);

-- Index for created_at (analytics, reporting)
CREATE INDEX idx_user_created_at ON User(created_at);

-- Indexes for Property table
-- Primary key index already exists on property_id

-- Index for host_id (frequent JOINs with User table)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index for location-based searches
CREATE INDEX idx_property_location ON Property(location);

-- Index for price filtering and sorting
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Composite index for location and price searches
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- Index for created_at and updated_at (analytics)
CREATE INDEX idx_property_created_at ON Property(created_at);
CREATE INDEX idx_property_updated_at ON Property(updated_at);

-- Indexes for Booking table
-- Primary key index already exists on booking_id

-- Index for property_id (frequent JOINs with Property table)
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index for user_id (frequent JOINs with User table)
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index for status filtering (business logic, reporting)
CREATE INDEX idx_booking_status ON Booking(status);

-- Composite index for user and status queries
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);

-- Index for date range queries (availability checks, reporting)
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Composite index for property and date queries (availability)
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Index for created_at (analytics, reporting)
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Indexes for Review table
-- Index for property_id (JOINs and property reviews)
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index for user_id (user review history)
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Composite index for property rating analysis
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- Index for created_at (recent reviews, analytics)
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Indexes for Payment table
-- Index for booking_id (JOINs with Booking table)
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index for payment_date (financial reporting)
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Indexes for Message table
-- Index for sender_id and recipient_id (message threads)
CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Composite index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- Index for sent_at (recent messages, analytics)
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Specialized composite indexes for common query patterns

-- Composite index for user booking history with dates
CREATE INDEX idx_user_booking_history ON Booking(user_id, created_at DESC, status);

-- Composite index for host property management
CREATE INDEX idx_host_property_management ON Property(host_id, created_at DESC);

-- Composite index for property availability and pricing
CREATE INDEX idx_property_search ON Property(location, pricepernight, created_at DESC);

-- Partial indexes for optimized specific queries

-- Index for active bookings only
CREATE INDEX idx_booking_active ON Booking(status) WHERE status IN ('pending', 'confirmed');

-- Index for confirmed payments only
CREATE INDEX idx_payment_confirmed ON Payment(payment_date) WHERE payment_date IS NOT NULL;
