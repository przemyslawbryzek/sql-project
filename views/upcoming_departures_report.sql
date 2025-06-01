CREATE VIEW upcoming_departures_report AS
SELECT 
    t.trip_id,
    t.trip_name,
    t.departure_date,
    DATEDIFF(day, GETDATE(), t.departure_date) AS days_until_departure,
    t.seat_limit,
    SUM(r.reserved_seats) AS seats_sold,
    t.seat_limit - SUM(r.reserved_seats) AS seats_available,
    COUNT(r.reservation_id) AS total_reservations,
    COUNT(DISTINCT r.client_id) AS unique_clients,
    (SELECT COUNT(p.participant_id) 
     FROM Participants p 
     JOIN Reservations r2 ON p.reservation_id = r2.reservation_id 
     WHERE r2.trip_id = t.trip_id AND r2.status <> 'cancelled'
    ) AS participants_assigned,
    SUM(r.reserved_seats) - (SELECT COUNT(p.participant_id) 
                            FROM Participants p 
                            JOIN Reservations r2 ON p.reservation_id = r2.reservation_id 
                            WHERE r2.trip_id = t.trip_id AND r2.status <> 'cancelled'
                           ) AS participants_missing,

    SUM(dbo.get_total_reservation_cost(r.reservation_id)) AS total_revenue_expected,
    SUM(dbo.get_total_payment(r.reservation_id)) AS total_payments_received,
    SUM(dbo.get_total_reservation_cost(r.reservation_id) - dbo.get_total_payment(r.reservation_id)) AS outstanding_balance,
    CASE 
        WHEN DATEDIFF(day, GETDATE(), t.departure_date) <= 7 
             AND SUM(dbo.get_total_reservation_cost(r.reservation_id) - dbo.get_total_payment(r.reservation_id)) > 0
        THEN 'Problemy płatności'
        WHEN DATEDIFF(day, GETDATE(), t.departure_date) <= 7 
             AND SUM(r.reserved_seats) - (SELECT COUNT(p.participant_id) 
                                         FROM Participants p 
                                         JOIN Reservations r2 ON p.reservation_id = r2.reservation_id 
                                         WHERE r2.trip_id = t.trip_id AND r2.status <> 'cancelled') > 0
        THEN 'Brak uczestników'
        WHEN DATEDIFF(day, GETDATE(), t.departure_date) <= 7
        THEN 'Gotowa'
        ELSE 'W przygotowaniu'
    END AS readiness_status
FROM Trips t
LEFT JOIN Reservations r ON t.trip_id = r.trip_id AND r.status <> 'cancelled'
WHERE t.departure_date >= GETDATE()
    AND t.departure_date <= DATEADD(day, 60, GETDATE())
GROUP BY t.trip_id, t.trip_name, t.departure_date, t.seat_limit;