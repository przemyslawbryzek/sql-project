CREATE FUNCTION get_client_reservations (@client_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        R.reservation_id,
        T.trip_name,
        T.departure_date,
        R.reserved_seats,
        R.price AS reservation_price,
        R.status AS reservation_status,
        R.reservation_date
    FROM Reservations R
    JOIN Trips T ON R.trip_id = T.trip_id
    WHERE R.client_id = @client_id
);