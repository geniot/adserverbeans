delimiter ;;
drop trigger if exists banner_trigger_insert_before;
CREATE
TRIGGER banner_trigger_insert_before
	BEFORE INSERT
	ON banner
	FOR EACH ROW
begin
  IF (NEW.banner_content IS NULL AND new.parent_uid IS NOT NULL) THEN
    SET NEW.banner_content = (SELECT banner_content FROM banner WHERE uid=new.parent_uid);
  END IF;
  # no way to set it to null
  IF (NEW.banner_content IS NULL) THEN
    SET NEW.banner_content = (SELECT banner_content FROM banner WHERE uid=NEW.uid);
  END IF;
  IF (NEW.daily_views_limit=0)THEN
    SET NEW.daily_views_limit=NULL;
  END IF;
  IF (NEW.max_number_views=0)THEN
    SET NEW.max_number_views=NULL;
  END IF;
end
;;
delimiter ;
