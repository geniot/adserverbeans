DELIMITER ;;
DROP FUNCTION if exists get_id_by_uid;
CREATE FUNCTION get_id_by_uid(table_name_in VARCHAR(8), uid_in VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
NO SQL
BEGIN
  RETURN CONCAT('(select id from ', table_name_in, ' where uid=\'', uid_in, '\')');
END
;;
delimiter ;
