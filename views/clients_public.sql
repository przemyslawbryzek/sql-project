CREATE VIEW clients_public AS
SELECT 
    client_id,
    client_type,
    CASE 
        WHEN client_type = 'individual' THEN first_name + ' ' + last_name
        ELSE company_name
    END AS display_name,
    phone
FROM Clients;