DELIMITER ;;
DROP FUNCTION if exists is_valid_dynamic_parameters;
CREATE FUNCTION is_valid_dynamic_parameters(banner_uid_in VARCHAR(255), dynamic_parameters_in VARCHAR(255))
RETURNS BOOL
NOT DETERMINISTIC
NO SQL
BEGIN
   DECLARE pos INTEGER DEFAULT 1;
   DECLARE parameter_name VARCHAR(255);
   DECLARE parameter_value VARCHAR(255);
   DECLARE result BOOL;
   DECLARE params_count INTEGER DEFAULT 0;

   -- if banner is not using any dynamic parameter targeting just return true
   SELECT COUNT(*) INTO params_count FROM dynamic_parameters WHERE banner_uid = banner_uid_in;
   IF params_count=0 THEN RETURN TRUE; END IF;

   -- else iterate over incoming parameters and look up them in the dynamic_parameters table
   WHILE pos < LENGTH(dynamic_parameters_in) DO
     SET pos = POSITION('=' IN dynamic_parameters_in);
     SET parameter_name = SUBSTR(dynamic_parameters_in,1,pos-1);
     SET dynamic_parameters_in=SUBSTRING(dynamic_parameters_in FROM pos+1);
     SET pos = POSITION('&' IN dynamic_parameters_in);
     IF pos = 0 THEN SET pos = LENGTH(dynamic_parameters_in)+1;      END IF;
     SET parameter_value = SUBSTR(dynamic_parameters_in,1,pos-1);
     SET dynamic_parameters_in=SUBSTRING(dynamic_parameters_in FROM pos+1);
     SET result = is_valid_dynamic_parameter(banner_uid_in,parameter_name,parameter_value);
     IF result=FALSE THEN RETURN FALSE; END IF;
   END WHILE;

 RETURN result;
END
;;
delimiter ;
