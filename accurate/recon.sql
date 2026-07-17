

DECLARE @MemberId VARCHAR(100) = '1000512462';

SELECT
    issuer,
    insurance_type,
    coverage_year,
    folder_year,

    policy_id,
    health_coverage_policy_no,

    member_id,
    issuer_indiv_identifier,
    exchg_assigned_enrollee_id,

    enrollee_status,
    maintenance_type_code,
    member_maint_effective_date,

    source_file_name,
    row_number_in_file,
    file_hash,
    load_run_id,
    loaded_at

FROM dbo.inbound_automation
WHERE
       LTRIM(RTRIM(member_id)) = @MemberId
    OR LTRIM(RTRIM(issuer_indiv_identifier)) = @MemberId
    OR LTRIM(RTRIM(exchg_assigned_enrollee_id)) = @MemberId
ORDER BY
    coverage_year,
    member_maint_effective_date,
    loaded_at;


=======================
SELECT
    issuer,
    insurance_type,
    coverage_year,
    folder_year,
    COUNT_BIG(*) AS row_count
FROM dbo.inbound_automation
WHERE issuer LIKE '%83502%'
GROUP BY
    issuer,
    insurance_type,
    coverage_year,
    folder_year
ORDER BY
    issuer,
    coverage_year,
    folder_year;

================

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
