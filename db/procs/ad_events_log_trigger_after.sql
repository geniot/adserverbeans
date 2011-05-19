delimiter ;;
drop trigger if exists ad_events_log_trigger_after;
CREATE
TRIGGER ad_events_log_trigger_after
	AFTER INSERT
	ON ad_events_log
	FOR EACH ROW
begin
CALL on_insert_into_ad_events_log(
new.banner_id,
new.ad_place_id,
new.event_id,
new.time_stamp_id);
end
;;
delimiter ;
