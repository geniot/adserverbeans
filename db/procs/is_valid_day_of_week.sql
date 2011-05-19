DELIMITER ;;
DROP FUNCTION if exists is_valid_day_of_week;
CREATE FUNCTION is_valid_day_of_week(day_bits VARCHAR(7), now_date_time TIMESTAMP )
RETURNS BOOL
DETERMINISTIC
NO SQL
BEGIN
  DECLARE currentWeekDay INTEGER;
  -- SET currentWeekDay = WEEKDAY(DATE(now_date_time)); - if week starts on Monday
  SET currentWeekDay = DAYOFWEEK(DATE(now_date_time)-1); -- if week starts on Sunday
  IF (SUBSTRING(day_bits,currentWeekDay+1,1)='1') THEN RETURN TRUE;END IF;  

  RETURN FALSE;
END
;;
delimiter ;
