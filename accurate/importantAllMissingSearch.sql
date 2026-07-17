/* ============================================================
   SWATHI REPORT'TA VAR, SELMA REPORT'TA YOK GÖRÜNEN ENROLLEE ID'LER
   ============================================================ */

DECLARE @EnrolleeIds NVARCHAR(MAX) = N'
1000512462
1000512461
1000512464
1000512463
1000512465
1000963464
1001148905
1001475165
1000320577
1000380036
1000534867
1000544826
1000773598
1001541995
1006501517
1006689984
1006979969
1000106277
1000496452
1000812819
1001137654
1001274496
1006457593
1006457594
1004667834
1006953176
1006953231
1007121665
1000384586
1000776984
1000782577
1001037750
1008168010
1006491355
1006491330
1006491353
1006491354
1001831699
1000038554
1000139813
1000139812
1000144739
1000159794
1006169775
1000340206
1000477967
1000501626
1000552191
1000552192
1000995599
1001183896
1001257751
1001257752
1001257749
1001307326
1001307329
1001307327
1001307328
1001353830
1006327896
1001875091
1005437281
1005437280
1005437259
1006949821
1000263767
1000372039
1000372037
1000372040
1001071339
1001071337
1001242720
1001242719
1001322482
1001343108
1001643652
1002354134
1002163116
1003801594
1007612273
1000468938
1000913265
1001210077
1001210076
1001210069
1001423810
1002440588
1006457453
1002168067
1005887322
1005887321
1005887320
1005887317
1005887319
1000003628
1000011672
1000038750
1000083582
1000097790
1000105937
1000139136
1000140247
1000167944
1000167882
1000167885
1000228238
1000228239
1000248497
1000248498
1000328349
1000328348
1000451658
1000509681
1000527389
1000527393
1000527392
1000527390
1000527391
1000545968
1000576919
1000586893
1000618626
1000659344
1001741286
1000669018
1000701976
1000712044
1000726169
1000726167
1000726170
1000758223
1000804802
1000804803
1000804800
1006646464
1001962065
1001962064
1000918992
1000958757
1000958756
1000958755
1000958753
1000986951
1001048669
1001053082
1001058160
1001058162
1001117757
1001149872
1001153483
1001186756
1001204974
1001239796
1001239801
1001245606
1001276174
1001304811
1001336828
1001352281
1001352279
1002539054
1001364294
1001372568
1001832711
1001414597
1001496204
1001496194
1001505333
1001557230
1001594883
1001609189
1001620705
1001622994
1001622995
1001628750
1001636165
1001638948
1001673519
1001673518
1001673515
1001673517
1001680839
1001680840
1001712064
1001787607
1002054309
1002054310
1002054308
1002054300
1001938862
1001995942
1001942996
1001995941
1001995943
1001966324
1001997074
1002019031
1002019173
1002019174
1002050776
1002050817
1002158621
1002163511
1002163512
1002163513
1002163510
1005125655
1002172374
1002248825
1002221259
1002226107
1002251064
1002428401
1002542852
1004213631
1004721249
1004721248
1004721247
1004721246
1005800533
1005559814
1005559813
1005559812
1005719884
1006833793
1006511415
1006802811
1006980109
1006980108
1006980110
1007432443
1007765200
1007765191
1007765201
1007765202
1007765203
1007976213
1007976198
1008040549
1008140879
1008140723
';

/* Satır sonlarını temizle, boşları çıkar ve duplicate ID'leri kaldır */
DROP TABLE IF EXISTS #MissingEnrollees;

SELECT DISTINCT
    LTRIM(RTRIM(value)) AS enrollee_id
INTO #MissingEnrollees
FROM STRING_SPLIT(
    REPLACE(@EnrolleeIds, CHAR(13), ''),
    CHAR(10)
)
WHERE LTRIM(RTRIM(value)) <> '';


/* DB'deki üç olası enrollee identifier alanını tek yapıya getir */
DROP TABLE IF EXISTS #DBMatches;

SELECT
    m.enrollee_id AS searched_enrollee_id,

    ia.issuer,
    ia.insurance_type,
    ia.coverage_year,
    ia.folder_year,

    ia.policy_id,
    ia.health_coverage_policy_no,

    ia.member_id,
    ia.issuer_indiv_identifier,
    ia.exchg_assigned_enrollee_id,

    matched.matching_field,
    matched.matching_value,

    ia.enrollee_status,
    ia.maintenance_type_code,
    ia.member_maint_effective_date,

    ia.source_file_name,
    ia.row_number_in_file,
    ia.file_hash,
    ia.load_run_id,
    ia.loaded_at

