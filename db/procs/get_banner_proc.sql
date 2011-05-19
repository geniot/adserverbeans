DELIMITER ;;
DROP PROCEDURE if exists get_banner_proc;
CREATE PROCEDURE get_banner_proc(IN ad_place_uid_in VARCHAR(255),
                                 IN ad_place_id_in INTEGER,
                                 IN now_date_time TIMESTAMP,
                                 IN ip_in BIGINT,
                                 IN unique_uid_in VARCHAR(255), 
                                 IN time_stamp_long_in BIGINT,
                                 IN browser INTEGER,
                                 IN os_in INTEGER,
                                 IN language_in VARCHAR(255),
                                 IN banner_url VARCHAR(255),
                                 IN referrer_in VARCHAR(255),
                                 IN page_load_id VARCHAR(255),
                                 IN dynamic_parameters_in VARCHAR(255),

                                 OUT banner_id_out INTEGER,
                                 OUT banner_uid_out VARCHAR(255),
                                 OUT ad_format_id_out INTEGER,
                                 OUT banner_content_type_id_out INTEGER,
                                 OUT banner_frame_targeting_out BIT)

BEGIN
        DECLARE max_banner_priority INTEGER DEFAULT 1;
        DECLARE current_priority INTEGER DEFAULT 1;
        DECLARE current_banner INT DEFAULT 0;
        DECLARE daily_views_limit INTEGER;
        DECLARE max_number_views INTEGER;
        DECLARE start_date DATETIME;
        DECLARE end_date DATETIME;
        DECLARE ongoing BIT;
        DECLARE current_banner_id INTEGER;
        DECLARE current_ad_format_id INTEGER;
        DECLARE current_banner_content_type INTEGER;
        DECLARE views_served_today INTEGER;
        DECLARE views_served_all INTEGER;
        DECLARE banner_state INTEGER;
        DECLARE current_banner_priority INTEGER;
        DECLARE current_hour_bits VARCHAR(24);
        DECLARE current_day_bits VARCHAR(7);
        DECLARE current_country_bits VARCHAR(239);
        DECLARE check_banner_priority INTEGER DEFAULT 0;
        DECLARE done INT DEFAULT 0;
        DECLARE current_key VARCHAR(50);

        SELECT max(banner_priority) INTO max_banner_priority FROM banner AS _banner WHERE _banner.ad_place_uid = ad_place_uid_in;
        WHILE (done=0 and current_priority<=max_banner_priority)  DO

        SET banner_id_out=get_banner_by_priority(browser,
                                                   ad_place_uid_in,
                                                   ad_place_id_in,
                                                   now_date_time,
                                                   ip_in,
                                                   current_priority,
                                                   unique_uid_in,
                                                   time_stamp_long_in,
                                                   os_in,
                                                   language_in,
                                                   banner_url,
                                                   referrer_in,
                                                   page_load_id,
                                                   dynamic_parameters_in);
          IF (banner_id_out IS NOT NULL) THEN
              SET done=1;
          END IF;
          SET current_priority = current_priority+1;
        END WHILE;

        SELECT
          _banner.ad_format_id, _banner.banner_content_type_id, _banner.uid, _banner.frame_targeting
        INTO
          ad_format_id_out, banner_content_type_id_out, banner_uid_out, banner_frame_targeting_out
        FROM
          banner AS _banner
        WHERE
          _banner.id=banner_id_out;

   END
;;
delimiter ;