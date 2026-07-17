




SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'inbound_automation'
  AND COLUMN_NAME LIKE '%status%';





SELECT DISTINCT
    issuer AS [HIOS Issuer ID],
    insurance_type AS [Insurance Type],
    coverage_year AS [Coverage Year],

    COALESCE(
        NULLIF(LTRIM(RTRIM(policy_id)), ''),
        NULLIF(LTRIM(RTRIM(health_coverage_policy_no)), '')
    ) AS [Policy ID],

    COALESCE(
        NULLIF(LTRIM(RTRIM(member_id)), ''),
        NULLIF(LTRIM(RTRIM(issuer_indiv_identifier)), ''),
        NULLIF(LTRIM(RTRIM(exchg_assigned_enrollee_id)), '')
    ) AS [Enrollee ID],

    enrollee_status AS [Enrollee Status],

    maintenance_type_code AS [Maintenance Type],

    member_maint_effective_date AS [Enrollment Date],

    source_file_name AS [Source File],
    loaded_at AS [Loaded At]

FROM dbo.inbound_automation
WHERE issuer = '83502'
  AND coverage_year = 2026
ORDER BY
    [Policy ID],
    [Enrollee ID],
    member_maint_effective_date;
