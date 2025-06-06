-- Add Trips
INSERT INTO Trips (trip_name,country_code, departure_date, price, seat_limit) VALUES
('Summer Adventure in the Mountains','PL', '2025-07-15', 500.00, 30),
('Coastal Escape Weekend','ES', '2025-08-01', 350.00, 20),
('Historical City Tour','AT', '2025-09-10', 400.00, 25),
('Skiing Holiday in Alps','IT', '2026-01-20', 1200.00, 15),
('Desert Safari Experience','EG','2025-11-05', 750.00, 18);

-- Add Clients using procedure
DECLARE @client_id_1 INT;
DECLARE @client_id_2 INT;
DECLARE @client_id_3 INT;
DECLARE @client_id_4 INT;
DECLARE @client_id_5 INT;

EXEC add_client
    @client_type = 'individual',
    @first_name = 'John',
    @last_name = 'Doe',
    @email = 'john.doe@example.com',
    @phone = '123-456-7890',
    @address = '123 Main St, Anytown',
    @client_id = @client_id_1 OUTPUT;

EXEC add_client
    @client_type = 'company',
    @company_name = 'Tech Solutions Inc.',
    @email = 'contact@techsolutions.com',
    @phone = '987-654-3210',
    @address = '456 Business Rd, Corp City',
    @client_id = @client_id_2 OUTPUT;

EXEC add_client
    @client_type = 'individual',
    @first_name = 'Alice',
    @last_name = 'Smith',
    @email = 'alice.smith@example.com',
    @phone = '555-123-4567',
    @address = '789 Oak Ave, Villagetown',
    @client_id = @client_id_3 OUTPUT;

EXEC add_client
    @client_type = 'individual',
    @first_name = 'Robert',
    @last_name = 'Jones',
    @email = 'robert.jones@example.com',
    @phone = '555-987-6543',
    @address = '101 Pine Ln, Hamletville',
    @client_id = @client_id_4 OUTPUT;

EXEC add_client
    @client_type = 'company',
    @company_name = 'Global Goods Ltd.',
    @email = 'info@globalgoods.com',
    @phone = '111-222-3333',
    @address = '202 Commerce St, Tradeburg',
    @client_id = @client_id_5 OUTPUT;


-- Add Reservations using procedure
DECLARE @reservation_id_1 INT;
DECLARE @reservation_id_2 INT;
DECLARE @reservation_id_3 INT;
DECLARE @reservation_id_4 INT;
DECLARE @reservation_id_5 INT;

EXEC create_reservation
    @client_id = @client_id_1,
    @trip_id = 1, -- Summer Adventure in the Mountains
    @reserved_seats = 2,
    @reservation_id = @reservation_id_1 OUTPUT;

EXEC create_reservation
    @client_id = @client_id_2,
    @trip_id = 2, -- Coastal Escape Weekend
    @reserved_seats = 5,
    @reservation_id = @reservation_id_2 OUTPUT;

EXEC create_reservation
    @client_id = @client_id_3,
    @trip_id = 1, -- Summer Adventure in the Mountains
    @reserved_seats = 1,
    @reservation_id = @reservation_id_3 OUTPUT;

EXEC create_reservation
    @client_id = @client_id_4,
    @trip_id = 3, -- Historical City Tour
    @reserved_seats = 3,
    @reservation_id = @reservation_id_4 OUTPUT;

EXEC create_reservation
    @client_id = @client_id_5,
    @trip_id = 5, -- Desert Safari Experience
    @reserved_seats = 10,
    @reservation_id = @reservation_id_5 OUTPUT;
-- Add Participants using procedure
DECLARE @participant_id_1 INT, @participant_id_2 INT, @participant_id_3 INT, @participant_id_4 INT, @participant_id_5 INT;
DECLARE @participant_id_6 INT, @participant_id_7 INT, @participant_id_8 INT, @participant_id_9 INT, @participant_id_10 INT;
DECLARE @participant_id_11 INT, @participant_id_12 INT, @participant_id_13 INT, @participant_id_14 INT, @participant_id_15 INT;
DECLARE @participant_id_16 INT, @participant_id_17 INT, @participant_id_18 INT, @participant_id_19 INT, @participant_id_20 INT;
DECLARE @participant_id_21 INT;


-- Reservation 1 (2 seats)
EXEC add_participant @reservation_id = @reservation_id_1, @first_name = 'Michael', @last_name = 'Brown', @participant_id = @participant_id_1 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_1, @first_name = 'Emily', @last_name = 'Davis', @participant_id = @participant_id_2 OUTPUT;

