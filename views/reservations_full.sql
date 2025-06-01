CREATE VIEW reservations_full AS
SELECT 
    r.reservation_id,
    r.reservation_date,
    r.status,
    c.client_id,
    CASE 
        WHEN c.client_type = 'individual' THEN c.first_name + ' ' + c.last_name
        ELSE c.company_name
    END AS client_name,
    c.client_type,
    c.email,
    c.phone,
    t.trip_id,
    t.trip_name,
    t.departure_date,
    r.reserved_seats,
    r.price AS unit_price,
    r.reserved_seats * r.price AS total_trip_cost,
    dbo.get_total_reservation_cost(r.reservation_id) AS total_cost_with_additions,
    dbo.get_total_payment(r.reservation_id) AS total_paid,
    dbo.get_total_reservation_cost(r.reservation_id) - dbo.get_total_payment(r.reservation_id) AS balance_due,
    CASE 
        WHEN dbo.get_total_payment(r.reservation_id) >= dbo.get_total_reservation_cost(r.reservation_id) 
        THEN 'Opłacone'
        WHEN dbo.get_total_payment(r.reservation_id) > 0 
        THEN 'Częściowo opłacone'
        ELSE 'Nieopłacone'
    END AS payment_status
FROM Reservations r
JOIN Clients c ON r.client_id = c.client_id
JOIN Trips t ON r.trip_id = t.trip_id;