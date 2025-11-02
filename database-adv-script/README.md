# Complex SQL Queries with Joins

This repository contains SQL queries demonstrating different types of joins for the Airbnb database.

## Queries Overview

### 1. INNER JOIN - Bookings with Users
**Purpose**: Retrieve all bookings along with the user information for users who made those bookings.

**Key Points**:
- Returns only records that have matching values in both tables
- Excludes bookings without associated users and users without bookings
- Useful for getting complete booking information with user details

### 2. LEFT JOIN - Properties with Reviews
**Purpose**: Retrieve all properties and their reviews, including properties that have no reviews.

**Key Points**:
- Returns all records from the left table (properties) and matched records from the right table (reviews)
- Properties without reviews will have NULL values in review-related columns
- Essential for analyzing property performance including unreviewed properties

### 3. FULL OUTER JOIN - Users and Bookings
**Purpose**: Retrieve all users and all bookings, including users without bookings and bookings not linked to users.

**Key Points**:
- Returns all records when there's a match in either left or right table
- Shows users without any bookings and orphaned bookings without users
- Helpful for data integrity checks and comprehensive reporting

## Database Schema Assumptions

The queries assume the following table structure:

### Users Table
- `user_id` (Primary Key)
- `username`
- `email`
- `first_name`
- `last_name`

### Bookings Table
- `booking_id` (Primary Key)
- `user_id` (Foreign Key)
- `property_id` (Foreign Key)
- `check_in_date`
- `check_out_date`
- `total_price`
- `status`

### Properties Table
- `property_id` (Primary Key)
- `title`
- `description`
- `price_per_night`

### Reviews Table
- `review_id` (Primary Key)
- `property_id` (Foreign Key)
- `user_id` (Foreign Key)
- `rating`
- `comment`
- `created_at`

## Usage

1. Execute the queries in your SQL database management system
2. Modify table and column names according to your actual database schema
3. Adjust the ORDER BY clauses as needed for your specific use case

## Notes

- The FULL OUTER JOIN query includes ordering that prioritizes users with bookings first
- All queries include comprehensive column selection for better data analysis
- Consider adding WHERE clauses for filtering specific date ranges or statuses
