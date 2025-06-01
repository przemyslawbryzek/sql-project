CREATE VIEW trip_popularity_report AS
SELECT 
    t.trip_id,
    t.trip_name,
    t.departure_date,
    t.price,
    t.seat_limit,
    COUNT(r.reservation_id) AS total_reservations,
    SUM(r.reserved_seats) AS total_seats_sold,
    t.seat_limit - SUM(r.reserved_seats) AS remaining_seats,
    CAST(SUM(r.reserved_seats) AS FLOAT) / t.seat_limit * 100 AS occupancy_percentage,
    SUM(dbo.get_total_reservation_cost(r.reservation_id)) AS total_revenue,
    AVG(CAST(dbo.get_total_reservation_cost(r.reservation_id) AS FLOAT)) AS avg_reservation_value,
    (SELECT COUNT(DISTINCT ar.addition_id) 
     FROM Addition_reservations ar 
     JOIN Reservations r2 ON ar.reservation_id = r2.reservation_id 
     WHERE r2.trip_id = t.trip_id
    ) AS unique_additions_sold,
    (SELECT SUM(ar.reserved_seats * ar.price) 
     FROM Addition_reservations ar 
     JOIN Reservations r2 ON ar.reservation_id = r2.reservation_id 
     WHERE r2.trip_id = t.trip_id
    ) AS additions_revenue,
    CASE 
        WHEN t.departure_date < GETDATE() THEN 'Zakończona'
        WHEN SUM(r.reserved_seats) >= t.seat_limit THEN 'Wyprzedana'
        WHEN SUM(r.reserved_seats) >= t.seat_limit * 0.8 THEN 'Prawie pełna'
        ELSE 'Dostępna'
    END AS trip_status
FROM Trips t
LEFT JOIN Reservations r ON t.trip_id = r.trip_id AND r.status <> 'cancelled'
GROUP BY t.trip_id, t.trip_name, t.departure_date, t.price, t.seat_limit;