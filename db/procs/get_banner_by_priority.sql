DELIMITER ;;
DROP FUNCTION if exists get_banner_by_priority;
CREATE FUNCTION get_banner_by_priority(browser INTEGER,
                                       ad_place_uid_in VARCHAR(255),
                                       ad_place_id_in INTEGER,
                                       now_date_time TIMESTAMP,
                                       ip_in BIGINT,
                                       current_priority INTEGER,
                                       unique_uid_in VARCHAR(255),
                                       time_stamp_long_in BIGINT,
                                       os_in INTEGER,
                                       language_in VARCHAR(255),
                                       banner_url VARCHAR(255),
                                       referrer_in VARCHAR(255),
                                       page_load_id VARCHAR(255),
                                       dynamic_parameters_in VARCHAR(255))

RETURNS INTEGER
NOT DETERMINISTIC
BEGIN
        DECLARE current_uid VARCHAR(255);
        DECLARE current_parent_uid VARCHAR(255);
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
        DECLARE banner_traffic_share INTEGER;
        DECLARE current_hour_bits VARCHAR(24);
        DECLARE current_day_bits VARCHAR(7);
        DECLARE current_browser_bits VARCHAR(8);
        DECLARE current_country_bits VARCHAR(239);
        DECLARE current_os_bits VARCHAR(16);
        DECLARE current_language_bits VARCHAR(122);
        DECLARE one_on_page BIT;
        DECLARE check_banner_priority INTEGER DEFAULT 0;
        DECLARE done INT DEFAULT 0;
        DECLARE current_key VARCHAR(50);
        DECLARE result TEXT;
        DECLARE banner_id_result INTEGER DEFAULT NULL;
        DECLARE total_traffic_share INTEGER DEFAULT 0;
        DECLARE banners_cur CURSOR FOR
        SELECT
          _banner.id,
          _banner.uid,
          _banner.parent_uid,
          _banner.ad_format_id,
          _banner.banner_content_type_id,
          _banner.daily_views_limit,
          _banner.traffic_share,
          _banner.start_date,
          _banner.end_date,
          _banner.ongoing,
          _banner.max_number_views,
          _banner.day_bits,
          _banner.hour_bits,
          _banner.country_bits,
          _banner.browser_bits,
          _banner.os_bits,
          _banner.language_bits,
          _banner.one_on_page
        FROM
          banner AS _banner
          WHERE
          _banner.ad_place_uid = ad_place_uid_in AND _banner.banner_state=1 AND _banner.banner_priority=current_priority;

       DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
       OPEN banners_cur;
          FETCH banners_cur INTO current_banner_id,
                                 current_uid,
                                 current_parent_uid,
                                 current_ad_format_id,
                                 current_banner_content_type,
                                 daily_views_limit,
                                 banner_traffic_share,
                                 start_date,
                                 end_date,
                                 ongoing,
                                 max_number_views,
                                 current_day_bits,
                                 current_hour_bits,
                                 current_country_bits,
                                 current_browser_bits,
                                 current_os_bits,
                                 current_language_bits,
                                 one_on_page;


          WHILE done = 0 DO

            IF (is_valid_day_of_week(current_day_bits, now_date_time) AND
                is_valid_hour_of_day(current_hour_bits, now_date_time) AND
                is_valid_country(current_country_bits, ip_in) AND
                is_valid_browser(current_browser_bits, browser) AND
                is_valid_os(current_os_bits, os_in) AND
                is_valid_language(current_language_bits, language_in) AND
                is_valid_url_pattern(current_uid, banner_url) AND
                is_valid_referrer_pattern(current_uid, referrer_in) AND
                is_valid_dynamic_parameters(current_uid, dynamic_parameters_in) AND
                is_valid_ip(current_uid, ip_in)) THEN

              IF (start_date <= now_date_time AND (ongoing = TRUE OR end_date > DATE(now_date_time))) THEN
              SET views_served_all = NULL;
              SET current_key = CONCAT(CAST(3 AS CHAR), ':', CAST(current_banner_id AS CHAR),'x',CAST(ad_place_id_in AS CHAR), '(NULL/NULL/NULL/NULL)');
              SELECT _aggregate_reports.views INTO views_served_all FROM aggregate_reports AS _aggregate_reports WHERE entity_key = current_key;
                -- max number of views for the whole display period
              IF (get_speed(start_date, now_date_time, max_number_views, views_served_all, now_date_time, ongoing)< 0) THEN
                  SET views_served_today = NULL;
                  SET current_key = CONCAT(CAST(3 AS CHAR), ':', CAST(current_banner_id AS CHAR),'x',CAST(ad_place_id_in AS CHAR), '(', CAST(YEAR(DATE(now_date_time)) AS CHAR),'/', CAST(MONTH(DATE(now_date_time)) AS CHAR),'/',CAST(DAYOFMONTH(DATE(now_date_time)) AS CHAR),'/NULL)');
                  SELECT _aggregate_reports.views INTO views_served_today FROM aggregate_reports AS _aggregate_reports WHERE entity_key = current_key;
                  -- daily views limit
                  IF (get_speed(DATE(now_date_time), ADDDATE(DATE(now_date_time),INTERVAL 1 DAY), daily_views_limit, views_served_today, now_date_time, ongoing)< 0) THEN

                    IF (one_on_page = FALSE OR is_same_banner_page_load(unique_uid_in,current_parent_uid,page_load_id) = FALSE)THEN
                        -- finally, if all conditions have passed adding this banner to result string
                        IF (result IS NULL) THEN SET result=''; END IF;
                        SET result=CONCAT(result,current_banner_id,';',banner_traffic_share,';');
                        SET total_traffic_share=total_traffic_share+banner_traffic_share;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;

        FETCH banners_cur INTO   current_banner_id,
                                 current_uid,
                                 current_parent_uid,
                                 current_ad_format_id,
                                 current_banner_content_type,
                                 daily_views_limit,
                                 banner_traffic_share,
                                 start_date,
                                 end_date,
                                 ongoing,
                                 max_number_views,
                                 current_day_bits,
                                 current_hour_bits,
                                 current_country_bits,
                                 current_browser_bits,
                                 current_os_bits,
                                 current_language_bits,
                                 one_on_page;
        END WHILE;
        CLOSE banners_cur;
        if (result IS NOT NULL) THEN
            SET banner_id_result = get_random_banner_by_traffic_share(result,total_traffic_share);
          END IF;
        RETURN banner_id_result;
      END
      ;;
delimiter ;
