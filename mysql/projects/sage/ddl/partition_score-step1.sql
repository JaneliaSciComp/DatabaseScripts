/*
  step 1 of 4 for converting score to a partitioned table.
  create partitioned table with partition logic trigger.
*/
DROP TABLE IF EXISTS `score_part`;

CREATE TABLE `score_part` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(10) unsigned DEFAULT NULL,
  `phase_id` int(10) unsigned DEFAULT NULL,
  `experiment_id` int(10) unsigned DEFAULT NULL,
  `term_id` int(10) unsigned NOT NULL,
  `cv_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` double NOT NULL,
  `run` int(10) unsigned NOT NULL DEFAULT '0',
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`cv_id`)
) ENGINE=InnoDB
PARTITION BY LIST (cv_id)
(PARTITION p0 VALUES IN (27),
 PARTITION p1 VALUES IN (30),
 PARTITION p2 VALUES IN (31),
 PARTITION p3 VALUES IN (38),
 PARTITION p4 VALUES IN (39),
 PARTITION p5 VALUES IN (47),
 PARTITION p6 VALUES IN (43),
 PARTITION p7 VALUES IN (50)
 );

DELIMITER /

DROP TRIGGER IF EXISTS partitionScore
/

CREATE TRIGGER partitionScore BEFORE INSERT ON  score_part
FOR EACH ROW
BEGIN
  DECLARE v_cv INT DEFAULT 0;
  DECLARE v_type INT DEFAULT null;

  IF (NEW.experiment_id IS NOT NULL) THEN

    SELECT e.type_id INTO v_type
    FROM experiment e
    WHERE e.id = NEW.experiment_id;

  ELSEIF (NEW.phase_id IS NOT NULL) THEN

    SELECT e.type_id INTO v_type
    FROM phase p
    JOIN experiment e on (p.experiment_id = e.id)
    WHERE p.id = NEW.phase_id;

  ELSE

    SELECT e.type_id INTO v_type
    FROM session s
    JOIN experiment e on (s.experiment_id = e.id)
    WHERE s.id = NEW.session_id;

  END IF;


  IF v_type IS NULL THEN

    SELECT NEW.type_id INTO v_type;

  END IF;

  SELECT cv_id INTO v_cv
  FROM cv_term
  WHERE id = v_type;

  SET NEW.cv_id = v_cv;

END;
/

DELIMITER ;
