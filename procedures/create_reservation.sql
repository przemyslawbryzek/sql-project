CREATE PROCEDURE create_reservation
    @client_id INT,
    @trip_id INT,
    @reserved_seats INT,
    @reservation_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Clients WHERE client_id = @client_id)
    BEGIN
        RAISERROR('Client not found.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Trips WHERE trip_id = @trip_id)
    BEGIN
        RAISERROR('Trip not found.', 16, 1);
        RETURN;
    END
    IF @reserved_seats <= 0
    BEGIN
        RAISERROR('Reserved seats must be greater than 0.', 16, 1);
        RETURN;
    END

    IF dbo.get_free_trip_seats(@trip_id) < @reserved_seats
    BEGIN
        RAISERROR('Not enough free trip seats.', 16, 1);
        RETURN;
    END
    DECLARE @unit_trip_price DECIMAL(10, 2);
    SELECT @unit_trip_price = price
    FROM Trips
    WHERE trip_id = @trip_id;
    INSERT INTO Reservations (
        client_id,
        trip_id,
        reserved_seats,
        price
    )
    VALUES (
        @client_id,
        @trip_id,
        @reserved_seats,
        @unit_trip_price
    );
    SET @reservation_id = SCOPE_IDENTITY();
END;