delimiter ;;
DROP FUNCTION if exists get_speed;
CREATE FUNCTION get_speed(from_date DATETIME,
                          to_date DATETIME,
                          views_limit INT,
                          views_served INT,
                          now_date_time TIMESTAMP,
                          is_ongoing BIT)
  RETURNS double
  DETERMINISTIC
  NO SQL
BEGIN
  DECLARE banner_total_serving_time INTEGER;
  DECLARE banner_served_time       INTEGER;
  DECLARE percent_time_served        DOUBLE;
  DECLARE percent_ad_events_served    DOUBLE;
  IF (views_limit IS NULL OR views_limit=0) THEN RETURN -1;END IF;

  IF (views_served IS NULL) THEN SET views_served = 0;END IF;
  IF (banner_total_serving_time = 0) THEN SET banner_total_serving_time = 1;END IF;
  IF (views_limit = 0) THEN SET views_limit = 1;END IF;

  IF (is_ongoing = TRUE AND views_served < views_limit) THEN RETURN -1; END IF;

  SET banner_total_serving_time = TIMESTAMPDIFF(SECOND, from_date, to_date);
  SET banner_served_time = TIMESTAMPDIFF(SECOND, from_date, now_date_time);
  SET percent_time_served = (100 * banner_served_time) / banner_total_serving_time;
  SET percent_ad_events_served = (100 * views_served) / views_limit;
  RETURN percent_ad_events_served - percent_time_served;
END
;;
delimiter ;
