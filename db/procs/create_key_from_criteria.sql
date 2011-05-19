DELIMITER ;;
DROP FUNCTION if exists create_key_from_criteria;
CREATE FUNCTION create_key_from_criteria(type_in INTEGER,
                                         from_year INTEGER,
                                         from_month INTEGER,
                                         from_day INTEGER,
                                         to_year INTEGER,
                                         to_month INTEGER,
                                         to_day INTEGER,
                                         precision_in INTEGER,
                                         uids_in TEXT)
RETURNS TEXT
DETERMINISTIC
NO SQL
BEGIN
  DECLARE key_out    TEXT;
  DECLARE start_uid_index INTEGER;
  DECLARE end_uid_index INTEGER;

  SET key_out = '(';
  SET start_uid_index = 1;

  CASE precision_in
    WHEN -1 THEN
      SET key_out = CONCAT(key_out, 'ts_year is null and ts_month is null and ts_date is null and ts_hour is null and (');
    WHEN 0 THEN
      SET key_out = CONCAT(key_out, 'ts_year >= ', from_year, ' and ts_year <= ', to_year, ' and ');
      SET key_out = CONCAT(key_out, 'ts_month >= ', from_month, ' and ts_month <= ', to_month, ' and ');
      SET key_out = CONCAT(key_out, 'ts_date >= ', from_day, ' and ts_date <= ', to_day, ' and ');
      SET key_out = CONCAT(key_out, 'ts_hour is not null and (');
    WHEN 1 THEN
      SET key_out = CONCAT(key_out, 'ts_year >= ', from_year, ' and ts_year <= ', to_year, ' and ');
      SET key_out = CONCAT(key_out, 'ts_month >= ', from_month, ' and ts_month <= ', to_month, ' and ');
      SET key_out = CONCAT(key_out, 'ts_date >= ', from_day, ' and ts_date <= ', to_day, ' and ');
      SET key_out = CONCAT(key_out, 'ts_hour is null and (');
    WHEN 2 THEN
      SET key_out = CONCAT(key_out, 'ts_year >= ', from_year, ' and ts_year <= ', to_year, ' and ');
      SET key_out = CONCAT(key_out, 'ts_month >= ', from_month, ' and ts_month <= ', to_month, ' and ');
      SET key_out = CONCAT(key_out, 'ts_date is null and ');
      SET key_out = CONCAT(key_out, 'ts_hour is null and (');
    WHEN 3 THEN
      SET key_out = CONCAT(key_out, 'ts_year >= ', from_year, ' and ts_year <= ', to_year, ' and ');
      SET key_out = CONCAT(key_out, 'ts_month is null and ');
      SET key_out = CONCAT(key_out, 'ts_date is null and ');
      SET key_out = CONCAT(key_out, 'ts_hour is null and (');
  END CASE;

  CASE type_in
    WHEN 0 THEN
      SET key_out = CONCAT(key_out, 'entity_key like \'0(%)\' or ');
    WHEN 1 THEN
      IF (uids_in = '') THEN
        SET key_out = CONCAT(key_out, 'entity_key like \'1:%(%)\' or ');
      ELSE
        SET end_uid_index = LOCATE(';', uids_in, start_uid_index);
        WHILE end_uid_index != 0 DO
          SET key_out = CONCAT(key_out, 'entity_key like CONCAT(\'1:\',', get_id_by_uid('banner', SUBSTRING(uids_in, start_uid_index, end_uid_index - start_uid_index)), ',\'(%)\')  or ');
          SET start_uid_index = end_uid_index + 1;
          SET end_uid_index = LOCATE(';', uids_in, start_uid_index);
        END WHILE;
        SET key_out = CONCAT(key_out, 'entity_key like CONCAT(\'1:\',', get_id_by_uid('banner', SUBSTRING(uids_in, start_uid_index, LENGTH(uids_in) - start_uid_index + 1)), ',\'(%)\')  or ');
      END IF;
    WHEN 2 THEN
      IF (uids_in = '') THEN
        SET key_out = CONCAT(key_out, 'entity_key like \'2:%(%)\' or ');
      ELSE
        SET end_uid_index = LOCATE(';', uids_in, start_uid_index);
        WHILE end_uid_index != 0 DO
          SET key_out = CONCAT(key_out, 'entity_key like CONCAT(\'2:\',', get_id_by_uid('ad_place', SUBSTRING(uids_in, start_uid_index, end_uid_index - start_uid_index)), ',\'(%)\')  or ');
          SET start_uid_index = end_uid_index + 1;
          SET end_uid_index = LOCATE(';', uids_in, start_uid_index);
        END WHILE;
        SET key_out = CONCAT(key_out, 'entity_key like CONCAT(\'2:\',', get_id_by_uid('ad_place', SUBSTRING(uids_in, start_uid_index, LENGTH(uids_in) - start_uid_index + 1)), ',\'(%)\')  or ');
      END IF;
    WHEN 3 THEN
      IF (uids_in = '') THEN
        SET key_out = CONCAT(key_out, 'entity_key like \'3:%x%(%)\' or ');
      ELSE
        SET end_uid_index = LOCATE('x', uids_in, start_uid_index);
        WHILE end_uid_index != 0 DO
          SET key_out = CONCAT(key_out, 'entity_key like CONCAT(\'3:\',', get_id_by_uid('banner', SUBSTRING(uids_in, start_uid_index, end_uid_index - start_uid_index)));
          SET start_uid_index = end_uid_index + 1;
          SET end_uid_index = LOCATE(';', uids_in, start_uid_index);
          IF (end_uid_index != 0) THEN
            SET key_out = CONCAT(key_out, ',\'x\',', get_id_by_uid('ad_place', SUBSTRING(uids_in, start_uid_index, end_uid_index - start_uid_index)), ',\'(%)\')  or ');
          ELSE
            SET key_out = CONCAT(key_out, ',\'x\',', get_id_by_uid('ad_place', SUBSTRING(uids_in, start_uid_index, LENGTH(uids_in) - start_uid_index + 1)), ',\'(%)\')  or ');
            SET end_uid_index = LENGTH(uids_in);
          END IF;
          SET start_uid_index = end_uid_index + 1;
          SET end_uid_index = LOCATE('x', uids_in, start_uid_index);
        END WHILE;
      END IF;
  END CASE;

  IF RIGHT(key_out, 4) = ' or ' THEN
    SET key_out = LEFT(key_out, LENGTH(key_out) - 4);
  END IF;

  IF RIGHT(key_out, 5) = 'and (' THEN
    SET key_out = LEFT(key_out, LENGTH(key_out) - 5);
  ELSE
    SET key_out = CONCAT(key_out, ')');
  END IF;
  SET key_out = CONCAT(key_out, ')');

  RETURN key_out;
END
;;
delimiter ;

