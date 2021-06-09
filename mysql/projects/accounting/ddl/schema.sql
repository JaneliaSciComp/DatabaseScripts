DROP TABLE IF EXISTS compute_accounting;

CREATE TABLE compute_accounting (
  qname    VARCHAR(50) NOT NULL,
  hostname VARCHAR(50) NOT NULL,
  group_name VARCHAR(50) NOT NULL,
  owner    VARCHAR(50) NOT NULL,
  jobname    VARCHAR(50) NOT NULL,
  jobnumber  BIGINT(20) UNSIGNED NOT NULL,
  account    VARCHAR(50) NOT NULL,
  priority   INTEGER UNSIGNED NOT NULL,
  qsub_time  TIMESTAMP NOT NULL,
  start_time TIMESTAMP NOT NULL,
  end_time   TIMESTAMP NOT NULL,
  failed     VARCHAR(50) NOT NULL,
  exit_status  INTEGER UNSIGNED NOT NULL,
  ru_wallclock BIGINT(20) UNSIGNED NOT NULL,
  project  VARCHAR(50) NOT NULL,
  department VARCHAR(50) NOT NULL,
  granted_pe VARCHAR(50) NOT NULL,
  slots      INTEGER UNSIGNED NOT NULL,
  taskid     VARCHAR(50) NOT NULL,
  cpu          BIGINT(20) UNSIGNED NOT NULL,
  mem          BIGINT(20) UNSIGNED NOT NULL,
  io           BIGINT(20) UNSIGNED NOT NULL,
  category VARCHAR(50) NOT NULL,
  iow          BIGINT(20) UNSIGNED NOT NULL,
  pe_taskid VARCHAR(50) NOT NULL,
  maxvmem      BIGINT(20) UNSIGNED NOT NULL,
  -- ru_utime     BIGINT(20) UNSIGNED NOT NULL,
  -- ru_stime     BIGINT(20) UNSIGNED NOT NULL,
  -- ru_maxrss    BIGINT(20) UNSIGNED NOT NULL,
  -- ru_ixrss     BIGINT(20) UNSIGNED NOT NULL,
  -- ru_ismrss    BIGINT(20) UNSIGNED NOT NULL,
  -- ru_idrss     BIGINT(20) UNSIGNED NOT NULL,
  -- ru_isrss     BIGINT(20) UNSIGNED NOT NULL,
  -- ru_minflt    BIGINT(20) UNSIGNED NOT NULL,
  -- ru_majflt    BIGINT(20) UNSIGNED NOT NULL,
  -- ru_nswap     BIGINT(20) UNSIGNED NOT NULL,
  -- ru_inblock   BIGINT(20) UNSIGNED NOT NULL,
  -- ru_oublock   BIGINT(20) UNSIGNED NOT NULL,
  -- ru_msgsnd    BIGINT(20) UNSIGNED NOT NULL,
  -- ru_msgrcv    BIGINT(20) UNSIGNED NOT NULL,
  -- ru_nsignals  BIGINT(20) UNSIGNED NOT NULL,
  -- ru_nvcsw     BIGINT(20) UNSIGNED NOT NULL,
  -- ru_nivcsw    BIGINT(20) UNSIGNED NOT NULL,
  PRIMARY KEY(jobnumber,hostname,end_time)
)
ENGINE InnoDB;

CREATE INDEX end_time_ind USING BTREE ON compute_accounting(end_time);
CREATE INDEX start_time_ind USING BTREE ON compute_accounting(start_time);

DROP TABLE IF EXISTS department;

CREATE TABLE department (
  name    VARCHAR(50) NOT NULL,
  password   VARCHAR(50) NULL,
  code  VARCHAR(50) NOT NULL,
  users    VARCHAR(1000) NULL,
 PRIMARY KEY(code,name)
)
ENGINE InnoDB;

DROP TABLE IF EXISTS compute_chargeback;

CREATE TABLE compute_chargeback (
  id                INTEGER NOT NULL auto_increment,
  project           VARCHAR(100) NOT NULL,
  department_code   VARCHAR(50) NOT NULL,
  owner             VARCHAR(100) NOT NULL,
  end_time          DATE NOT NULL,
  wallclock         BIGINT NOT NULL,
  rate              DOUBLE NOT NULL,
  units             INT NOT NULL,
  cost              DOUBLE NOT NULL,
  close_date        DATE NOT NULL,
 PRIMARY KEY(id)
)
ENGINE InnoDB;


DROP TABLE IF EXISTS scientific_computing_chargeback;

CREATE TABLE scientific_computing_chargeback (
  id                INTEGER NOT NULL auto_increment,
  close_date        DATE NOT NULL,
  department_code   VARCHAR(50) NOT NULL,
  project           VARCHAR(100) NOT NULL,
  fte               DOUBLE NOT NULL,
  rate              INT NOT NULL,
  project_code      VARCHAR(12) NULL,
 PRIMARY KEY(id)
)
ENGINE InnoDB;

CREATE UNIQUE INDEX scientific_computing_ind USING BTREE ON scientific_computing_chargeback(project,department_code,close_date);

DROP TABLE IF EXISTS computing_services_chargeback;

CREATE TABLE computing_services_chargeback (
  id                INTEGER NOT NULL auto_increment,
  close_date        DATE NOT NULL,
  department_code   VARCHAR(50) NOT NULL,
  service           VARCHAR(100) NOT NULL,
  unit              DOUBLE NOT NULL,
  rate              INT NOT NULL,
  project_code      VARCHAR(12) NULL, 
 PRIMARY KEY(id)
)
ENGINE InnoDB;

CREATE UNIQUE INDEX computing_services_chargeback_uk_ind USING BTREE ON computing_services_chargeback(service,department_code,close_date,project_code);

