CREATE VIEW additions_performance_report AS
SELECT 
    a.addition_id,
    a.addition_name,
    a.price,
    a.seat_limit,
    t.trip_name,
    COUNT(ar.addition_reservation_id) AS total_reservations,
    SUM(ar.reserved_seats) AS total_seats_sold,
    a.seat_limit - SUM(ar.reserved_seats) AS remaining_seats,
    CAST(SUM(ar.reserved_seats) AS FLOAT) / a.seat_limit * 100 AS utilization_percentage,
    SUM(ar.reserved_seats * ar.price) AS total_revenue,
    AVG(CAST(ar.reserved_seats AS FLOAT)) AS avg_seats_per_reservation,
    CAST(COUNT(ar.addition_reservation_id) AS FLOAT) / 
    NULLIF((SELECT COUNT(r.reservation_id) 
            FROM Reservations r 
            WHERE r.trip_id = t.trip_id AND r.status <> 'cancelled'), 0) * 100 AS attachment_rate,
    (SELECT COUNT(ap.participant_id) 
     FROM Addition_participants ap 
     WHERE ap.addition_reservation_id IN 
           (SELECT ar2.addition_reservation_id 
            FROM Addition_reservations ar2 
            WHERE ar2.addition_id = a.addition_id)
    ) AS total_participants,
    CASE 
        WHEN SUM(ar.reserved_seats) >= a.seat_limit THEN 'Wyprzedana'
        WHEN SUM(ar.reserved_seats) >= a.seat_limit * 0.8 THEN 'Prawie pełna'
        ELSE 'Dostępna'
    END AS availability_status
FROM Additions a
JOIN Trips t ON a.trip_id = t.trip_id
LEFT JOIN Addition_reservations ar ON a.addition_id = ar.addition_id
LEFT JOIN Reservations r ON ar.reservation_id = r.reservation_id AND r.status <> 'cancelled'
GROUP BY a.addition_id, a.addition_name, a.price, a.seat_limit, t.trip_name, t.trip_id;