package com.adserversoft.flexfuse.server.dao;

import com.adserversoft.flexfuse.server.api.AdEvent;
import com.adserversoft.flexfuse.server.api.dao.IAdEventDAO;


public class AdEventDAO extends AbstractDAO implements IAdEventDAO {


    @Override
    public void create(AdEvent adEvent) {
        String bannerIdByUidSql = "(SELECT id FROM banner where uid=?)";
        String adPlaceIdByUidSql = "(SELECT id FROM ad_place where uid=?)";
        String sql = "INSERT INTO ad_events_log (banner_id, ad_place_id, event_id, time_stamp_id, unique_id, time_stamp_long) VALUES(" + bannerIdByUidSql + "," + adPlaceIdByUidSql + ",?,?,?,?)";
        this.getJdbcTemplate().update(sql,
                new Object[]{adEvent.getBannerUid(), adEvent.getAdPlaceUid(), adEvent.getEventId(), adEvent.getTimeStampId(), adEvent.getUniqueId(), adEvent.getTimeStampId().getTime()});
    }
}