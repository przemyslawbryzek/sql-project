CREATE PROCEDURE add_participant
    @reservation_id INT,
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @participant_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Reservations WHERE reservation_id = @reservation_id)
    BEGIN
        RAISERROR('Reservation not found.', 16, 1);
        RETURN;
    END
    DECLARE @current_participants INT;
    SELECT @current_participants = COUNT(*)
    FROM Participants
    WHERE reservation_id = @reservation_id;

    DECLARE @reserved_seats INT;
    SELECT @reserved_seats = reserved_seats
    FROM Reservations
    WHERE reservation_id = @reservation_id;

    IF @current_participants >= @reserved_seats
    BEGIN
        RAISERROR('Cannot add more participants than reserved seats.', 16, 1);
        RETURN;
    END
    IF @first_name IS NULL OR @last_name IS NULL
    BEGIN
        RAISERROR('First name and last name are required.', 16, 1);
        RETURN;
    END
    SET NOCOUNT ON;
    INSERT INTO Participants (
        reservation_id,
        first_name,
        last_name
    )
    VALUES (
        @reservation_id,
        @first_name,
        @last_name
    );
    SET @participant_id = SCOPE_IDENTITY();
END;