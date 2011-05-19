delimiter ;;
drop trigger if exists banner_trigger_update_before;
CREATE
TRIGGER banner_trigger_update_before
	BEFORE UPDATE
	ON banner
	FOR EACH ROW
begin
  -- getting banner content from parent if current is null
  IF (NEW.banner_content IS NULL AND OLD.banner_content IS NULL AND NEW.parent_uid IS NOT NULL) THEN
    SET NEW.banner_content = (SELECT banner_content FROM banner WHERE uid=new.parent_uid);
  END IF;
  -- prevent setting to null
  IF (NEW.banner_content IS NULL) THEN
    SET NEW.banner_content = (SELECT banner_content FROM banner WHERE uid=NEW.uid);
  END IF;
  -- NULL is meaningful, NULL means 'no limit'
  IF (NEW.daily_views_limit=0)THEN
    SET NEW.daily_views_limit=NULL;
  END IF;
  IF (NEW.max_number_views=0)THEN
    SET NEW.max_number_views=NULL;
  END IF;
end
;;
delimiter ;
