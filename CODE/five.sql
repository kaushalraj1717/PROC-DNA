WITH AccountDocs AS (
    SELECT Account_ID, COUNT(DISTINCT HCP_ID) AS Total_Doctors
    FROM Affiliation
    GROUP BY Account_ID
),
ActiveDocs AS (
    SELECT 
        aff.Account_ID, 
        COUNT(DISTINCT s.HCP_ID) AS Active_Prescribers, 
        SUM(s.Prescription_Volume) AS Total_DRG001_Rx
    FROM Sales s
    INNER JOIN Affiliation aff ON s.HCP_ID = aff.HCP_ID
    WHERE s.Drug_ID = 'DRG001'
    GROUP BY aff.Account_ID
)
SELECT 
    ad.Account_ID,
    ad.Total_Doctors,
    COALESCE(act.Active_Prescribers, 0) AS Active_Prescribers,
    COALESCE(act.Total_DRG001_Rx, 0) AS Total_DRG001_Rx,
    (COALESCE(act.Total_DRG001_Rx, 0) / act.Active_Prescribers) AS Rx_Per_Active_Doctor
FROM AccountDocs ad
LEFT JOIN ActiveDocs act ON ad.Account_ID = act.Account_ID
WHERE act.Active_Prescribers > 0
ORDER BY Rx_Per_Active_Doctor ASC
LIMIT 10;