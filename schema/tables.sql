CREATE TABLE Countries (
    name VARCHAR(100) NOT NULL,
    alpha_2 CHAR(2) PRIMARY KEY, 
    alpha_3 CHAR(3) NOT NULL,
    country_code CHAR(3) NOT NULL,
    iso_3166_2 VARCHAR(20) NOT NULL,
    region VARCHAR(50),
    sub_region VARCHAR(50),
    intermediate_region VARCHAR(50),
    region_code CHAR(3),
    sub_region_code CHAR(3),
    intermediate_region_code CHAR(3)
);
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

CREATE TABLE "Trips" (
    "trip_id" INT IDENTITY(1,1) PRIMARY KEY,
    "trip_name" VARCHAR(100),
    "departure_date" DATE,
    "price" DECIMAL(10, 2),
    "seat_limit" INT,
    "country_code" CHAR(2),
    FOREIGN KEY ("country_code") REFERENCES Countries("alpha_2")
);

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

CREATE TABLE "Participants" (
    "participant_id" INT IDENTITY(1,1) PRIMARY KEY,
    "reservation_id" INT,
    "first_name" VARCHAR(50),
    "last_name" VARCHAR(50),
    FOREIGN KEY ("reservation_id") REFERENCES Reservations("reservation_id")
);

CREATE TABLE "Additions" (
    "addition_id" INT IDENTITY(1,1) PRIMARY KEY,
    "trip_id" INT,
    "addition_name" VARCHAR(100),
    "price" DECIMAL(10,2),
    "seat_limit" INT,
    FOREIGN KEY ("trip_id") REFERENCES Trips("trip_id")
);

CREATE TABLE "Addition_reservations" (
    "addition_reservation_id" INT IDENTITY(1,1) PRIMARY KEY,
    "reservation_id" INT,
    "addition_id" INT,
    "reserved_seats" INT,
    "price" DECIMAL(10,2),
    FOREIGN KEY ("reservation_id") REFERENCES Reservations("reservation_id"),
    FOREIGN KEY ("addition_id") REFERENCES Additions("addition_id")
);

CREATE TABLE "Addition_participants" (
    "addition_reservation_id" INT,
    "participant_id" INT,
    FOREIGN KEY ("addition_reservation_id") REFERENCES Addition_reservations("addition_reservation_id"),
    FOREIGN KEY ("participant_id") REFERENCES Participants("participant_id")
);

CREATE TABLE "Payments" (
    "payment_id" INT IDENTITY(1,1) PRIMARY KEY,
    "reservation_id" INT,
    "payment_date" DATE DEFAULT CAST(GETDATE() AS DATE),
    "amount" DECIMAL(10, 2),
    "payment_method" VARCHAR(50),
    FOREIGN KEY ("reservation_id") REFERENCES Reservations("reservation_id")
);
