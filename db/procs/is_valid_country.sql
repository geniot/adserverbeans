DELIMITER ;;
DROP FUNCTION if exists is_valid_country;
CREATE FUNCTION is_valid_country(country_bits VARCHAR(239), ip BIGINT)
RETURNS BOOL
DETERMINISTIC
BEGIN
  DECLARE country_id_for_ip INT;

  -- return true if all bits are true (all countries are selected including localhost, anonymous surfers, etc.)
  IF (INSTR(country_bits,'0') = 0)
      THEN RETURN TRUE;
  END IF;

  SELECT
    country_id
  INTO
    country_id_for_ip
  FROM
    ip_to_country
  WHERE
    ip >= ip_from AND ip <= ip_to;
    
  IF (country_id_for_ip IS NOT NULL) THEN
    IF (SUBSTRING(country_bits, country_id_for_ip, 1) = '1')
      THEN RETURN TRUE;
    END IF;
  END IF;
  RETURN FALSE;
END
;;
delimiter ;
