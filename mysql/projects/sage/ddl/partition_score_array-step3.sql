DROP table score_array;

RENAME TABLE score_array_part TO score_array;

DELIMITER /

DROP TRIGGER IF EXISTS partitionScoreArray
/

CREATE TRIGGER partitionScoreArray BEFORE INSERT ON  score_array
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
