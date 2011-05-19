DELIMITER ;;
DROP FUNCTION if exists is_valid_os;
CREATE FUNCTION is_valid_os(os_bits VARCHAR(16), os_in INTEGER)
RETURNS BOOL
DETERMINISTIC
NO SQL
BEGIN
  IF (SUBSTRING(os_bits,os_in,1)='1') THEN RETURN TRUE;END IF;
  RETURN FALSE;
END
;;
delimiter ;
