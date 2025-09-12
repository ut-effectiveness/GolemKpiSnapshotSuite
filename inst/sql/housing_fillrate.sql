-------------- Final Combined Housing Fillrate Query --------------

WITH cte_next_term_not_summer AS (
    SELECT a.term_desc,
           a.term_id AS real_term_id,
           a.registration_start_date - INTERVAL '1 day' AS real_next_reg_start_date,
           CASE
               WHEN a.season = 'Spring' THEN (CAST(a.term_id AS integer) + 20)::text
               ELSE a.next_term_id
           END AS next_term_not_summer
    FROM export.term a
),
cte_next_term_data AS (
    SELECT a.term_desc,
           COALESCE(b.real_term_id, a.term_id) AS real_term_id,
           (CAST(COALESCE(b.real_term_id, a.term_id) AS integer) - 100)::text AS last_term_id,
           current_date AS today
    FROM export.term a
    LEFT JOIN cte_next_term_not_summer b
        ON b.next_term_not_summer::text = a.term_id::text
    WHERE a.registration_start_date::date > current_date - INTERVAL '2 days'
      AND  b.real_next_reg_start_date::date < current_date - INTERVAL '2 days'
),
ranked_housing AS (
    SELECT
        a.slrrasg_term_code AS term_id,
        b.spriden_id AS student_id,
        a.slrrasg_bldg_code AS housing_building_id,
        a.slrrasg_ascd_code AS status_code,
        'current' AS year,
        ROW_NUMBER() OVER (
            PARTITION BY a.slrrasg_pidm
            ORDER BY
                a.slrrasg_ascd_date DESC,
                CASE WHEN a.slrrasg_ascd_code IN ('AC', 'IN') THEN a.slrrasg_begin_date ELSE NULL END DESC,
                CASE WHEN a.slrrasg_ascd_code IN ('RV', 'WD') THEN 1 ELSE 0 END
        ) AS rn
    FROM banner.slrrasg a
    LEFT JOIN banner.spriden b ON a.slrrasg_pidm = b.spriden_pidm
    LEFT JOIN cte_next_term_data c ON a.slrrasg_term_code::text = c.real_term_id::text
    WHERE NULLIF(b.spriden_change_ind, '') IS NULL
    AND a.slrrasg_term_code = c.real_term_id
),
cte_past AS (
    SELECT
        a.term_id,
        a.student_id,
        a.housing_building_id,
        a.status_code,
        'previous' AS year
    FROM quad.student_term_housing a
    LEFT JOIN export.buildings b ON b.building_abbrv = a.housing_building_id
    LEFT JOIN cte_next_term_data c ON a.term_id::text = c.last_term_id::text
    WHERE a.status_code != 'WD'
    AND a.term_id = c.last_term_id
),
final_combined AS (
    SELECT term_id, student_id, housing_building_id, status_code, year
    FROM ranked_housing
    WHERE rn = 1 AND status_code != 'WD'

    UNION

    SELECT term_id, student_id, housing_building_id, status_code, year
    FROM cte_past
)
SELECT a.*,

       b.building_name,
       b.number_of_beds
FROM final_combined a
LEFT JOIN export.buildings b ON b.building_abbrv = a.housing_building_id;
