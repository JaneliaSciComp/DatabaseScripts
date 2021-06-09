select concat('alter table `', TABLE_NAME, '` add constraint ', CONSTRAINT_NAME, ' foreign key(', COLUMN_NAME,') references ', REFERENCED_TABLE_NAME,'(',REFERENCED_COLUMN_NAME,');') 
from KEY_COLUMN_USAGE 
where TABLE_SCHEMA = 'workorder' 
  and REFERENCED_TABLE_NAME is not null;

