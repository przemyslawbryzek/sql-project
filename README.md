# Bazy danych

**Autorzy:** Rutyna Przemysław, Skoczylas Piotr, Bryzek Przemysław


---

# 1. Wymagania i funkcje systemu

System do zarządzania rezerwacjami w biurze podróży, umożliwiający klientom rezerwację wycieczek i dodatków, a pracownikom zarządzanie ofertą i rezerwacjami.

---

# 2. Baza danych

## Schemat bazy danych

![Diagram Bazy Danych](https://github.com/przemyslawbryzek/sql-project/blob/main/Diagram.png)

## Opis poszczególnych tabel

### Tabela: Clients
- Opis: Przechowuje dane klientów (osoby indywidualne lub firmy).

| Nazwa atrybutu | Typ           | Opis/Uwagi                                         |
| -------------- | ------------- | -------------------------------------------------- |
| client_id      | INT           | Klucz główny, autoinkrementacja                    |
| client_type    | VARCHAR(20)   | Typ klienta: 'individual' lub 'company'            |
| company_name   | VARCHAR(100)  | Nazwa firmy (dla firm)                             |
| first_name     | VARCHAR(50)   | Imię (dla osób indywidualnych)                     |
| last_name      | VARCHAR(50)   | Nazwisko (dla osób indywidualnych)                 |
| email          | VARCHAR(100)  | E-mail                                             |
| phone          | VARCHAR(20)   | Telefon                                            |
| address        | VARCHAR(200)  | Adres                                              |

```sql
CREATE TABLE "Clients" (
    "client_id" INT IDENTITY(1,1) PRIMARY KEY,
    "client_type" VARCHAR(20) CHECK (client_type IN ('individual', 'company')),
    "company_name" VARCHAR(100),
    "first_name" VARCHAR(50),
    "last_name" VARCHAR(50),
    "email" VARCHAR(100),
    "phone" VARCHAR(20),
    "address" VARCHAR(200)
);
```

---

### Tabela: Trips
- Opis: Przechowuje informacje o dostępnych wycieczkach.

| Nazwa atrybutu   | Typ           | Opis/Uwagi         |
| ---------------- | ------------- | ------------------ |
| trip_id          | INT           | Klucz główny       |
| trip_name        | VARCHAR(100)  | Nazwa wycieczki    |
| departure_date   | DATE          | Data wyjazdu       |
| price            | DECIMAL(10,2) | Cena               |
| seat_limit       | INT           | Limit miejsc       |

```sql
CREATE TABLE "Trips" (
    "trip_id" INT IDENTITY(1,1) PRIMARY KEY,
    "trip_name" VARCHAR(100),
    "departure_date" DATE,
    "price" DECIMAL(10, 2),
    "seat_limit" INT
);
```

---

### Tabela: Reservations
- Opis: Przechowuje rezerwacje wycieczek klientów.

| Nazwa atrybutu  | Typ           | Opis/Uwagi                            |
| --------------- | ------------- | ------------------------------------- |
| reservation_id  | INT           | Klucz główny                          |
| client_id       | INT           | Klucz obcy do Clients                 |
| trip_id         | INT           | Klucz obcy do Trips                   |
| reservation_date| DATE          | Data rezerwacji (domyślnie dziś)      |
| reserved_seats  | INT           | Liczba zarezerwowanych miejsc         |
| price           | DECIMAL(10,2) | Cena                                  |
| status          | VARCHAR(20)   | Status: 'pending', 'cancelled'        |

```sql
CREATE TABLE "Reservations" (
    "reservation_id" INT IDENTITY(1,1) PRIMARY KEY,
    "client_id" INT,
    "trip_id" INT,
    "reservation_date" DATE DEFAULT CAST(GETDATE() AS DATE),
    "reserved_seats" INT,
    "price" DECIMAL(10,2),
    "status" VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'cancelled')),
    FOREIGN KEY ("client_id") REFERENCES Clients("client_id"),
    FOREIGN KEY ("trip_id") REFERENCES Trips("trip_id")
);
```

---

### Tabela: Participants
- Opis: Przechowuje uczestników przypisanych do rezerwacji.

| Nazwa atrybutu  | Typ           | Opis/Uwagi                    |
| --------------- | ------------- | ----------------------------- |
| participant_id  | INT           | Klucz główny                  |
| reservation_id  | INT           | Klucz obcy do Reservations    |
| first_name      | VARCHAR(50)   | Imię uczestnika               |
| last_name       | VARCHAR(50)   | Nazwisko uczestnika           |

```sql
CREATE TABLE "Participants" (
    "participant_id" INT IDENTITY(1,1) PRIMARY KEY,
    "reservation_id" INT,
    "first_name" VARCHAR(50),
    "last_name" VARCHAR(50),
    FOREIGN KEY ("reservation_id") REFERENCES Reservations("reservation_id")
);
```

---

### Tabela: Additions
- Opis: Dodatkowe atrakcje lub usługi powiązane z wycieczkami.

| Nazwa atrybutu    | Typ           | Opis/Uwagi                     |
| ----------------- | ------------- | ------------------------------ |
| addition_id       | INT           | Klucz główny                   |
| trip_id           | INT           | Klucz obcy do Trips            |
| addition_name     | VARCHAR(100)  | Nazwa dodatku                  |
| price             | DECIMAL(10,2) | Cena dodatku                   |
| seat_limit        | INT           | Limit miejsc                   |

```sql
CREATE TABLE "Additions" (
    "addition_id" INT IDENTITY(1,1) PRIMARY KEY,
    "trip_id" INT,
    "addition_name" VARCHAR(100),
    "price" DECIMAL(10,2),
    "seat_limit" INT,
    FOREIGN KEY ("trip_id") REFERENCES Trips("trip_id")
);
```

---

### Tabela: Addition_reservations
- Opis: Rezerwacje dodatków do rezerwacji głównych.

| Nazwa atrybutu          | Typ           | Opis/Uwagi                              |
| ----------------------- | ------------- | --------------------------------------- |
| addition_reservation_id | INT           | Klucz główny                            |
| reservation_id          | INT           | Klucz obcy do Reservations              |
| addition_id             | INT           | Klucz obcy do Additions                 |
| reserved_seats          | INT           | Ilość zarezerwowanych miejsc            |
| price                   | DECIMAL(10,2) | Cena                                    |

```sql
CREATE TABLE "Addition_reservations" (
    "addition_reservation_id" INT IDENTITY(1,1) PRIMARY KEY,
    "reservation_id" INT,
    "addition_id" INT,
    "reserved_seats" INT,
    "price" DECIMAL(10,2),
    FOREIGN KEY ("reservation_id") REFERENCES Reservations("reservation_id"),
    FOREIGN KEY ("addition_id") REFERENCES Additions("addition_id")
);
```

---

### Tabela: Addition_participants
- Opis: Mapowanie uczestników na dodatki.

| Nazwa atrybutu           | Typ | Opis/Uwagi                            |
| ------------------------ | --- | ------------------------------------- |
| addition_reservation_id  | INT | Klucz obcy do Addition_reservations   |
| participant_id           | INT | Klucz obcy do Participants            |

```sql
CREATE TABLE "Addition_participants" (
    "addition_reservation_id" INT,
    "participant_id" INT,
    FOREIGN KEY ("addition_reservation_id") REFERENCES Addition_reservations("addition_reservation_id"),
    FOREIGN KEY ("participant_id") REFERENCES Participants("participant_id")
);
```

---

### Tabela: Payments
- Opis: Płatności powiązane z rezerwacjami.

| Nazwa atrybutu   | Typ           | Opis/Uwagi                      |
| ---------------- | ------------- | ------------------------------- |
| payment_id       | INT           | Klucz główny                    |
| reservation_id   | INT           | Klucz obcy do Reservations      |
| payment_date     | DATE          | Data płatności (domyślnie dziś) |
| amount           | DECIMAL(10,2) | Kwota                           |
| payment_method   | VARCHAR(50)   | Metoda płatności                |

```sql
CREATE TABLE "Payments" (
    "payment_id" INT IDENTITY(1,1) PRIMARY KEY,
    "reservation_id" INT,
    "payment_date" DATE DEFAULT CAST(GETDATE() AS DATE),
    "amount" DECIMAL(10, 2),
    "payment_method" VARCHAR(50),
    FOREIGN KEY ("reservation_id") REFERENCES Reservations("reservation_id")
);
```

---

# 3. Widoki, procedury/funkcje, triggery

## Widoki


## Procedury/funkcje

### Funkcje
- `get_free_addition_seats` - Zwraca liczbę wolnych miejsc na daną dodatkową atrakcję.
  ```sql
  CREATE FUNCTION get_free_addition_seats (@addition_id INT)
  RETURNS INT
  AS
  BEGIN
      DECLARE @seat_limit INT;
      DECLARE @reserved_seats INT;
      SELECT @seat_limit = seat_limit FROM Additions WHERE addition_id = @addition_id;
      SELECT @reserved_seats = ISNULL(SUM(ar.reserved_seats), 0)
      FROM Addition_reservations ar
      JOIN Reservations r ON ar.reservation_id = r.reservation_id
      WHERE ar.addition_id = @addition_id AND r.status <> 'cancelled';
      RETURN @seat_limit - @reserved_seats;
  END;
  ```
- `get_free_trip_seats` - Zwraca liczbę wolnych miejsc na daną wycieczkę.
  ```sql
  CREATE FUNCTION get_free_trip_seats (@trip_id INT)
  RETURNS INT
  AS
  BEGIN
      DECLARE @seat_limit INT;
      DECLARE @reserved_seats INT;
      SELECT @seat_limit = seat_limit FROM Trips WHERE trip_id = @trip_id;
      SELECT @reserved_seats = ISNULL(SUM(reserved_seats), 0)
      FROM Reservations
      WHERE trip_id = @trip_id AND status <> 'cancelled';
      RETURN @seat_limit - @reserved_seats;
  END;
  ```
- `get_total_payment` - Zwraca sumę wpłat dla danej rezerwacji.
  ```sql
  CREATE FUNCTION get_total_payment (@reservation_id INT)
  RETURNS DECIMAL(10,2)
  AS
  BEGIN
      DECLARE @total DECIMAL(10,2);
      SELECT @total = ISNULL(SUM(amount), 0)
      FROM Payments
      WHERE reservation_id = @reservation_id;
      RETURN @total;
  END;
  ```
- `get_total_reservation_cost` - Oblicza całkowity koszt rezerwacji (wycieczka + dodatki).
  ```sql
  CREATE FUNCTION get_total_reservation_cost (@reservation_id INT)
  RETURNS DECIMAL(10,2)
  AS
  BEGIN
      DECLARE @base_price DECIMAL(10,2);
      DECLARE @reserved_seats INT;
      DECLARE @unit_price DECIMAL(10,2);
      DECLARE @additions_price DECIMAL(10,2);

      SELECT @unit_price = price, @reserved_seats = reserved_seats
      FROM Reservations
      WHERE reservation_id = @reservation_id;

      SELECT @additions_price = ISNULL(SUM(price * reserved_seats), 0)
      FROM Addition_reservations
      WHERE reservation_id = @reservation_id;

      RETURN ISNULL(@unit_price * @reserved_seats, 0) + @additions_price;
  END;
  ```

### Procedury
- `add_addition_participant` - Dodaje uczestnika do zarezerwowanej dodatkowej atrakcji.
  ```sql
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
  ```
- `add_client` - Dodaje nowego klienta do systemu.
  ```sql
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
  ```
- `add_participant` - Dodaje uczestnika do rezerwacji.
  ```sql
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
  ```
- `add_payment` - Rejestruje płatność za rezerwację.
  ```sql
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
  ```
- `cancel_incomplete_reservations` - Anuluje rezerwacje, które nie mają przypisanych wszystkich uczestników po określonym czasie.
  ```sql
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
  ```
- `cancel_reservation_and_refund` - Anuluje rezerwację i przetwarza zwrot środków.
  ```sql
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
  ```
- `cancel_unpaid_reservations` - Anuluje rezerwacje, które nie zostały opłacone w terminie.
  ```sql
  CREATE PROCEDURE cancel_unpaid_reservations
  AS
  BEGIN
      SET NOCOUNT ON;

      DECLARE @reservation_id_cursor INT;
      DECLARE @total_cost DECIMAL(10, 2);
      DECLARE @total_paid DECIMAL(10, 2);
      DECLARE @trip_departure_date DATE;

      DECLARE reservation_cursor CURSOR FOR
      SELECT r.reservation_id, t.departure_date
      FROM Reservations r
      JOIN Trips t ON r.trip_id = t.trip_id
      WHERE r.status = 'pending' AND t.departure_date <= DATEADD(day, 7, GETDATE());

      OPEN reservation_cursor;
      FETCH NEXT FROM reservation_cursor INTO @reservation_id_cursor, @trip_departure_date;

      WHILE @@FETCH_STATUS = 0
      BEGIN
          SET @total_cost = dbo.get_total_reservation_cost(@reservation_id_cursor);
          SET @total_paid = dbo.get_total_payment(@reservation_id_cursor);
          IF @total_paid < @total_cost
          BEGIN
              UPDATE Reservations
              SET status = 'cancelled'
              WHERE reservation_id = @reservation_id_cursor;
          END

          FETCH NEXT FROM reservation_cursor INTO @reservation_id_cursor, @trip_departure_date;
      END

      CLOSE reservation_cursor;
      DEALLOCATE reservation_cursor;
  END;
  ```
- `create_addition_reservation` - Tworzy rezerwację na dodatkową atrakcję w ramach istniejącej rezerwacji wycieczki.
  ```sql
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
  ```
- `create_reservation` - Tworzy nową rezerwację wycieczki dla klienta.
  ```sql
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
  ```
- `modify_addition_reservation` - Modyfikuje istniejącą rezerwację dodatkowej atrakcji.
  ```sql
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
  ```
- `modify_reservation` - Modyfikuje istniejącą rezerwację wycieczki.
  ```sql
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
  ```

## Triggery


---

# 4. Inne

(Dodatkowe informacje: generowanie danych, uprawnienia itp.)

---
