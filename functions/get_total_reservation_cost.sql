CREATE FUNCTION get_total_reservation_cost (@reservation_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @base_price DECIMAL(10,2);
    DECLARE @reserved_seats INT;
    DECLARE @unit_price DECIMAL(10,2);
    DECLARE @additions_price DECIMAL(10,2);

    SELECT @unit_price = price, @reserved_seats = reserved_seats
    FROM Reservations
    WHERE reservation_id = @reservation_id;

    SELECT @additions_price = ISNULL(SUM(price * reserved_seats), 0)
    FROM Addition_reservations
    WHERE reservation_id = @reservation_id;

    RETURN ISNULL(@unit_price * @reserved_seats, 0) + @additions_price;
END;