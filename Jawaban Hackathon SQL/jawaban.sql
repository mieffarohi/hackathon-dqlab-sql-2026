-- ============================================================
-- Solusi Hackathon "HACK-2026-SQL-01"
-- Compatible MySQL 5.7
-- ============================================================


/* ============================================================
STEP 1 - Mapping hierarchy ke manager level 2
============================================================ */

DROP TEMPORARY TABLE IF EXISTS tmp_hierarchy;

CREATE TEMPORARY TABLE tmp_hierarchy AS
SELECT
    n0.id AS node_id,

    CASE
        WHEN n1.id = 'ROOT' THEN n0.id
        WHEN n2.id = 'ROOT' THEN n1.id
        WHEN n3.id = 'ROOT' THEN n2.id
        WHEN n4.id = 'ROOT' THEN n3.id
        WHEN n5.id = 'ROOT' THEN n4.id
        WHEN n6.id = 'ROOT' THEN n5.id
        WHEN n7.id = 'ROOT' THEN n6.id
        WHEN n8.id = 'ROOT' THEN n7.id
        WHEN n9.id = 'ROOT' THEN n8.id
        WHEN n10.id = 'ROOT' THEN n9.id
        ELSE NULL
    END AS level2

FROM nodes n0

LEFT JOIN nodes n1
    ON n1.id = n0.parent_id

LEFT JOIN nodes n2
    ON n2.id = n1.parent_id

LEFT JOIN nodes n3
    ON n3.id = n2.parent_id

LEFT JOIN nodes n4
    ON n4.id = n3.parent_id

LEFT JOIN nodes n5
    ON n5.id = n4.parent_id

LEFT JOIN nodes n6
    ON n6.id = n5.parent_id

LEFT JOIN nodes n7
    ON n7.id = n6.parent_id

LEFT JOIN nodes n8
    ON n8.id = n7.parent_id

LEFT JOIN nodes n9
    ON n9.id = n8.parent_id

LEFT JOIN nodes n10
    ON n10.id = n9.parent_id

WHERE n0.id <> 'ROOT';



/* ============================================================
STEP 2 - Mapping orders ke level2
============================================================ */

DROP TEMPORARY TABLE IF EXISTS tmp_orders_mapped;

CREATE TEMPORARY TABLE tmp_orders_mapped AS
SELECT
    o.no_urut,
    o.node_id,
    o.nilai_order,
    h.level2
FROM orders o
JOIN tmp_hierarchy h
    ON h.node_id = o.node_id
WHERE h.level2 IS NOT NULL;



/* ============================================================
STEP 3 - Statistik per level2
============================================================ */

DROP TEMPORARY TABLE IF EXISTS tmp_stats;

CREATE TEMPORARY TABLE tmp_stats AS
SELECT
    level2,
    AVG(nilai_order) AS average,
    STDDEV_POP(nilai_order) AS stdev
FROM tmp_orders_mapped
GROUP BY level2;



/* ============================================================
STEP 4 - Cari outlier
============================================================ */

DROP TEMPORARY TABLE IF EXISTS tmp_outliers;

CREATE TEMPORARY TABLE tmp_outliers AS
SELECT
    m.level2,
    m.node_id AS id,
    m.nilai_order,
    s.average,
    s.stdev,

    (m.nilai_order - s.average) AS jarak_average,

    CASE
        WHEN s.stdev = 0 THEN 0
        ELSE (m.nilai_order - s.average) / s.stdev
    END AS z_score

FROM tmp_orders_mapped m

JOIN tmp_stats s
    ON s.level2 = m.level2

WHERE
    m.nilai_order > (s.average + (3 * s.stdev))
    OR
    m.nilai_order < (s.average - (3 * s.stdev));



/* ============================================================
STEP 5 - Summary
============================================================ */

DROP TEMPORARY TABLE IF EXISTS tmp_summary;

CREATE TEMPORARY TABLE tmp_summary AS
SELECT
    level2,
    COUNT(*) AS jumlah_anomali
FROM tmp_outliers
GROUP BY level2;



/* ============================================================
STEP 6 - Final Output
============================================================ */

SELECT
    level2,
    jumlah_anomali,
    NULL AS id,
    NULL AS nilai_order,
    NULL AS average,
    NULL AS stdev,
    NULL AS jarak_average,
    NULL AS z_score
FROM tmp_summary

UNION ALL

SELECT
    level2,
    NULL AS jumlah_anomali,
    id,
    nilai_order,
    average,
    stdev,
    jarak_average,
    z_score
FROM tmp_outliers

ORDER BY level2, jumlah_anomali DESC;