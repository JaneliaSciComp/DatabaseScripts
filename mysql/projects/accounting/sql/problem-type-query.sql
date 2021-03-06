SELECT a.PROBLEM_TYPE_NAME as shared_resource,a.PROBLEM_TYPE_ID as problem_type_id,a.PROBLEM_TYPE_NAME as problem_type_name
FROM PROBLEM_TYPE a
WHERE a.PARENT_ID is NULL
UNION
SELECT a.PROBLEM_TYPE_NAME as shared_resource,a.PROBLEM_TYPE_ID as problem_type_id,a.PROBLEM_TYPE_NAME as problem_type_name
FROM PROBLEM_TYPE a
WHERE a.PARENT_ID = 3
UNION
SELECT b.PROBLEM_TYPE_NAME as shared_resource,a.PROBLEM_TYPE_ID as problem_type_id,a.PROBLEM_TYPE_NAME as problem_type_name
FROM PROBLEM_TYPE a
    ,PROBLEM_TYPE b
WHERE a.PARENT_ID = b.PROBLEM_TYPE_ID
AND b.PARENT_ID = 3
UNION
SELECT c.PROBLEM_TYPE_NAME,a.PROBLEM_TYPE_ID,a.PROBLEM_TYPE_NAME as problem_type_name
FROM PROBLEM_TYPE a
    ,PROBLEM_TYPE b
    ,PROBLEM_TYPE c
WHERE a.PARENT_ID = b.PROBLEM_TYPE_ID
AND b.PARENT_ID = c.PROBLEM_TYPE_ID
AND c.PARENT_ID = 3
UNION
SELECT d.PROBLEM_TYPE_NAME,a.PROBLEM_TYPE_ID,a.PROBLEM_TYPE_NAME as problem_type_name
FROM PROBLEM_TYPE a
    ,PROBLEM_TYPE b
    ,PROBLEM_TYPE c
    ,PROBLEM_TYPE d
WHERE a.PARENT_ID = b.PROBLEM_TYPE_ID
AND b.PARENT_ID = c.PROBLEM_TYPE_ID
AND c.PARENT_ID = d.PROBLEM_TYPE_ID
AND d.PARENT_ID = 3
;
