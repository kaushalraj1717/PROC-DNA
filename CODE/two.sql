WITH FirstPosAlerts AS (
    SELECT 
        HCP_ID, 
        MIN(Alert_Date) AS First_Positive_Date, 
        COUNT(*) AS Positive_Alert_Count
    FROM Alerts
    WHERE Lab_Result = 'Positive'
    GROUP BY HCP_ID
)
SELECT 
    f.HCP_ID, 
    f.Positive_Alert_Count, 
    f.First_Positive_Date
FROM FirstPosAlerts f
LEFT JOIN Sales s 
    ON f.HCP_ID = s.HCP_ID 
    AND s.Prescription_Date BETWEEN f.First_Positive_Date AND DATE_ADD(f.First_Positive_Date, INTERVAL 30 DAY)
GROUP BY f.HCP_ID, f.Positive_Alert_Count, f.First_Positive_Date
HAVING SUM(COALESCE(s.Prescription_Volume, 0)) = 0
ORDER BY f.Positive_Alert_Count DESC
LIMIT 10;