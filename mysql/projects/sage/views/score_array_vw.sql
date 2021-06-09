CREATE OR REPLACE VIEW score_array_vw AS
SELECT  sa.id           AS id,
        sa.session_id   AS session_id,
        sa.phase_id     AS phase_id,
        sa.experiment_id AS experiment_id,
        s.name          AS session,
        p.name          AS phase,
        e.name          AS experiment,
        cv2.name        AS cv_term,
        cv_term2.name   AS term,
        cv.name         AS cv,
        cv_term.name    AS type,
        sa.value        AS value,
        sa.run          AS run,
        sa.data_type    AS data_type,
        sa.row_count    AS row_count,
        sa.column_count AS column_count,
        sa.create_date  AS create_date
FROM score_array sa
JOIN cv_term ON (sa.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
JOIN cv_term cv_term2 ON (sa.term_id = cv_term2.id)
JOIN cv cv2 ON (cv_term2.cv_id = cv2.id)
LEFT OUTER JOIN session s ON (sa.session_id = s.id)
LEFT OUTER JOIN phase p ON (sa.phase_id = p.id)
LEFT OUTER JOIN experiment e ON (sa.experiment_id = e.id);
