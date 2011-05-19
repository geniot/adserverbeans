DELIMITER ;;
DROP FUNCTION if exists is_valid_ip;
CREATE FUNCTION is_valid_ip(banner_uid_in VARCHAR(255), ip BIGINT)
RETURNS BOOL
NOT DETERMINISTIC
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE  response BOOL DEFAULT FALSE;
DECLARE ip_from_value BIGINT;
DECLARE ip_to_value BIGINT;
DECLARE ip_patterns_count INTEGER DEFAULT 0;

DECLARE ip_pattern_cursor CURSOR FOR
     SELECT
         _ip_patterns.ip_from,
         _ip_patterns.ip_to
     FROM
         ip_patterns AS _ip_patterns
     WHERE
         _ip_patterns.banner_uid = banner_uid_in;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;



  -- if banner is not using any referrer pattern targeting just return true
   SELECT COUNT(*) INTO ip_patterns_count FROM ip_patterns WHERE banner_uid = banner_uid_in;
   IF ip_patterns_count=0 THEN RETURN TRUE; END IF;

  OPEN ip_pattern_cursor;
      FETCH ip_pattern_cursor INTO ip_from_value, ip_to_value;

  WHILE done = 0 DO

      IF(ip_from_value<=ip && ip <=ip_to_value) THEN
      SET response = TRUE;
      SET done = 1;
      END IF;

      FETCH ip_pattern_cursor INTO ip_from_value, ip_to_value;

  END WHILE;

    RETURN response;
END
;;
delimiter ;
