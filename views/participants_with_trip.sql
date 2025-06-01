CREATE VIEW participants_with_trip AS
SELECT 
    p.participant_id,
    p.first_name,
    p.last_name,
    p.first_name + ' ' + p.last_name AS full_name,
    r.reservation_id,
    r.reservation_date,
    r.status AS reservation_status,
    CASE 
        WHEN c.client_type = 'individual' THEN c.first_name + ' ' + c.last_name
        ELSE c.company_name
    END AS client_name,
    c.phone AS client_phone,
    t.trip_id,
    t.trip_name,
    t.departure_date,
    t.price AS trip_price,
    DATEDIFF(day, GETDATE(), t.departure_date) AS days_until_departure
FROM Participants p
JOIN Reservations r ON p.reservation_id = r.reservation_id
JOIN Clients c ON r.client_id = c.client_id
JOIN Trips t ON r.trip_id = t.trip_id;