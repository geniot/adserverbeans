DELIMITER ;;
DROP FUNCTION if exists is_valid_dynamic_parameter;
CREATE FUNCTION is_valid_dynamic_parameter(banner_uid_in VARCHAR(255), parameter_name_in VARCHAR(255), parameter_value_in VARCHAR(255))
RETURNS BOOL
NOT DETERMINISTIC
NO SQL
BEGIN

   DECLARE done INT DEFAULT 0;
   DECLARE banner_parameter_value VARCHAR(255);
   DECLARE replace_banner_parameter_value VARCHAR(255);
   DECLARE banner_parameter_is_regex BOOL;
   DECLARE result INT DEFAULT 0;
   DECLARE dynamic_parameter_cursor CURSOR FOR
        SELECT
          _dynamic_parameters.dynamic_value,
          _dynamic_parameters.regex
        FROM
          dynamic_parameters AS _dynamic_parameters
          WHERE
          _dynamic_parameters.banner_uid = banner_uid_in AND
          _dynamic_parameters.dynamic_parameter = parameter_name_in;
          DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

   OPEN dynamic_parameter_cursor;
    FETCH dynamic_parameter_cursor INTO   banner_parameter_value, banner_parameter_is_regex;
    IF done = 1 THEN RETURN TRUE; END IF;
    WHILE done = 0 DO

     SET replace_banner_parameter_value =  REPLACE(banner_parameter_value, '*', '%');
     SET replace_banner_parameter_value =  REPLACE(replace_banner_parameter_value, '?', '_');
     IF banner_parameter_is_regex THEN
     SET result = parameter_value_in REGEXP replace_banner_parameter_value;
     ELSE
     SET result = parameter_value_in LIKE replace_banner_parameter_value;
     END IF;
     IF (result != 0) THEN RETURN TRUE; END IF;

  FETCH dynamic_parameter_cursor INTO   banner_parameter_value, banner_parameter_is_regex;
  END WHILE;
  CLOSE dynamic_parameter_cursor;
 RETURN FALSE;
END
;;
delimiter ;
