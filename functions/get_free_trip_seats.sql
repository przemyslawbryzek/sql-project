CREATE FUNCTION get_free_trip_seats (@trip_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @seat_limit INT;
    DECLARE @reserved_seats INT;
    SELECT @seat_limit = seat_limit FROM Trips WHERE trip_id = @trip_id;
    SELECT @reserved_seats = ISNULL(SUM(reserved_seats), 0)
    FROM Reservations
    WHERE trip_id = @trip_id AND status <> 'cancelled';
    RETURN @seat_limit - @reserved_seats;
END;