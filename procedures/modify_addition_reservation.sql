CREATE PROCEDURE modify_addition_reservation
    @addition_reservation_id INT,
    @new_reserved_seats INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Addition_reservations WHERE addition_reservation_id = @addition_reservation_id)
    BEGIN
        RAISERROR('Addition reservation not found.', 16, 1);
        RETURN;
    END

    DECLARE @addition_id INT, @reservation_id INT, @trip_id INT, @reservation_status VARCHAR(20);
    
    SELECT 
        @addition_id = ar.addition_id, 
        @reservation_id = ar.reservation_id,
        @reservation_status = r.status
    FROM Addition_reservations ar
    JOIN Reservations r ON ar.reservation_id = r.reservation_id
    WHERE ar.addition_reservation_id = @addition_reservation_id;

    IF @reservation_status = 'cancelled'
    BEGIN
        RAISERROR('Cannot modify addition for a cancelled reservation.', 16, 1);
        RETURN;
    END

    SELECT @trip_id = trip_id
    FROM Reservations
    WHERE reservation_id = @reservation_id;

    DECLARE @departure_date DATE;
    SELECT @departure_date = departure_date FROM Trips WHERE trip_id = @trip_id;

    IF DATEDIFF(DAY, GETDATE(), @departure_date) < 7
    BEGIN
        RAISERROR('Cannot modify addition reservation within 7 days before trip.', 16, 1);
        RETURN;
    END

    IF @new_reserved_seats <= 0
    BEGIN
        RAISERROR('Reserved seats must be greater than 0.', 16, 1);
        RETURN;
    END

    DECLARE @current_reserved_seats INT;
    SELECT @current_reserved_seats = reserved_seats 
    FROM Addition_reservations 
    WHERE addition_reservation_id = @addition_reservation_id;

    DECLARE @assigned_participants INT;
    SELECT @assigned_participants = COUNT(*) 
    FROM Addition_participants
    WHERE addition_reservation_id = @addition_reservation_id;

    IF @new_reserved_seats < @assigned_participants
    BEGIN
        RAISERROR('Cannot reduce addition seats below the number of assigned participants (%d).', 16, 1, @assigned_participants);
        RETURN;
    END

    DECLARE @available_seats INT;
    SET @available_seats = dbo.get_free_addition_seats(@addition_id) + @current_reserved_seats;

    IF @available_seats < @new_reserved_seats
    BEGIN
        RAISERROR('Not enough available seats for the addition.', 16, 1);
        RETURN;
    END

    UPDATE Addition_reservations
    SET reserved_seats = @new_reserved_seats
    WHERE addition_reservation_id = @addition_reservation_id;
    
END;