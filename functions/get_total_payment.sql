CREATE FUNCTION get_total_payment (@reservation_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);
    SELECT @total = ISNULL(SUM(amount), 0)
    FROM Payments
    WHERE reservation_id = @reservation_id;
    RETURN @total;
END;