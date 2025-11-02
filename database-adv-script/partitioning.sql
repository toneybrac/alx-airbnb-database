-- Partitioning Large Tables Implementation

-- Step 1: Check if partitioning is supported and current table structure
SELECT TABLE_NAME, PARTITION_NAME, PARTITION_ORDINAL_POSITION, TABLE_ROWS
FROM information_schema.PARTITIONS
WHERE TABLE_NAME = 'Booking' AND TABLE_SCHEMA = DATABASE();

-- Step 2: Create a new partitioned version of the Booking table
-- First, create a new partitioned table
CREATE TABLE Booking_Partitioned (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_booking_property_id (property_id),
    INDEX idx_booking_user_id (user_id),
    INDEX idx_booking_status (status),
    INDEX idx_booking_created_at (created_at),
    INDEX idx_booking_dates (start_date, end_date),
    CONSTRAINT fk_booking_property_part FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT,
    CONSTRAINT fk_booking_user_part FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE RESTRICT
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_2025 VALUES LESS THAN (2026),
    PARTITION p_2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Alternative: Monthly partitioning for more granularity
CREATE TABLE Booking_Partitioned_Monthly (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_booking_property_id (property_id),
    INDEX idx_booking_user_id (user_id),
    INDEX idx_booking_status (status),
    INDEX idx_booking_created_at (created_at),
    INDEX idx_booking_dates (start_date, end_date),
    CONSTRAINT fk_booking_property_part_monthly FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT,
    CONSTRAINT fk_booking_user_part_monthly FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE RESTRICT
)
PARTITION BY RANGE (TO_DAYS(start_date)) (
    PARTITION p_2024_q1 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_2024_q2 VALUES LESS THAN (TO_DAYS('2024-07-01')),
    PARTITION p_2024_q3 VALUES LESS THAN (TO_DAYS('2024-10-01')),
    PARTITION p_2024_q4 VALUES LESS THAN (TO_DAYS('2025-01-01')),
    PARTITION p_2025_q1 VALUES LESS THAN (TO_DAYS('2025-04-01')),
    PARTITION p_2025_q2 VALUES LESS THAN (TO_DAYS('2025-07-01')),
    PARTITION p_2025_q3 VALUES LESS THAN (TO_DAYS('2025-10-01')),
    PARTITION p_2025_q4 VALUES LESS THAN (TO_DAYS('2026-01-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Step 3: Copy data from original Booking table to partitioned table
-- For annual partitioning
INSERT INTO Booking_Partitioned 
SELECT * FROM Booking;

-- For monthly partitioning  
INSERT INTO Booking_Partitioned_Monthly
SELECT * FROM Booking;

-- Step 4: Verify data distribution across partitions
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH
FROM information_schema.PARTITIONS
WHERE TABLE_NAME = 'Booking_Partitioned' 
AND TABLE_SCHEMA = DATABASE();

-- Step 5: Create a view for seamless application transition
CREATE VIEW Booking_View AS
SELECT * FROM Booking_Partitioned;

-- Step 6: Partition maintenance operations

-- Add new partition for 2027
ALTER TABLE Booking_Partitioned 
REORGANIZE PARTITION p_future INTO (
    PARTITION p_2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Merge partitions if needed
ALTER TABLE Booking_Partitioned 
REORGANIZE PARTITION p_2023, p_2024 INTO (
    PARTITION p_historical VALUES LESS THAN (2025)
);

-- Step 7: Create stored procedures for partition management

DELIMITER //

-- Procedure to automatically maintain partitions
CREATE PROCEDURE MaintainBookingPartitions()
BEGIN
    DECLARE current_year INT;
    DECLARE next_year INT;
    SET current_year = YEAR(CURDATE());
    SET next_year = current_year + 1;
    
    -- Add partition for next year if it doesn't exist
    SET @sql = CONCAT(
        'ALTER TABLE Booking_Partitioned REORGANIZE PARTITION p_future INTO (',
        'PARTITION p_', next_year, ' VALUES LESS THAN (', next_year + 1, '),',
        'PARTITION p_future VALUES LESS THAN MAXVALUE)'
    );
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SELECT 'Partitions maintained successfully' AS result;
END//

DELIMITER ;

-- Step 8: Subpartitioning example (if needed for very large tables)
CREATE TABLE Booking_Subpartitioned (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_booking_property_id (property_id),
    INDEX idx_booking_user_id (user_id),
    INDEX idx_booking_status (status)
)
PARTITION BY RANGE (YEAR(start_date))
SUBPARTITION BY HASH(MONTH(start_date))
SUBPARTITIONS 12 (
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_2025 VALUES LESS THAN (2026),
    PARTITION p_2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Step 9: Query to check partition pruning
EXPLAIN PARTITIONS 
SELECT * FROM Booking_Partitioned 
WHERE start_date BETWEEN '2025-01-01' AND '2025-12-31';

-- Step 10: Create indexes optimized for partitioned queries
CREATE INDEX idx_booking_partitioned_dates 
ON Booking_Partitioned (start_date, end_date, status);

CREATE INDEX idx_booking_partitioned_user_dates 
ON Booking_Partitioned (user_id, start_date, status);

CREATE INDEX idx_booking_partitioned_property_dates 
ON Booking_Partitioned (property_id, start_date, status);
