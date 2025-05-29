CREATE PROCEDURE cancel_incomplete_reservations
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @reservation_id_cursor INT;
    DECLARE @trip_departure_date DATE;
    DECLARE @reserved_trip_seats INT;
    DECLARE @current_trip_participants INT;

    DECLARE @addition_reservation_id_cursor INT;
    DECLARE @reserved_addition_seats INT;
    DECLARE @current_addition_participants INT;
    DECLARE @cancel_main_reservation BIT;

    DECLARE reservation_cursor CURSOR FOR
    SELECT r.reservation_id, t.departure_date, r.reserved_seats
    FROM Reservations r
    JOIN Trips t ON r.trip_id = t.trip_id
    WHERE r.status = 'pending' AND t.departure_date <= DATEADD(day, 7, GETDATE());

    OPEN reservation_cursor;
    FETCH NEXT FROM reservation_cursor INTO @reservation_id_cursor, @trip_departure_date, @reserved_trip_seats;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @cancel_main_reservation = 0;

        SELECT @current_trip_participants = COUNT(*)
        FROM Participants
        WHERE reservation_id = @reservation_id_cursor;

        IF @current_trip_participants < @reserved_trip_seats
        BEGIN
            SET @cancel_main_reservation = 1;
        END
        ELSE
        BEGIN

            DECLARE addition_cursor CURSOR FOR
            SELECT ar.addition_reservation_id, ar.reserved_seats
            FROM Addition_reservations ar
            WHERE ar.reservation_id = @reservation_id_cursor;

            OPEN addition_cursor;
            FETCH NEXT FROM addition_cursor INTO @addition_reservation_id_cursor, @reserved_addition_seats;

            WHILE @@FETCH_STATUS = 0 AND @cancel_main_reservation = 0
            BEGIN
                SELECT @current_addition_participants = COUNT(*)
                FROM Addition_participants
                WHERE addition_reservation_id = @addition_reservation_id_cursor;

                IF @current_addition_participants < @reserved_addition_seats
                BEGIN
                    SET @cancel_main_reservation = 1;
                END

                FETCH NEXT FROM addition_cursor INTO @addition_reservation_id_cursor, @reserved_addition_seats;
            END

            CLOSE addition_cursor;
            DEALLOCATE addition_cursor;
        END

        IF @cancel_main_reservation = 1
        BEGIN
            UPDATE Reservations
            SET status = 'cancelled'
            WHERE reservation_id = @reservation_id_cursor;
        END

        FETCH NEXT FROM reservation_cursor INTO @reservation_id_cursor, @trip_departure_date, @reserved_trip_seats;
    END

    CLOSE reservation_cursor;
    DEALLOCATE reservation_cursor;
END;