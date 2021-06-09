create or replace view feature_current_status_timestamp as
select feature_id,max(timelastmodified) as timelastmodified
from feature_status_history
group by feature_id;

alter table feature_current_status_timestamp owner to "chacrmAdmin";
grant select on feature_current_status_timestamp to chacrm_select, public;


create or replace view feature_current_status as
select h.*
from public.feature_status_history h 
join feature_current_status_timestamp c ON (c.feature_id = h.feature_id AND c.timelastmodified = h.timelastmodified);

alter table feature_current_status owner to "chacrmAdmin";
grant select on feature_current_status to chacrm_select, public;


CREATE or replace VIEW
    fragment_transformant_status_current_report ( status, fragments, transformants, AA, AB, AC, AD, AE, LC, LE, LJ, LK, LL ) AS
SELECT
    x.status,
    COUNT(
        CASE x."type"
            WHEN 'tiling_path_fragment'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS fragments,
    COUNT(
        CASE x."type"
            WHEN 'transformant'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS transformants,
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'AA'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "AA",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'AB'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "AB",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'AC'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "AC",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'AD'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "AD",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'AE'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "AE",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'LC'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "LC",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'LE'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "LE",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'LJ'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "LJ",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'LK'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "LK",
    SUM(
        CASE "substring"((x.name)::text, ("position"((x.name)::text, '_'::text) + 1), 2)
            WHEN 'LL'::text
            THEN 1
            ELSE NULL::INTEGER
        END) AS "LL"
FROM
    (
        SELECT DISTINCT
            f.name,
            fsh.status,
            f."type"
        FROM
            (feature_current_status fsh
        JOIN tfeature f
        ON
            (
                (
                    f.feature_id = fsh.feature_id
                )
            )
            )
        ORDER BY
            f.name,
            fsh.status,
            f."type"
    )
    x
GROUP BY
    x.status
ORDER BY
    x.status;

alter table fragment_transformant_status_current_report owner to "chacrmAdmin";
grant select on fragment_transformant_status_current_report to chacrm_select, public;

select * from fragment_transformant_status_current_report;

