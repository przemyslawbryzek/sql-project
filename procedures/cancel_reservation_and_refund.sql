CREATE PROCEDURE cancel_reservation_and_refund
    @reservation_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @trip_id INT;
    DECLARE @departure_date DATE;
    DECLARE @current_status VARCHAR(20);
    DECLARE @total_paid DECIMAL(10,2);
    DECLARE @current_date DATE = GETDATE();

    SELECT
        @trip_id = R.trip_id,
        @departure_date = T.departure_date,
        @current_status = R.status
    FROM
        dbo.Reservations R
    INNER JOIN
        dbo.Trips T ON R.trip_id = T.trip_id
    WHERE
        R.reservation_id = @reservation_id;

    IF @trip_id IS NULL
    BEGIN
        RAISERROR('Reservation with ID %d not found.', 16, 1, @reservation_id);
        RETURN;
    END
    IF @current_status = 'cancelled'
    BEGIN
        RAISERROR('Reservation with ID %d is already cancelled.', 16, 1, @reservation_id);
        RETURN;
    END
    IF DATEDIFF(day, @current_date, @departure_date) < 7
    BEGIN
        RAISERROR('Cancellation deadline is 7 days before the departure date.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Reservations
        SET status = 'cancelled'
        WHERE reservation_id = @reservation_id;
        SET @total_paid = dbo.get_total_payment(@reservation_id);
        IF @total_paid > 0
        BEGIN
            INSERT INTO Payments (reservation_id, payment_date, amount, payment_method)
            VALUES (@reservation_id, @current_date, -@total_paid, 'REFUND');
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;