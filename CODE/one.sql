-- Ranking 1: Top 10 by Alert Volume
SELECT HCP_ID, COUNT(*) AS Total_Alerts
FROM Alerts
GROUP BY HCP_ID
ORDER BY Total_Alerts DESC
LIMIT 10;

-- Ranking 2: Top 10 by Prescription Volume (filtered to alerts universe)
SELECT s.HCP_ID, SUM(s.Prescription_Volume) AS Total_Rx_Volume
FROM Sales s
INNER JOIN (
    SELECT DISTINCT HCP_ID 
    FROM Alerts
) a ON s.HCP_ID = a.HCP_ID
GROUP BY s.HCP_ID
ORDER BY Total_Rx_Volume DESC
LIMIT 10;