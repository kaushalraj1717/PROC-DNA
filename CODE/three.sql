WITH Top10Alerts AS (
    SELECT HCP_ID 
    FROM Alerts 
    GROUP BY HCP_ID 
    ORDER BY COUNT(*) DESC 
    LIMIT 10
),
SalesSummary AS (
    SELECT 
        s.HCP_ID,
        SUM(CASE WHEN s.Drug_ID = 'DRG001' THEN s.Prescription_Volume ELSE 0 END) AS Our_Drug_Volume,
        SUM(CASE WHEN s.Drug_ID != 'DRG001' THEN s.Prescription_Volume ELSE 0 END) AS Competitor_Volume
    FROM Sales s
    INNER JOIN Top10Alerts t ON s.HCP_ID = t.HCP_ID
    GROUP BY s.HCP_ID
)
SELECT 
    HCP_ID, 
    Competitor_Volume, 
    Our_Drug_Volume, 
    (Our_Drug_Volume + Competitor_Volume) AS Total_Volume,
    (Our_Drug_Volume / (Our_Drug_Volume + Competitor_Volume) * 100) AS `Our_Drug_%`,
    (Competitor_Volume / (Our_Drug_Volume + Competitor_Volume) * 100) AS `Competitor_%`
FROM SalesSummary;