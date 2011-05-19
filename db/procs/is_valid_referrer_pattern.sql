DELIMITER ;;
DROP FUNCTION if exists is_valid_referrer_pattern;
CREATE FUNCTION is_valid_referrer_pattern(banner_uid_in VARCHAR(255), current_referrer_in VARCHAR(255))
RETURNS BOOL
DETERMINISTIC
NO SQL
BEGIN
  DECLARE current_referrent_pattern VARCHAR(255);
  DECLARE replace_referrer_pattern VARCHAR(255);
  DECLARE done INT DEFAULT 0;
  DECLARE result INT DEFAULT 0;
  DECLARE response BOOL DEFAULT TRUE;
  DECLARE referrer_patterns_count INTEGER DEFAULT 0;
  
  DECLARE patterns_cur CURSOR FOR
        SELECT
          _referrer_patterns.referrer_pattern
        FROM
          referrer_patterns AS _referrer_patterns
          WHERE
          _referrer_patterns.banner_uid = banner_uid_in;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  -- if banner is not using any referrer pattern targeting just return true
   SELECT COUNT(*) INTO referrer_patterns_count FROM referrer_patterns WHERE banner_uid = banner_uid_in;
   IF referrer_patterns_count=0 THEN RETURN TRUE; END IF;

  OPEN patterns_cur;
      FETCH patterns_cur INTO current_referrent_pattern;
       WHILE done = 0 DO

        SET replace_referrer_pattern = REPLACE(current_referrent_pattern, '*', '%');
        SET replace_referrer_pattern = REPLACE(replace_referrer_pattern, '?', '_');

        SET result = current_referrer_in LIKE replace_referrer_pattern;
        IF (result != 0) THEN RETURN TRUE; ELSE SET response=FALSE; END IF;


      FETCH patterns_cur INTO  current_referrent_pattern;
       END WHILE;
  CLOSE patterns_cur;
 RETURN response;
END
;;
delimiter ;
