-- DiabetesClaim : Diabetes outpatient checkup

WITH tar_cte AS (
    SELECT DISTINCT 
        l.claim AS tar_claim,
        l.provider AS tar_provider,
        l.member AS tar_member,
        l.cptcode AS tar_cptcode,
        l.diagcode AS tar_diagcode,
        l.paidamount AS tar_paidamount,
        s.totalpaidamount AS tar_totalpaidamount
    FROM claim l
    INNER JOIN claimsummary s
        ON l.claim = s.claim
    WHERE 1=1

        
            
                AND (
                    l.reprocessbilltypecode LIKE '13%%' OR
                    l.reprocessbilltypecode LIKE '14%%' OR
                    l.reprocessbilltypecode LIKE '83%%' OR
                    l.reprocessbilltypecode LIKE '85%%'
                )
            
        

        
            AND l.cptcode IN ('99213', '99214')
        

        
            AND REPLACE(l.diagcode, '.', '') IN ('E11.9')
        
)
SELECT * FROM tar_cte;