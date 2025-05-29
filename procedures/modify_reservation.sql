CREATE PROCEDURE modify_reservation
    @reservation_id INT,
    @new_reserved_seats INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Reservations WHERE reservation_id = @reservation_id)
    BEGIN
        RAISERROR('Reservation not found.', 16, 1);
        RETURN;
    END

    DECLARE @trip_id INT;
    DECLARE @departure_date DATE;
    DECLARE @reservation_status VARCHAR(20);
    
    SELECT 
        @trip_id = r.trip_id, 
        @departure_date = t.departure_date,
        @reservation_status = r.status
    FROM Reservations r
    JOIN Trips t ON r.trip_id = t.trip_id
    WHERE r.reservation_id = @reservation_id;

    IF @reservation_status = 'cancelled'
    BEGIN
        RAISERROR('Cannot modify a cancelled reservation.', 16, 1);
        RETURN;
    END

    IF DATEDIFF(DAY, GETDATE(), @departure_date) < 7
    BEGIN
        RAISERROR('Cannot modify reservation within 7 days before trip.', 16, 1);
        RETURN;
    END

    IF @new_reserved_seats <= 0
    BEGIN
        RAISERROR('Reserved seats must be greater than 0.', 16, 1);
        RETURN;
    END

    DECLARE @current_reserved_seats INT;
    SELECT @current_reserved_seats = reserved_seats 
    FROM Reservations 
    WHERE reservation_id = @reservation_id;

    DECLARE @assigned_participants INT;
    SELECT @assigned_participants = COUNT(*) 
    FROM Participants 
    WHERE reservation_id = @reservation_id;

    IF @new_reserved_seats < @assigned_participants
    BEGIN
        RAISERROR('Cannot reduce seats below the number of assigned participants (%d).', 16, 1, @assigned_participants);
        RETURN;
    END

    DECLARE @available_seats INT;
    SET @available_seats = dbo.get_free_trip_seats(@trip_id) + @current_reserved_seats;

    IF @available_seats < @new_reserved_seats
    BEGIN
        RAISERROR('Not enough available seats for this change.', 16, 1);
        RETURN;
    END

    UPDATE Reservations
    SET reserved_seats = @new_reserved_seats
    WHERE reservation_id = @reservation_id;
END;