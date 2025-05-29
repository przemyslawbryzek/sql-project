CREATE PROCEDURE cancel_unpaid_reservations
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @reservation_id_cursor INT;
    DECLARE @total_cost DECIMAL(10, 2);
    DECLARE @total_paid DECIMAL(10, 2);
    DECLARE @trip_departure_date DATE;

    DECLARE reservation_cursor CURSOR FOR
    SELECT r.reservation_id, t.departure_date
    FROM Reservations r
    JOIN Trips t ON r.trip_id = t.trip_id
    WHERE r.status = 'pending' AND t.departure_date <= DATEADD(day, 7, GETDATE());

    OPEN reservation_cursor;
    FETCH NEXT FROM reservation_cursor INTO @reservation_id_cursor, @trip_departure_date;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @total_cost = dbo.get_total_reservation_cost(@reservation_id_cursor);
        SET @total_paid = dbo.get_total_payment(@reservation_id_cursor);
        IF @total_paid < @total_cost
        BEGIN
            UPDATE Reservations
            SET status = 'cancelled'
            WHERE reservation_id = @reservation_id_cursor;
        END

        FETCH NEXT FROM reservation_cursor INTO @reservation_id_cursor, @trip_departure_date;
    END

    CLOSE reservation_cursor;
    DEALLOCATE reservation_cursor;
END;