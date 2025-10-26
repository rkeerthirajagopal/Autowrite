-- {{ concept_name }}
-- Description: {{ description }}

SELECT *
FROM Claims
WHERE 1=1
{% if target_type == 'single' %}
  AND CPT IN ({{ target_cpt_codes }})
{% elif target_type == 'target_reference' %}
  AND TargetCPT IN ({{ target_cpt_codes }})
  AND ReferenceCPT IN ({{ reference_cpt_codes }})
{% endif %}
AND ClaimType = '{{ claim_type }}'
{% if dx_codes %}
  AND DX IN ({{ dx_codes }})
{% endif %}
{% if member_provider_relation %}
  AND MemberProviderRelation = '{{ member_provider_relation }}'
{% endif %}
;
