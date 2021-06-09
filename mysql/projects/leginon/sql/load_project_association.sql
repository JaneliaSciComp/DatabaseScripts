create table project_association (session text, project text)

LOAD DATA LOCAL INFILE 'C:\\Documents and Settings\\dolafit\\My Documents\\SessionData.csv'
    INTO TABLE project_association
     FIELDS TERMINATED BY ','

insert into projectdata.projectexperiments (projectId,name,experimentsourceId)
select p.projectId,s.name,s.DEF_id
from projectdata.project_association pa, projectdata.projects p, dbemdata.SessionData s
where s.name = pa.session
and pa.project like concat(p.name,'%')

drop table project_association

