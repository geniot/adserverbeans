DELIMITER ;;
DROP PROCEDURE if exists get_banner_proc_wrapper;

CREATE PROCEDURE get_banner_proc_wrapper(
  IN ad_place_uid VARCHAR(255),
  IN now_date_time TIMESTAMP,
  IN ip BIGINT,
  IN unique_uid_in VARCHAR(255),
  IN time_stamp_long_in BIGINT,
  IN browser INT,
  IN os_in INT,
  IN language_in VARCHAR(255),
  IN banner_url VARCHAR(255),
  IN referrer_in VARCHAR(255),
  IN page_load_id VARCHAR(255),
  IN dynamic_parameters_in VARCHAR(255),


  OUT banner_uid VARCHAR(255),
  OUT ad_format_id INTEGER,
  OUT banner_content_type_id INTEGER,
  OUT unique_uid_out VARCHAR(255),
  OUT banner_frame_targeting_out BIT
)

BEGIN


  DECLARE ad_place_state INTEGER;
  DECLARE ad_place_id INTEGER;
  DECLARE banner_id INTEGER;

  IF (unique_uid_in IS NOT NULL)THEN
    SET unique_uid_out = unique_uid_in;
  ELSE
    SET unique_uid_out = generate_new_unique_row(now_date_time);
  END IF;


  SELECT
    id, ad_place.ad_place_state
  INTO
    ad_place_id, ad_place_state
  FROM
    ad_place
  WHERE
    uid = ad_place_uid;

  IF (ad_place_state = 1) THEN
    CALL get_banner_proc(
      ad_place_uid,
      ad_place_id,
      now_date_time,
      ip,
      unique_uid_out,
      time_stamp_long_in * 1000,
      browser,
      os_in,
      language_in,
      banner_url,
      referrer_in,
      page_load_id,
      dynamic_parameters_in,
      banner_id,
      banner_uid,
      ad_format_id,
      banner_content_type_id,
      banner_frame_targeting_out);
    IF (banner_id IS NOT NULL) THEN
      INSERT INTO ad_events_log (banner_id, ad_place_id, event_id, time_stamp_id, unique_id, time_stamp_long,page_load_id)
          VALUES (banner_id, ad_place_id, 1, now_date_time, (select id from uniques where uid=unique_uid_out), time_stamp_long_in * 1000, page_load_id);
    END IF;
  END IF;
END
;;
delimiter ;