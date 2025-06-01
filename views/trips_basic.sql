CREATE VIEW trips_basic AS
SELECT 
    trip_id,
    trip_name,
    departure_date,
    price,
    dbo.get_free_trip_seats(trip_id) AS available_seats,
    CASE 
        WHEN departure_date > GETDATE() THEN 'Dostępna'
        ELSE 'Zakończona'
    END AS status
FROM Trips
WHERE departure_date >= DATEADD(day, -30, GETDATE()); 