Explanation of DDL

Data Types:
	-UUID is used for primary keys (user_id, property_id, etc.) to ensure unique identifiers.
	-VARCHAR lengths are specified (e.g., email VARCHAR(100), name VARCHAR(100)) to accommodate realistic data while optimizing storage.
	-DECIMAL(10, 2) is used for pricepernight, total_price, and amount to handle currency with two decimal places (e.g., 99999999.99).
	-ENUM is used for role, status, and payment_method to restrict values to predefined options.
	-TIMESTAMP with DEFAULT CURRENT_TIMESTAMP is used for created_at and updated_at to track record creation and updates.
	-TEXT is used for description, comment, and message_body to allow flexible, large text inputs.

Primary Keys:
	-Each table has a UUID primary key, which is automatically indexed by the database system for fast lookups.

Foreign Keys:
Foreign key constraints ensure referential integrity:
	-Property.host_id references User(user_id).
	-Booking.property_id references Property(property_id).
	-Booking.user_id references User(user_id).
	-Payment.booking_id references Booking(booking_id).
	-Review.property_id and Review.user_id reference Property(property_id) and User(user_id), respectively.
	-Message.sender_id and Message.recipient_id reference User(user_id).
ON DELETE RESTRICT prevents deletion of referenced records (e.g., a user cannot be deleted if they have properties or bookings).

Constraints:
	-NOT NULL is applied to required fields (e.g., first_name, email, pricepernight).
	-UNIQUE constraint on User.email ensures no duplicate emails.
	-CHECK (rating >= 1 AND rating <= 5) in Review restricts rating to values between 1 and 5.
	-ENUM fields (role, status, payment_method) inherently restrict values to the specified options.

Indexes:
	-Primary keys (user_id, property_id, etc.) are automatically indexed.
	-Additional indexes are created as specified:
		-idx_user_email on User.email for fast email-based lookups (e.g., login queries).
		-idx_property_id on Property.property_id (though redundant due to primary key, included for clarity).
		-idx_booking_property_id on Booking.property_id for efficient joins and queries by property.
		-idx_booking_id on Booking.booking_id (redundant but included per specification).
		-idx_payment_booking_id on Payment.booking_id for efficient payment lookups by booking.
		-idx_review_property_id on Review.property_id for fast retrieval of reviews by property.
	-No additional indexes were created for Message table fields (e.g., sender_id, recipient_id), as they were not specified, but they could be added if frequent queries on these columns are expected.

Notes:
	-The ON UPDATE CURRENT_TIMESTAMP for Property.updated_at ensures the timestamp updates automatically when the record is modified.
	-The ON DELETE RESTRICT policy ensures data integrity by preventing deletion of records that are referenced elsewhere (e.g., a property cannot be deleted if it has bookings).
	-The schema assumes a database system supporting UUID (e.g., PostgreSQL). If using MySQL, ensure the UUID type or equivalent (e.g., CHAR(36)) is supported.
