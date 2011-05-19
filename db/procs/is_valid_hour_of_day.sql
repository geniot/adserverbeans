DELIMITER ;;
DROP FUNCTION if exists is_valid_hour_of_day;
CREATE FUNCTION is_valid_hour_of_day(hour_bits VARCHAR(24), now_date_time TIMESTAMP )
RETURNS BOOL
DETERMINISTIC
NO SQL
BEGIN
  DECLARE currentDayHour INTEGER;
  SET currentDayHour = HOUR(now_date_time);
  IF (SUBSTRING(hour_bits,currentDayHour+1,1)='1') THEN RETURN TRUE;END IF;  

  RETURN FALSE;
END
;;
delimiter ;
