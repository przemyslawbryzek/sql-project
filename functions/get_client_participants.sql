CREATE FUNCTION get_client_participants (@client_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.first_name AS participant_first_name,
        P.last_name AS participant_last_name,
        T.trip_name,
        R.reservation_id
    FROM Participants P
    JOIN Reservations R ON P.reservation_id = R.reservation_id
    JOIN Trips T ON R.trip_id = T.trip_id
    WHERE R.client_id = @client_id
);