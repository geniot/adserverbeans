DELIMITER ;;
DROP FUNCTION if exists is_valid_url_pattern;
CREATE FUNCTION is_valid_url_pattern(banner_uid_in VARCHAR(255), current_url_in VARCHAR(255))
RETURNS BOOL
DETERMINISTIC
NO SQL
BEGIN
  DECLARE current_url_pattern VARCHAR(255);
  DECLARE replace_url_pattern VARCHAR(255);
  DECLARE done INT DEFAULT 0;
  DECLARE result INT DEFAULT 0;
  DECLARE  response BOOL DEFAULT TRUE;
  DECLARE url_patterns_count INTEGER DEFAULT 0;

  DECLARE patterns_cur CURSOR FOR
        SELECT
          _url_patterns.url_pattern
        FROM
          url_patterns AS _url_patterns
          WHERE
          _url_patterns.banner_uid = banner_uid_in;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  -- if banner is not using any url pattern targeting just return true
   SELECT COUNT(*) INTO url_patterns_count FROM url_patterns WHERE banner_uid = banner_uid_in;
   IF url_patterns_count=0 THEN RETURN TRUE; END IF;

  OPEN patterns_cur;
      FETCH patterns_cur INTO current_url_pattern;
       WHILE done = 0 DO

        SET replace_url_pattern = REPLACE(current_url_pattern, '*', '%');
        SET replace_url_pattern = REPLACE(replace_url_pattern, '?', '_');

        SET result = current_url_in LIKE replace_url_pattern;
        IF (result != 0) THEN RETURN TRUE; ELSE SET response=FALSE; END IF;


      FETCH patterns_cur INTO   current_url_pattern;
       END WHILE;
  CLOSE patterns_cur;
 RETURN response;
END
;;
delimiter ;