-- Reservation 2 (5 seats)
EXEC add_participant @reservation_id = @reservation_id_2, @first_name = 'David', @last_name = 'Wilson', @participant_id = @participant_id_3 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_2, @first_name = 'Sarah', @last_name = 'Miller', @participant_id = @participant_id_4 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_2, @first_name = 'James', @last_name = 'Garcia', @participant_id = @participant_id_5 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_2, @first_name = 'Linda', @last_name = 'Rodriguez', @participant_id = @participant_id_6 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_2, @first_name = 'Christopher', @last_name = 'Martinez', @participant_id = @participant_id_7 OUTPUT;

-- Reservation 3 (1 seat)
EXEC add_participant @reservation_id = @reservation_id_3, @first_name = 'Jessica', @last_name = 'Lee', @participant_id = @participant_id_8 OUTPUT;

-- Reservation 4 (3 seats)
EXEC add_participant @reservation_id = @reservation_id_4, @first_name = 'Daniel', @last_name = 'Harris', @participant_id = @participant_id_9 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_4, @first_name = 'Ashley', @last_name = 'Clark', @participant_id = @participant_id_10 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_4, @first_name = 'Kevin', @last_name = 'Lewis', @participant_id = @participant_id_11 OUTPUT;

-- Reservation 5 (10 seats)
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Laura', @last_name = 'Walker', @participant_id = @participant_id_12 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Brian', @last_name = 'Hall', @participant_id = @participant_id_13 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Nancy', @last_name = 'Allen', @participant_id = @participant_id_14 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Paul', @last_name = 'Young', @participant_id = @participant_id_15 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Karen', @last_name = 'King', @participant_id = @participant_id_16 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Mark', @last_name = 'Wright', @participant_id = @participant_id_17 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Betty', @last_name = 'Scott', @participant_id = @participant_id_18 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Steven', @last_name = 'Green', @participant_id = @participant_id_19 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'Donna', @last_name = 'Adams', @participant_id = @participant_id_20 OUTPUT;
EXEC add_participant @reservation_id = @reservation_id_5, @first_name = 'George', @last_name = 'Baker', @participant_id = @participant_id_21 OUTPUT;

-- Add Additions
INSERT INTO Additions (trip_id, addition_name, price, seat_limit) VALUES
(1, 'Mountain Bike Rental', 50.00, 10), -- For Summer Adventure
(1, 'Guided Hiking Tour', 30.00, 15),    -- For Summer Adventure
(2, 'Surfboard Rental', 40.00, 8),       -- For Coastal Escape
(2, 'Beach Yoga Session', 25.00, 10),    -- For Coastal Escape
(3, 'Museum Pass', 20.00, 20),           -- For Historical City Tour
(3, 'Private Guide', 100.00, 5),         -- For Historical City Tour
(4, 'Ski Equipment Rental', 80.00, 10),  -- For Skiing Holiday
(4, 'Snowboarding Lessons', 120.00, 5),  -- For Skiing Holiday
(5, 'Camel Ride', 60.00, 12),            -- For Desert Safari
(5, 'Dune Bashing', 90.00, 10);           -- For Desert Safari


-- Add Addition Reservations using procedure
DECLARE @add_res_id_1 INT, @add_res_id_2 INT, @add_res_id_3 INT, @add_res_id_4 INT, @add_res_id_5 INT;
DECLARE @add_res_id_6 INT, @add_res_id_7 INT;

-- Reservation 1 (Summer Adventure, 2 people)
-- Michael and Emily rent mountain bikes
EXEC create_addition_reservation @reservation_id = @reservation_id_1, @addition_id = 1, @reserved_seats = 2, @addition_reservation_id = @add_res_id_1 OUTPUT;
-- Michael also goes on a guided hiking tour
EXEC create_addition_reservation @reservation_id = @reservation_id_1, @addition_id = 2, @reserved_seats = 1, @addition_reservation_id = @add_res_id_2 OUTPUT;

-- Reservation 2 (Coastal Escape, 5 people)
-- 3 people rent surfboards
EXEC create_addition_reservation @reservation_id = @reservation_id_2, @addition_id = 3, @reserved_seats = 3, @addition_reservation_id = @add_res_id_3 OUTPUT;
-- 2 people do beach yoga
EXEC create_addition_reservation @reservation_id = @reservation_id_2, @addition_id = 4, @reserved_seats = 2, @addition_reservation_id = @add_res_id_4 OUTPUT;

-- Reservation 4 (Historical City Tour, 3 people)
-- All 3 get museum passes
EXEC create_addition_reservation @reservation_id = @reservation_id_4, @addition_id = 5, @reserved_seats = 3, @addition_reservation_id = @add_res_id_5 OUTPUT;

-- Reservation 5 (Desert Safari, 10 people)
-- 5 people go for a camel ride
EXEC create_addition_reservation @reservation_id = @reservation_id_5, @addition_id = 9, @reserved_seats = 5, @addition_reservation_id = @add_res_id_6 OUTPUT;
-- All 10 go dune bashing
EXEC create_addition_reservation @reservation_id = @reservation_id_5, @addition_id = 10, @reserved_seats = 10, @addition_reservation_id = @add_res_id_7 OUTPUT;

