WITH FirstPos AS (
    SELECT HCP_ID, MIN(Alert_Date) AS First_Pos_Date
    FROM Alerts
    WHERE Lab_Result = 'Positive'
    GROUP BY HCP_ID
),
SalesWindows AS (
    SELECT 
        f.HCP_ID,
        f.First_Pos_Date,
        SUM(CASE WHEN s.Prescription_Date >= DATE_SUB(f.First_Pos_Date, INTERVAL 90 DAY) 
                  AND s.Prescription_Date < f.First_Pos_Date THEN s.Prescription_Volume ELSE 0 END) AS Pre_90d_Rx,
        SUM(CASE WHEN s.Prescription_Date > f.First_Pos_Date 
                  AND s.Prescription_Date <= DATE_ADD(f.First_Pos_Date, INTERVAL 90 DAY) THEN s.Prescription_Volume ELSE 0 END) AS Post_90d_Rx
    FROM FirstPos f
    LEFT JOIN Sales s ON f.HCP_ID = s.HCP_ID AND s.Drug_ID = 'DRG001'
    GROUP BY f.HCP_ID, f.First_Pos_Date
),
LiftCalc AS (
    SELECT 
        HCP_ID, 
        Pre_90d_Rx, 
        Post_90d_Rx,
        CASE 
            WHEN Pre_90d_Rx = 0 AND Post_90d_Rx > 0 THEN NULL 
            WHEN Pre_90d_Rx = 0 AND Post_90d_Rx = 0 THEN 0.0
            ELSE ((Post_90d_Rx - Pre_90d_Rx) / Pre_90d_Rx) * 100 
        END AS Lift_Pct,
        CASE 
            WHEN Pre_90d_Rx = 0 AND Post_90d_Rx > 0 THEN 'New Starter'
            WHEN Pre_90d_Rx = 0 AND Post_90d_Rx = 0 THEN 'Non-responder'
            WHEN (((Post_90d_Rx - Pre_90d_Rx) / Pre_90d_Rx) * 100) >= 20.0 THEN 'Grower'
            ELSE 'Non-responder'
        END AS Segment
    FROM SalesWindows
)
SELECT * FROM LiftCalc
ORDER BY Lift_Pct DESC;