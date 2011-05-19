DELIMITER ;;
DROP PROCEDURE if exists get_report_proc;
CREATE PROCEDURE get_report_proc(IN type_in INTEGER,
                                 IN from_date_time_in TIMESTAMP,
                                 IN to_date_time_in TIMESTAMP,
                                 IN precision_in INTEGER,
                                 IN uids_in TEXT)
BEGIN
  DECLARE from_year  INTEGER;
  DECLARE from_month INTEGER;
  DECLARE from_day   INTEGER;
  DECLARE to_year    INTEGER;
  DECLARE to_month   INTEGER;
  DECLARE to_day     INTEGER;

  DECLARE first_month INTEGER;
  DECLARE first_day   INTEGER;
  DECLARE last_month  INTEGER;
  DECLARE last_day    INTEGER;

  SET from_year  = EXTRACT(YEAR FROM from_date_time_in);
  SET from_month = EXTRACT(MONTH FROM from_date_time_in);
  SET from_day   = EXTRACT(DAY FROM from_date_time_in);
  SET to_year    = EXTRACT(YEAR FROM to_date_time_in);
  SET to_month   = EXTRACT(MONTH FROM to_date_time_in);
  SET to_day     = EXTRACT(DAY FROM to_date_time_in);

  SET first_month = 1;
  SET first_day   = 1;
  SET last_month  = 12;
  SET last_day    = 31;

  SET @sql = 'SELECT entity_key, views, clicks, ts_year, ts_month, ts_date, ts_hour FROM aggregate_reports WHERE ';

  IF (from_date_time_in IS NOT NULL AND to_date_time_in IS NOT NULL) THEN
    IF (to_year - from_year > 1) THEN
      SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, from_year + 1, first_month, first_day, to_year - 1, last_month, last_day, precision_in, uids_in), ' OR ');
    END IF;

    IF (to_year - from_year != 0) THEN
      IF (last_month - from_month > 0) THEN
        SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, from_year, from_month + 1, first_day, from_year, last_month, last_day, precision_in, uids_in), ' OR ');
      END IF;
      SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, from_year, from_month, from_day, from_year, from_month, last_day, precision_in, uids_in), ' OR ');

      IF (to_month - first_month > 0) THEN
        SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, to_year, first_month, first_day, to_year, to_month - 1, last_day, precision_in, uids_in), ' OR ');
      END IF;
      SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, to_year, to_month, first_day, to_year, to_month, to_day, precision_in, uids_in), ' OR ');
    ELSE
      IF (to_month - from_month > 1) THEN
        SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, from_year, from_month + 1, first_day, from_month, to_month - 1, last_day, precision_in, uids_in), ' OR ');
      END IF;

      IF (to_month - from_month != 0) THEN
        SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, from_year, from_month, from_day, from_year, from_month, last_day, precision_in, uids_in), ' OR ');
        SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, from_year, to_month, first_day, from_year, to_month, to_day, precision_in, uids_in), ' OR ');
      ELSE
        SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, from_year, from_month, from_day, from_year, to_month, to_day, precision_in, uids_in), ' OR ');
      END IF;
    END IF;

    IF RIGHT(@sql, 4) = ' OR ' THEN
      SET @sql = LEFT(@sql, LENGTH(@sql) - 4);
    END IF;
  ELSE
    SET @sql = CONCAT(@sql, create_key_from_criteria(type_in, from_year, from_month, from_day, from_year, to_month, to_day, precision_in, uids_in));
  END IF;

  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END;;
delimiter ;
