CREATE FUNCTION get_trip_additions (@trip_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        A.addition_id,
        A.addition_name,
        A.price,
        dbo.get_free_addition_seats(A.addition_id) AS remaining_seats
    FROM Additions A
    WHERE A.trip_id = @trip_id AND dbo.get_free_addition_seats(A.addition_id) > 0
);