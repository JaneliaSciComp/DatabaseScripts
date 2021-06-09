CREATE TABLE guid_namespace
(gname_id               INT NOT NULL AUTO_INCREMENT,
 gname_namespace        VARCHAR(100) NOT NULL,
 gname_creation_comment VARCHAR(4000),
 gname_create_date      DATE NOT NULL,
 gname_created_by       VARCHAR(200) NOT NULL,
 gname_modify_date      DATE,
 gname_modified_by      VARCHAR(200),
 CONSTRAINT gname_id_pk PRIMARY KEY USING BTREE (gname_id),
 CONSTRAINT gname_namespace_uk UNIQUE INDEX gname_namespace_uk_ind USING BTREE (gname_namespace))
ENGINE INNODB;

CREATE TABLE guid_block
(gblock_id               INT NOT NULL AUTO_INCREMENT,
 gblock_first_guid       BIGINT(20) NOT NULL, 
 gblock_last_guid        BIGINT(20) NOT NULL,
 gblock_namespace_id     INT NOT NULL,
 gblock_creation_comment VARCHAR(4000),
 gblock_block_size       BIGINT(20) NOT NULL,
 gblock_create_date      DATE NOT NULL,
 gblock_created_by       VARCHAR(200) NOT NULL,
 gblock_modify_date      DATE,
 gblock_modified_by      VARCHAR(200),
 CONSTRAINT gblock_id_pk PRIMARY KEY USING BTREE (gblock_id),
 CONSTRAINT gblock_first_guid_uk UNIQUE INDEX gblock_first_guid_uk_ind USING BTREE (gblock_first_guid),
 CONSTRAINT gblock_last_guid_uk UNIQUE INDEX gblock_last_guid_uk_ind USING BTREE (gblock_last_guid),
 CONSTRAINT gblock_namespace_id_fk FOREIGN KEY gblock_namespace_id_fk_ind (gblock_namespace_id) REFERENCES guid_namespace(gname_id))
ENGINE INNODB;

