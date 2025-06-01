CREATE VIEW monthly_sales_report AS
SELECT 
    YEAR(r.reservation_date) AS year,
    MONTH(r.reservation_date) AS month,
    DATENAME(month, r.reservation_date) + ' ' + CAST(YEAR(r.reservation_date) AS VARCHAR) AS month_year,
    COUNT(r.reservation_id) AS total_reservations,
    SUM(r.reserved_seats) AS total_seats_sold,
    COUNT(DISTINCT r.client_id) AS unique_clients,
    SUM(dbo.get_total_reservation_cost(r.reservation_id)) AS total_revenue,
    SUM(dbo.get_total_payment(r.reservation_id)) AS total_payments_received,
    SUM(dbo.get_total_reservation_cost(r.reservation_id) - dbo.get_total_payment(r.reservation_id)) AS outstanding_balance,
    AVG(CAST(dbo.get_total_reservation_cost(r.reservation_id) AS FLOAT)) AS avg_reservation_value,
    AVG(CAST(r.reserved_seats AS FLOAT)) AS avg_seats_per_reservation
FROM Reservations r
WHERE r.status <> 'cancelled'
    AND r.reservation_date >= DATEADD(year, -2, GETDATE())
GROUP BY YEAR(r.reservation_date), MONTH(r.reservation_date), DATENAME(month, r.reservation_date);