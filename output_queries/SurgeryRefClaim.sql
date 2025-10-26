-- SurgeryRefClaim : Cholecystectomy reference inpatient
WITH tar_cte AS (
    SELECT DISTINCT 
        l.claim AS tar_claim,
        l.provider AS tar_provider,
        l.member AS tar_member,
        l.cptcode AS tar_cptcode,
        l.diagcode AS tar_diagcode,
        s.totalpaidamount AS tar_totalpaidamount
    FROM claim l
    INNER JOIN claimsummary s
        ON l.claim = s.claim
    WHERE 1=1

        
            
                AND (l.reprocessbilltypecode LIKE '11%%')
            
        

        
            AND l.cptcode IN ('47562')
        

        
            AND REPLACE(l.diagcode, '.', '') IN ('K81.0')
        
)

SELECT 
    a.*, 
    l.claim AS ref_claim,
    l.provider AS ref_provider,
    l.member AS ref_member,
    l.cptcode AS ref_cptcode,
    l.diagcode AS ref_diagcode
FROM tar_cte a
INNER JOIN claim l
    ON
    
        a.tar_provider = l.provider
    
INNER JOIN claimsummary s
    ON l.claim = s.claim
WHERE 1=1

    
        
            AND (l.reprocessbilltypecode LIKE '11%%')
        
    

    
        AND l.cptcode IN ('47563.0')
    

    
        AND REPLACE(l.diagcode, '.', '') IN ('K81.0')
    
;