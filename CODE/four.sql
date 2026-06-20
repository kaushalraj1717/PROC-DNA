WITH AccountAlerts AS (
    SELECT aff.Account_ID, aff.Account_Name, COUNT(a.Alert_ID) AS Total_Alerts
    FROM Alerts a
    INNER JOIN Affiliation aff ON a.HCP_ID = aff.HCP_ID
    GROUP BY aff.Account_ID, aff.Account_Name
),
AccountSales AS (
    SELECT aff.Account_ID, SUM(s.Prescription_Volume) AS DRG001_Rx
    FROM Sales s
    INNER JOIN Affiliation aff ON s.HCP_ID = aff.HCP_ID
    WHERE s.Drug_ID = 'DRG001'
    GROUP BY aff.Account_ID
)
SELECT 
    aa.Account_Name, 
    aa.Total_Alerts, 
    COALESCE(asales.DRG001_Rx, 0) AS DRG001_Rx_Count,
    (COALESCE(asales.DRG001_Rx, 0) / aa.Total_Alerts) AS Conversion_Ratio
FROM AccountAlerts aa
LEFT JOIN AccountSales asales ON aa.Account_ID = asales.Account_ID
ORDER BY Conversion_Ratio ASC
LIMIT 10;