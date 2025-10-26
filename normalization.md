Explanation of Normalization Steps

1NF Compliance:
	-Ensured all attributes are atomic (e.g., location as a single VARCHAR, email as a single value).
	-Confirmed each table has a primary key (user_id, property_id, etc.).
	-Verified no repeating groups exist.

2NF Compliance:
	-Confirmed all tables use single-column primary keys (UUIDs), eliminating the possibility of partial dependencies.
	-No adjustments were needed, as 2NF is automatically satisfied.

3NF Compliance:
	-Analyzed each table for transitive dependencies and found none:
	-In User, attributes like first_name and email depend only on user_id.
	-In Property, location and pricepernight depend on property_id, with location treated as atomic.
	-In Booking, total_price is stored as an independent value, not derived within the table.
	-Similar checks confirmed 3NF for Payment, Review, and Message.
	-Considered splitting Property.location into a Location table but retained it as VARCHAR for simplicity, as it does not introduce transitive dependencies.
	-Evaluated Booking.total_price and Payment.amount for redundancy but justified their inclusion as deliberate denormalization for practical purposes (e.g., preserving historical prices, supporting partial payments).

Indexing and Constraints:
	-Retained all specified indexes (e.g., on email, property_id, booking_id) to ensure performance.
	-Kept constraints (e.g., unique email, foreign keys, rating check) to maintain data integrity.

Conclusion
	The provided Airbnb database schema is already in 3NF, as it satisfies 1NF, 2NF, and 3NF with no transitive dependencies or redundancies that violate normalization principles. 
	The location field in the Property table could be normalized further into a separate table, but this is unnecessary unless the application requires querying specific address components. 
	Similarly, total_price and amount are retained as stored values to support practical use cases, with no impact on 3NF compliance. The schema is well-designed, with appropriate primary keys,
	foreign keys, constraints, and indexes to ensure data integrity and performance.
