DROP TABLE bookings;
CREATE TABLE bookings (
    Date DATE,
    Time TIME,
    Booking_ID VARCHAR(20),
    Booking_Status VARCHAR(20),
    Customer_ID VARCHAR(20),
    Vehicle_Type VARCHAR(30),
    Pickup_Location VARCHAR(100),
    Drop_Location VARCHAR(100),
    V_TAT NUMERIC(6,2),
    C_TAT NUMERIC(6,2),
    Canceled_Rides_by_Customer VARCHAR(50),
    Canceled_Rides_by_Driver VARCHAR(50),
    Incomplete_Rides VARCHAR(10),
    Incomplete_Rides_Reason TEXT,
    Booking_Value NUMERIC(10,2),
    Payment_Method VARCHAR(20),
    Ride_Distance NUMERIC(6,2),
    Driver_Ratings NUMERIC(3,2),
    Customer_Rating NUMERIC(3,2)
);

COPY bookings (
    Date, Time, Booking_ID, Booking_Status, Customer_ID, Vehicle_Type,
    Pickup_Location, Drop_Location, V_TAT, C_TAT,
    Canceled_Rides_by_Customer, Canceled_Rides_by_Driver, Incomplete_Rides,
    Incomplete_Rides_Reason, Booking_Value, Payment_Method, Ride_Distance,
    Driver_Ratings, Customer_Rating
)
FROM 'C:/SQL_csv_file_access/Bookings-100000-Rows.csv'
DELIMITER ','
CSV HEADER
NULL 'null';

-- Replace the file path below with your local path or move the CSV to project folder
-- and run in a local PostgreSQL environment.


SELECT * FROM bookings;


--1. Retrieve all successful bookings     (Create VIEW for successful bookings)
CREATE VIEW successful_bookings AS
SELECT * FROM bookings
WHERE booking_status = 'Success';

-- Use the VIEW
SELECT * FROM successful_bookings;         

--2. Find the average ride distance for each vehicle type        (Create VIEW for avg_distance_by_vehicle_type)
CREATE VIEW avg_distance_by_vehicle_type AS
SELECT vehicle_type, ROUND(AVG(ride_distance), 2) AS avg_distance
FROM bookings
GROUP BY vehicle_type;

-- Use the VIEW
SELECT * FROM avg_distance_by_vehicle_type;

--3. Get the total number of canceled rides by customers       (Create VIEW for canceled rides by customers)
CREATE VIEW canceled_rides_by_customers AS
SELECT COUNT(*) AS total_canceled_rides 
FROM bookings 
WHERE booking_status = 'Canceled by Customer';

-- Use the VIEW
SELECT * FROM canceled_rides_by_customers;

--4. List the top 5 customers who booked the highest number of rides      (Create VIEW for top 5 customers)
CREATE VIEW top_5_customers AS
SELECT customer_id, COUNT(*) 
FROM bookings 
GROUP BY customer_id
ORDER BY COUNT(*) DESC LIMIT 5;

-- Use the VIEW
SELECT * FROM top_5_customers;

--5. Get the number of rides canceled by drivers due to personal and car related isses     (Create VIEW for canceled_rides_drivers)
CREATE VIEW  canceled_rides_drivers AS
SELECT COUNT(*) AS canceled_rides_drivers
FROM bookings
WHERE canceled_rides_by_driver = 'Personal & Car related issue';

-- Use the VIEW
SELECT * FROM canceled_rides_drivers;

--6. Find the maximum and minimum driver ratings from Prime Sedan bookings     (Create VIEW for max_min_ratings)
CREATE VIEW max_min_ratings AS
SELECT MAX(driver_ratings) AS max_rating,
	   MIN(driver_ratings) AS min_rating
FROM bookings
WHERE vehicle_type = 'Prime Sedan';

-- Use the VIEW
SELECT * FROM max_min_ratings;

--7. Retrieve all rides where payment was made using UPI       (Create VIEW for payment_by_upi)
CREATE VIEW payment_by_upi AS
SELECT * FROM bookings
WHERE payment_method = 'UPI';

-- Use the VIEW
SELECT * FROM payment_by_upi;

--8. Find the average customer rating per vehicle type     (Create VIEW for avg_customer_rating_by_vehicle_type)
CREATE VIEW avg_customer_rating_by_vehicle_type AS
SELECT vehicle_type, ROUND(AVG(customer_rating),2) AS avg_customer_rating
FROM bookings
GROUP BY vehicle_type;

-- Use the VIEW
SELECT * FROM avg_customer_rating_by_vehicle_type;

--9. Calculate the total booking value of rides completed successfully   (Create VIEW for total_successful_ride_value)
CREATE VIEW total_successful_ride_value AS
SELECT SUM(booking_value) AS total_successful_ride_value 
FROM bookings
WHERE booking_status = 'Success';

-- Use the VIEW
SELECT * FROM total_successful_ride_value;

--10. List all incomplete rides along with the reason      (Create VIEW for incomplete_rides_reason)
CREATE VIEW incomplete_rides_reason AS
SELECT booking_id,incomplete_rides, incomplete_rides_reason
FROM bookings
WHERE incomplete_rides = 'Yes';

-- Use the VIEW
SELECT * FROM incomplete_rides_reason;





