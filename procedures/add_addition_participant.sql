CREATE PROCEDURE add_addition_participant
    @addition_reservation_id INT,
    @participant_id INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Addition_reservations WHERE addition_reservation_id = @addition_reservation_id)
    BEGIN
        RAISERROR('Addition reservation not found.', 16, 1);
        RETURN;
    END
    DECLARE @current_participants INT;
    SELECT @current_participants = COUNT(*)
    FROM Addition_participants
    WHERE addition_reservation_id = @addition_reservation_id;

    DECLARE @reserved_seats INT;
    SELECT @reserved_seats = reserved_seats
    FROM Addition_reservations
    WHERE addition_reservation_id = @addition_reservation_id;
    IF @current_participants >= @reserved_seats
    BEGIN
        RAISERROR('Cannot add more participants than reserved seats for this addition.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Participants WHERE participant_id = @participant_id)
    BEGIN
        RAISERROR('Participant not found.', 16, 1);
        RETURN;
    END
    DECLARE @reservation_id_addition INT;
    DECLARE @reservation_id_participant INT;

    SELECT @reservation_id_addition = reservation_id FROM Addition_reservations WHERE addition_reservation_id = @addition_reservation_id;
    SELECT @reservation_id_participant = reservation_id FROM Participants WHERE participant_id = @participant_id;

    IF @reservation_id_addition IS NULL OR @reservation_id_participant IS NULL OR @reservation_id_addition <> @reservation_id_participant
    BEGIN
        RAISERROR('Participant must belong to the reservation associated with the addition.', 16, 1);
        RETURN;
    END
    SET NOCOUNT ON;
    INSERT INTO Addition_participants (addition_reservation_id, participant_id)
    VALUES (@addition_reservation_id, @participant_id);
END;