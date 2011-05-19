DELIMITER ;;
DROP FUNCTION if exists is_valid_language;
CREATE FUNCTION is_valid_language(language_bits VARCHAR(122), language_in VARCHAR(255))
RETURNS BOOL
DETERMINISTIC
BEGIN
  DECLARE language_id INT;
  DECLARE language_abbr_small_param VARCHAR(5);
  DECLARE start_index INTEGER;
  DECLARE end_index INTEGER;

  -- return true if all bits are true (all languages are selected)
  IF (INSTR(language_bits,'0') = 0)
      THEN RETURN TRUE;
  END IF;

  SET start_index = 1;
  SET end_index = LOCATE(';', language_in);

  WHILE end_index != 0 DO
    SET language_abbr_small_param = SUBSTRING(language_in, start_index, end_index - start_index);
    SET start_index = end_index + 1;
    SET end_index = LOCATE(';', language_in, start_index);
    SELECT id INTO language_id FROM t_language WHERE language_abbr_small = language_abbr_small_param;

    IF (language_id IS NOT NULL) THEN
      IF (SUBSTRING(language_bits, language_id, 1) = '1')
        THEN RETURN TRUE;
      END IF;
    END IF;
  END WHILE;

  RETURN FALSE;
END
;;
delimiter ;