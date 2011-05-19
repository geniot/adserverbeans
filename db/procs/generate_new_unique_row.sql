DELIMITER ;;
DROP FUNCTION if exists generate_new_unique_row;
CREATE FUNCTION generate_new_unique_row(now_date_time TIMESTAMP)
RETURNS VARCHAR(255)
NOT DETERMINISTIC
BEGIN
  DECLARE unique_uid VARCHAR(239);
  DECLARE done INT DEFAULT 0;
  DECLARE uniques_found INT;

  SET uniques_found = 0;
  -- looking for a new unique uid
  WHILE (done=0) DO
    SET unique_uid = CONCAT(CAST(now_date_time as CHAR),(SELECT CAST(rand()*1000000000000000 AS CHAR)));
    SELECT COUNT(*) INTO uniques_found FROM uniques WHERE uid = unique_uid;
    IF (uniques_found=0)THEN
      SET done=1;
    END IF;
  END WHILE;

  INSERT INTO uniques (uid) VALUES (unique_uid);

  RETURN unique_uid;
END
;;
delimiter ;
