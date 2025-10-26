-- {{ concept_name }} : {{ description }}

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

        {% if TargetClaimType %}
            {% if TargetClaimType|lower == 'outpatient' %}
                AND (
                    l.reprocessbilltypecode LIKE '13%%' OR
                    l.reprocessbilltypecode LIKE '14%%' OR
                    l.reprocessbilltypecode LIKE '83%%' OR
                    l.reprocessbilltypecode LIKE '85%%'
                )
            {% elif TargetClaimType|lower == 'inpatient' %}
                AND (l.reprocessbilltypecode LIKE '11%%')
            {% elif TargetClaimType|lower in ['proff', 'professional'] %}
                AND (l.reprocessbilltypecode IS NULL)
            {% else %}
                AND l.claimtype = '{{ TargetClaimType }}'
            {% endif %}
        {% endif %}

        {% if TargetCPTCodes %}
            AND l.cptcode IN ({{ TargetCPTCodes | join(', ') }})
        {% endif %}

        {% if DXCodes %}
            AND REPLACE(l.diagcode, '.', '') IN ({{ DXCodes | join(', ') }})
        {% endif %}
)
SELECT * FROM tar_cte;
