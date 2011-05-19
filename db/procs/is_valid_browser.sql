DELIMITER ;;
DROP FUNCTION if exists is_valid_browser;
CREATE FUNCTION is_valid_browser(browser_bits VARCHAR(8), browser INTEGER)
RETURNS BOOL
DETERMINISTIC
NO SQL
BEGIN
  IF (SUBSTRING(browser_bits,browser,1)='1') THEN RETURN TRUE;END IF;  

  RETURN FALSE;
END
;;
delimiter ;
