Explanation of Sample Data

User Table (5 records):
	-Includes two guests (John Doe, Alice Johnson), two hosts (Jane Smith, Bob Brown), and one admin (Admin User).
	-Each user has a unique user_id (UUID), realistic names, emails, and phone numbers.
	-password_hash is a placeholder (e.g., hashed_password_123) to represent secure password storage.
	-role uses valid ENUM values (guest, host, admin).
	-Timestamps are set to early October 2025 for realism.

Property Table (3 records):
	-Three properties owned by hosts Jane Smith and Bob Brown:
		-Cozy Beach Cottage (Miami, $150/night, owned by Jane).
		-Downtown Loft (New York, $200/night, owned by Jane).
		-Mountain Cabin (Denver, $120/night, owned by Bob).
	-host_id references valid user_id values from the User table.
	-Realistic names, descriptions, and locations are provided.
	-pricepernight is set as a reasonable DECIMAL(10, 2) value.

Booking Table (3 records):
	-Three bookings to demonstrate different scenarios:
		-John books the Beach Cottage for 2 nights (Nov 1–3, 2025, $150 * 2 = $300, confirmed).
		-Alice books the Downtown Loft for 2 nights (Nov 5–7, 2025, $200 * 2 = $400, pending).
		-John books the Mountain Cabin for 2 nights (Nov 10–12, 2025, $120 * 2 = $240, canceled).
	-property_id and user_id reference valid records from Property and User.
	-total_price matches pricepernight multiplied by the number of nights.
	-status uses valid ENUM values (pending, confirmed, canceled).

Payment Table (2 records):
	-Payments for two bookings:
		-$300 for John’s Beach Cottage booking (credit card).
		-$400 for Alice’s Downtown Loft booking (Paypal).
	-No payment for the canceled Mountain Cabin booking, reflecting real-world usage.
	-booking_id references valid bookings, and amount matches Booking.total_price.
	-payment_method uses valid ENUM values (credit_card, paypal, stripe).

Review Table (2 records):
	-Reviews for two properties after stays:
		-John reviews the Beach Cottage (5 stars, positive comment).
		-Alice reviews the Downtown Loft (4 stars, constructive comment).
	-property_id and user_id reference valid records.
	-rating satisfies the CHECK constraint (1–5).
	-Timestamps align with booking end dates (e.g., Nov 4 for John’s review after Nov 3).

Message Table (3 records):
	-Messages between users:
		-John asks Jane about the Beach Cottage’s availability.
		-Jane responds to John confirming availability.
		-Alice asks Jane about the Downtown Loft’s amenities.
	-sender_id and recipient_id reference valid user_id values.
	-message_body contains realistic conversation snippets.
	-Timestamps are set before bookings to simulate pre-booking communication.

Notes
UUIDs: Hard-coded UUIDs are used for simplicity (e.g., 550e8400-e29b-41d4-a716-446655440000). In a real system, these would be generated dynamically (e.g., using uuid_generate_v4()).

Realism: The data reflects real-world scenarios:
	-Multiple users with different roles (guests, hosts, admin).
	-Properties in different locations with varying prices.
	-Bookings with different statuses (confirmed, pending, canceled).
	-Payments tied to confirmed/pending bookings.
	-Reviews post-stay with realistic ratings and comments.
	-Messages simulating guest-host communication.

Constraints Compliance: All data adheres to the schema’s constraints:
	-Unique emails in User.
	-Valid foreign key references.
	-ENUM values for role, status, and payment_method.
	-rating values between 1 and 5.
	-Timestamps: Set in October–November 2025 to align with the current date (October 26, 2025) and future booking dates.

This seed data provides a robust starting point for testing the Airbnb database. If you need additional records, specific scenarios (e.g., more bookings or reviews),
 or compatibility with a specific database system, please let me know!
