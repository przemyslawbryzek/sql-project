CREATE VIEW payments_report AS
SELECT 
    YEAR(p.payment_date) AS year,
    MONTH(p.payment_date) AS month,
    DATENAME(month, p.payment_date) + ' ' + CAST(YEAR(p.payment_date) AS VARCHAR) AS month_year,
    p.payment_method,
    COUNT(p.payment_id) AS total_payments,
    SUM(p.amount) AS total_amount,
    AVG(p.amount) AS avg_payment_amount,
    SUM(CASE WHEN p.amount < 0 THEN 1 ELSE 0 END) AS refund_count,
    SUM(CASE WHEN p.amount < 0 THEN p.amount ELSE 0 END) AS total_refunds,
    SUM(CASE WHEN p.amount > 0 THEN p.amount ELSE 0 END) AS total_incoming,
    SUM(CASE WHEN p.amount > 0 THEN p.amount ELSE 0 END) + 
    SUM(CASE WHEN p.amount < 0 THEN p.amount ELSE 0 END) AS net_payments
FROM Payments p
WHERE p.payment_date >= DATEADD(year, -2, GETDATE())
GROUP BY YEAR(p.payment_date), MONTH(p.payment_date), DATENAME(month, p.payment_date), p.payment_method;