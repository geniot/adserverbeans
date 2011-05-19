DELIMITER ;;
DROP PROCEDURE if exists on_insert_into_ad_events_log;
CREATE PROCEDURE on_insert_into_ad_events_log(IN banner_id INTEGER, IN ad_place_id INTEGER, IN event_id INTEGER, IN time_stamp_id DATETIME)
BEGIN
  DECLARE new_views            INTEGER;
  DECLARE new_clicks           INTEGER;
  DECLARE new_year             INTEGER;
  DECLARE new_month            INTEGER;
  DECLARE new_day              INTEGER;
  DECLARE new_hour             INTEGER;
  DECLARE entity_class_2_entity_id VARCHAR(255);
  DECLARE parent_banner_id     INTEGER;

  SET new_views = 0;
  SET new_clicks = 0;
  SET new_year = EXTRACT(YEAR FROM time_stamp_id);
  SET new_month = EXTRACT(MONTH FROM time_stamp_id);
  SET new_day = EXTRACT(DAY FROM time_stamp_id);
  SET new_hour = EXTRACT(HOUR FROM time_stamp_id);
  SET parent_banner_id = NULL;
  IF event_id = 1 THEN
    SET new_views = 1;
  END IF;
  IF event_id = 3 THEN
    SET new_clicks = 1;
  END IF;
  SELECT id INTO parent_banner_id FROM banner where uid=(SELECT parent_uid FROM banner WHERE id=banner_id);

  #0 - wholesystem
  SET entity_class_2_entity_id = CONCAT(CAST(0 AS CHAR), '(NULL/NULL/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, NULL, NULL, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(0 AS CHAR), '(', CAST(new_year AS CHAR), '/NULL/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, NULL, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(0 AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(0 AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(0 AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/', CAST(new_hour AS CHAR), ')');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, new_hour, new_views, new_clicks);
  
  #1 - banner
  SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(banner_id AS CHAR), '(NULL/NULL/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, NULL, NULL, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(banner_id AS CHAR), '(', CAST(new_year AS CHAR), '/NULL/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, NULL, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(banner_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(banner_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(banner_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/', CAST(new_hour AS CHAR), ')');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, new_hour, new_views, new_clicks);

  # parent banner
  IF (parent_banner_id is not NULL) THEN
    SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(parent_banner_id AS CHAR), '(NULL/NULL/NULL/NULL)');
    CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, NULL, NULL, NULL, NULL, new_views, new_clicks);
    SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(parent_banner_id AS CHAR), '(', CAST(new_year AS CHAR), '/NULL/NULL/NULL)');
    CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, NULL, NULL, NULL, new_views, new_clicks);
    SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(parent_banner_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/NULL/NULL)');
    CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, NULL, NULL, new_views, new_clicks);
    SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(parent_banner_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/NULL)');
    CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, NULL, new_views, new_clicks);
    SET entity_class_2_entity_id = CONCAT(CAST(1 AS CHAR), ':', CAST(parent_banner_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/', CAST(new_hour AS CHAR), ')');
    CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, new_hour, new_views, new_clicks);
  END IF;
  
  #2 - ad place
  SET entity_class_2_entity_id = CONCAT(CAST(2 AS CHAR), ':', CAST(ad_place_id AS CHAR), '(NULL/NULL/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, NULL, NULL, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(2 AS CHAR), ':', CAST(ad_place_id AS CHAR), '(', CAST(new_year AS CHAR), '/NULL/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, NULL, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(2 AS CHAR), ':', CAST(ad_place_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(2 AS CHAR), ':', CAST(ad_place_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(2 AS CHAR), ':', CAST(ad_place_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/', CAST(new_hour AS CHAR), ')');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, new_hour, new_views, new_clicks);
 
  #3 - banner x adplace
  SET entity_class_2_entity_id = CONCAT(CAST(3 AS CHAR), ':', CAST(banner_id AS CHAR), 'x', CAST(ad_place_id AS CHAR), '(NULL/NULL/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, NULL, NULL, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(3 AS CHAR), ':', CAST(banner_id AS CHAR), 'x', CAST(ad_place_id AS CHAR), '(', CAST(new_year AS CHAR), '/NULL/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, NULL, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(3 AS CHAR), ':', CAST(banner_id AS CHAR), 'x', CAST(ad_place_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/NULL/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, NULL, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(3 AS CHAR), ':', CAST(banner_id AS CHAR), 'x', CAST(ad_place_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/NULL)');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, NULL, new_views, new_clicks);
  SET entity_class_2_entity_id = CONCAT(CAST(3 AS CHAR), ':', CAST(banner_id AS CHAR), 'x', CAST(ad_place_id AS CHAR), '(', CAST(new_year AS CHAR), '/', CAST(new_month AS CHAR), '/', CAST(new_day AS CHAR), '/', CAST(new_hour AS CHAR), ')');
  CALL update_or_insert_aggregate_reports(entity_class_2_entity_id, new_year, new_month, new_day, new_hour, new_views, new_clicks);
 
END
;;
delimiter ;