-- Add Addition Participants using procedure

-- For @add_res_id_1 (Mountain Bike Rental for Reservation 1, 2 seats)
EXEC add_addition_participant @addition_reservation_id = @add_res_id_1, @participant_id = @participant_id_1; -- Michael
EXEC add_addition_participant @addition_reservation_id = @add_res_id_1, @participant_id = @participant_id_2; -- Emily

-- For @add_res_id_2 (Guided Hiking Tour for Reservation 1, 1 seat)
EXEC add_addition_participant @addition_reservation_id = @add_res_id_2, @participant_id = @participant_id_1; -- Michael

-- For @add_res_id_3 (Surfboard Rental for Reservation 2, 3 seats)
EXEC add_addition_participant @addition_reservation_id = @add_res_id_3, @participant_id = @participant_id_3; -- David
EXEC add_addition_participant @addition_reservation_id = @add_res_id_3, @participant_id = @participant_id_4; -- Sarah
EXEC add_addition_participant @addition_reservation_id = @add_res_id_3, @participant_id = @participant_id_5; -- James

-- For @add_res_id_4 (Beach Yoga Session for Reservation 2, 2 seats)
EXEC add_addition_participant @addition_reservation_id = @add_res_id_4, @participant_id = @participant_id_6; -- Linda
EXEC add_addition_participant @addition_reservation_id = @add_res_id_4, @participant_id = @participant_id_7; -- Christopher

-- For @add_res_id_5 (Museum Pass for Reservation 4, 3 seats)
EXEC add_addition_participant @addition_reservation_id = @add_res_id_5, @participant_id = @participant_id_9;  -- Daniel
EXEC add_addition_participant @addition_reservation_id = @add_res_id_5, @participant_id = @participant_id_10; -- Ashley
EXEC add_addition_participant @addition_reservation_id = @add_res_id_5, @participant_id = @participant_id_11; -- Kevin

-- For @add_res_id_6 (Camel Ride for Reservation 5, 5 seats)
EXEC add_addition_participant @addition_reservation_id = @add_res_id_6, @participant_id = @participant_id_12; -- Laura
EXEC add_addition_participant @addition_reservation_id = @add_res_id_6, @participant_id = @participant_id_13; -- Brian
EXEC add_addition_participant @addition_reservation_id = @add_res_id_6, @participant_id = @participant_id_14; -- Nancy
EXEC add_addition_participant @addition_reservation_id = @add_res_id_6, @participant_id = @participant_id_15; -- Paul
EXEC add_addition_participant @addition_reservation_id = @add_res_id_6, @participant_id = @participant_id_16; -- Karen

-- For @add_res_id_7 (Dune Bashing for Reservation 5, 10 seats)
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_12; -- Laura
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_13; -- Brian
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_14; -- Nancy
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_15; -- Paul
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_16; -- Karen
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_17; -- Mark
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_18; -- Betty
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_19; -- Steven
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_20; -- Donna
EXEC add_addition_participant @addition_reservation_id = @add_res_id_7, @participant_id = @participant_id_21; -- George

-- Add Payments using procedure
-- Some reservations will be fully paid, some partially, some not at all.
-- Payments will include costs for additions.

-- Reservation 1: Fully paid (Trip: 2 * 500 = 1000) + (Additions: Bike 2*50=100, Hike 1*30=30) = 1130
EXEC add_payment @reservation_id = @reservation_id_1, @amount = 1130.00, @payment_method = 'Credit Card', @payment_date = '2025-06-01';

-- Reservation 2: Partially paid (Trip: 5 * 350 = 1750) + (Additions: Surf 3*40=120, Yoga 2*25=50) = 1920. Paid 1000.
EXEC add_payment @reservation_id = @reservation_id_2, @amount = 1000.00, @payment_method = 'Bank Transfer', @payment_date = '2025-06-02';

-- Reservation 3: No payment yet (Trip: 1 * 500 = 500). No additions.

-- Reservation 4: Fully paid (Trip: 3 * 400 = 1200) + (Additions: Museum 3*20=60) = 1260
EXEC add_payment @reservation_id = @reservation_id_4, @amount = 1260.00, @payment_method = 'Credit Card', @payment_date = '2025-06-04';

-- Reservation 5: Partially paid (Trip: 10 * 750 = 7500) + (Additions: Camel 5*60=300, Dune 10*90=900) = 8700. Paid 5000.
EXEC add_payment @reservation_id = @reservation_id_5, @amount = 5000.00, @payment_method = 'Company Account', @payment_date = '2025-06-05';