DELIMITER ;;
DROP FUNCTION if exists is_same_banner_page_load;
-- returns true if the unique visitor with this uid has seen the banner with this uid during the last 3 seconds
CREATE FUNCTION is_same_banner_page_load(unique_uid_in VARCHAR(255),
                              banner_parent_uid VARCHAR(255),
                              page_load_id_in VARCHAR(255))
RETURNS BOOL
NOT DETERMINISTIC
BEGIN
  DECLARE views_found INT;


  SET views_found = 0;
  
  SELECT COUNT(*) INTO views_found FROM ad_events_log LEFT OUTER JOIN banner on banner.id=ad_events_log.banner_id
      WHERE banner_parent_uid = banner.parent_uid AND
            event_id=1 AND
            page_load_id=page_load_id_in;
  
  RETURN views_found>0;
END
;;
delimiter ;
