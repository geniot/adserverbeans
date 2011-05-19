DELIMITER ;;
DROP FUNCTION if exists get_random_banner_by_traffic_share;
CREATE FUNCTION get_random_banner_by_traffic_share(valid_banners TEXT, total_traffic_share INTEGER)
RETURNS INTEGER
NOT DETERMINISTIC
BEGIN
       DECLARE pos INTEGER DEFAULT 1;
       DECLARE rnd INTEGER DEFAULT 0;
       DECLARE current_traffic_share INTEGER DEFAULT 0;
       DECLARE banner_id INTEGER;
       DECLARE banner_traffic_share INTEGER;
       SET rnd = RAND()*(total_traffic_share-1)+1;
       WHILE pos < LENGTH(valid_banners) DO       
         SET pos = POSITION(';' IN valid_banners);
         SET banner_id = CONVERT(SUBSTR(valid_banners,1,pos-1),SIGNED);
         SET valid_banners=SUBSTRING(valid_banners FROM pos+1);
         SET pos = POSITION(';' IN valid_banners);
         SET banner_traffic_share = CONVERT(SUBSTR(valid_banners,1,pos-1),SIGNED);
         SET valid_banners=SUBSTRING(valid_banners FROM pos+1);
         if(current_traffic_share < rnd and rnd <= (banner_traffic_share+current_traffic_share)) THEN
            RETURN banner_id;
         END IF;
         SET current_traffic_share=current_traffic_share+banner_traffic_share;
       END WHILE;
END;
;;
delimiter ;
