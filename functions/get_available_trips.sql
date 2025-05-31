CREATE FUNCTION get_available_trips ()
RETURNS TABLE
AS
RETURN
(
    SELECT
        T.trip_id,
        T.trip_name,
        T.departure_date,
        T.price,
        dbo.get_free_trip_seats(T.trip_id) AS remaining_seats
    FROM Trips T
    WHERE dbo.get_free_trip_seats(T.trip_id) > 0
);