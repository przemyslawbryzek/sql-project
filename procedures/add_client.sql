CREATE PROCEDURE add_client
    @client_type VARCHAR(20),
    @first_name VARCHAR(50) = NULL,
    @last_name VARCHAR(50) = NULL,
    @company_name VARCHAR(100) = NULL,
    @email VARCHAR(100),
    @phone VARCHAR(20),
    @address VARCHAR(200),
    @client_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @client_type NOT IN ('individual', 'company')
    BEGIN
        RAISERROR('Invalid client type.', 16, 1);
        RETURN;
    END
    IF @email IS NULL OR @phone IS NULL OR @address IS NULL
    BEGIN
        RAISERROR('Email, phone, and address are required.', 16, 1);
        RETURN;
    END

    IF @client_type = 'individual' AND (@first_name IS NULL OR @last_name IS NULL)
    BEGIN
        RAISERROR('First name and last name are required for individual clients.', 16, 1);
        RETURN;
    END

    IF @client_type = 'company' AND @company_name IS NULL
    BEGIN
        RAISERROR('Company name is required for company clients.', 16, 1);
        RETURN;
    END
    SET NOCOUNT ON;
    INSERT INTO Clients (
        client_type,
        first_name,
        last_name,
        company_name,
        email,
        phone,
        address
    )
    VALUES (
        @client_type,
        @first_name,
        @last_name,
        @company_name,
        @email,
        @phone,
        @address
    );
    SET @client_id = SCOPE_IDENTITY();
END;