INTO #DBMatches
FROM dbo.inbound_automation ia

CROSS APPLY
(
    VALUES
        ('member_id',
            NULLIF(LTRIM(RTRIM(ia.member_id)), '')),

        ('issuer_indiv_identifier',
            NULLIF(LTRIM(RTRIM(ia.issuer_indiv_identifier)), '')),

        ('exchg_assigned_enrollee_id',
            NULLIF(LTRIM(RTRIM(ia.exchg_assigned_enrollee_id)), ''))
) matched(matching_field, matching_value)

INNER JOIN #MissingEnrollees m
    ON m.enrollee_id = matched.matching_value;


/* ============================================================
   RESULT 1: HER ID İÇİN FOUND / NOT FOUND DURUMU
   ============================================================ */

SELECT
    m.enrollee_id AS [Searched Enrollee ID],

    CASE
        WHEN EXISTS
        (
            SELECT 1
            FROM #DBMatches d
            WHERE d.searched_enrollee_id = m.enrollee_id
        )
        THEN 'FOUND IN DB'
        ELSE 'NOT FOUND IN DB'
    END AS [DB Result],

    (
        SELECT COUNT(*)
        FROM #DBMatches d
        WHERE d.searched_enrollee_id = m.enrollee_id
    ) AS [Matching Raw Rows]

FROM #MissingEnrollees m
ORDER BY
    [DB Result],
    m.enrollee_id;


/* ============================================================
   RESULT 2: BULUNAN KAYITLARIN TÜM DETAYLARI
   ============================================================ */

SELECT
    searched_enrollee_id AS [Searched Enrollee ID],
    matching_field AS [Matched Through],
    matching_value AS [Matched DB Value],

    issuer AS [HIOS Issuer ID],
    insurance_type AS [Insurance Type],
    coverage_year AS [Coverage Year],
    folder_year AS [Folder Year],

    policy_id AS [Policy ID],
    health_coverage_policy_no AS [Health Coverage Policy Number],

    member_id AS [Member ID],
    issuer_indiv_identifier AS [Issuer Individual Identifier],
    exchg_assigned_enrollee_id AS [Exchange Assigned Enrollee ID],

    enrollee_status AS [Enrollee Status],
    maintenance_type_code AS [Maintenance Type],
    member_maint_effective_date AS [Maintenance Effective Date],

    source_file_name AS [Source File],
    row_number_in_file AS [Row Number in File],
    file_hash AS [File Hash],
    load_run_id AS [Load Run ID],
    loaded_at AS [Loaded At]

FROM #DBMatches
ORDER BY
    searched_enrollee_id,
    coverage_year,
    member_maint_effective_date,
    loaded_at;


/* ============================================================
   RESULT 3: DB'DE HİÇ BULUNMAYAN ID'LER
   ============================================================ */

SELECT
    m.enrollee_id AS [Not Found Enrollee ID]
FROM #MissingEnrollees m
WHERE NOT EXISTS
(
    SELECT 1
    FROM #DBMatches d
    WHERE d.searched_enrollee_id = m.enrollee_id
)
ORDER BY
    m.enrollee_id;


/* ============================================================
   RESULT 4: ÖZET
   ============================================================ */

SELECT
    COUNT(*) AS [Total Unique IDs Searched],

    SUM(
        CASE
            WHEN EXISTS
            (
                SELECT 1
                FROM #DBMatches d
                WHERE d.searched_enrollee_id = m.enrollee_id
            )
            THEN 1 ELSE 0
        END
    ) AS [Unique IDs Found in DB],

    SUM(
        CASE
            WHEN NOT EXISTS
            (
                SELECT 1
                FROM #DBMatches d
                WHERE d.searched_enrollee_id = m.enrollee_id
            )
            THEN 1 ELSE 0
        END
    ) AS [Unique IDs Not Found in DB]

FROM #MissingEnrollees m;


/* ============================================================
   RESULT 5: BULUNANLAR HANGİ YIL / ISSUER ALTINDA?
   ============================================================ */

SELECT
    issuer AS [HIOS Issuer ID],
    insurance_type AS [Insurance Type],
    coverage_year AS [Coverage Year],
    folder_year AS [Folder Year],

    COUNT(DISTINCT searched_enrollee_id) AS [Unique Enrollees Found],
    COUNT_BIG(*) AS [Raw Rows Found]

FROM #DBMatches
GROUP BY
    issuer,
    insurance_type,
    coverage_year,
    folder_year
ORDER BY
    issuer,
    coverage_year,
    folder_year;
