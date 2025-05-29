CREATE PROCEDURE add_payment
    @reservation_id INT,
    @amount DECIMAL(10,2),
    @payment_method VARCHAR(50),
    @payment_date DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Reservations WHERE reservation_id = @reservation_id)
    BEGIN
        RAISERROR('Reservation not found.', 16, 1);
        RETURN;
    END
    IF @amount <= 0
    BEGIN
        RAISERROR('Payment amount must be greater than zero.', 16, 1);
        RETURN;
    END
    IF @payment_method IS NULL OR LEN(@payment_method) = 0
    BEGIN
        RAISERROR('Payment method is required.', 16, 1);
        RETURN;
    END
    SET NOCOUNT ON;
    IF @payment_date IS NULL
        SET @payment_date = CAST(GETDATE() AS DATE);
    INSERT INTO Payments (
        reservation_id,
        payment_date,
        amount,
        payment_method
    )
    VALUES (
        @reservation_id,
        @payment_date,
        @amount,
        @payment_method
    );
END;