-- {{ concept_name }} : {{ description }}
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
    {% if ProviderRelation == 'same_provider' and MemberRelation == 'same_member' %}
        a.tar_provider = l.provider AND a.tar_member = l.member
    {% elif ProviderRelation == 'same_provider' %}
        a.tar_provider = l.provider
    {% elif MemberRelation == 'same_member' %}
        a.tar_member = l.member
    {% else %}
        a.tar_claim = l.claim
    {% endif %}
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

    {% if ReferenceCPTCodes %}
        AND l.cptcode IN ({{ ReferenceCPTCodes | join(', ') }})
    {% endif %}

    {% if DXCodes %}
        AND REPLACE(l.diagcode, '.', '') IN ({{ DXCodes | join(', ') }})
    {% endif %}
;
