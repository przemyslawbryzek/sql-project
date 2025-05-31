CREATE FUNCTION get_client_payments (@client_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.payment_id,
        R.reservation_id,
        P.payment_date,
        P.amount,
        P.payment_method,
        T.trip_name
    FROM Payments P
    JOIN Reservations R ON P.reservation_id = R.reservation_id
    JOIN Trips T ON R.trip_id = T.trip_id
    WHERE R.client_id = @client_id
);