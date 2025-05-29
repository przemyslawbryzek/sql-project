CREATE PROCEDURE create_addition_reservation
    @reservation_id INT,
    @addition_id INT,
    @reserved_seats INT,
    @addition_reservation_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Reservations WHERE reservation_id = @reservation_id)
    BEGIN
        RAISERROR('Reservation not found.', 16, 1);
        RETURN;
    END

    DECLARE @trip_id INT;
    SELECT @trip_id = trip_id FROM Reservations WHERE reservation_id = @reservation_id;
    IF NOT EXISTS (SELECT 1 FROM Additions WHERE addition_id = @addition_id AND trip_id = @trip_id)
    BEGIN
        RAISERROR('Addition does not exist for the trip.', 16, 1);
        RETURN;
    END
    IF @reserved_seats <= 0
    BEGIN
        RAISERROR('Reserved seats must be greater than 0.', 16, 1);
        RETURN;
    END
    IF dbo.get_free_addition_seats(@addition_id) < @reserved_seats
    BEGIN
        RAISERROR('Not enough free seats for the addition.', 16, 1);
        RETURN;
    END

    DECLARE @unit_price DECIMAL(10,2);
    SELECT @unit_price = price FROM Additions WHERE addition_id = @addition_id;

    INSERT INTO Addition_reservations (
        reservation_id,
        addition_id,
        reserved_seats,
        price
    )
    VALUES (
        @reservation_id,
        @addition_id,
        @reserved_seats,
        @unit_price
    );
    SET @addition_reservation_id = SCOPE_IDENTITY();
END;