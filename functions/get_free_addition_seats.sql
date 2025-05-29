CREATE FUNCTION get_free_addition_seats (@addition_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @seat_limit INT;
    DECLARE @reserved_seats INT;
    SELECT @seat_limit = seat_limit FROM Additions WHERE addition_id = @addition_id;
    SELECT @reserved_seats = ISNULL(SUM(ar.reserved_seats), 0)
    FROM Addition_reservations ar
    JOIN Reservations r ON ar.reservation_id = r.reservation_id
    WHERE ar.addition_id = @addition_id AND r.status <> 'cancelled';
    RETURN @seat_limit - @reserved_seats;
END;