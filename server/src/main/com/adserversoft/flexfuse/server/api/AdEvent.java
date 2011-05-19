package com.adserversoft.flexfuse.server.api;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.Date;

/**
 * Author: Vitaly Sazanovich
 * Vitaly.Sazanovich@gmail.com
 */
public class AdEvent extends BaseEntity {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
//    @Column(name = "banner_id")
//    private Integer bannerId;
//    @Column(name = "ad_place_id")
//    private Integer adPlaceId;
    @Column(name = "event_id")
    private Integer eventId;
    @Column(name = "time_stamp_id")
    private Date timeStampId;

    private Integer instId;
    private String bannerUid;
    private String adPlaceUid;
    @Column(name = "unique_id")
    private String uniqueId;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBannerUid() {
        return bannerUid;
    }

    public void setBannerUid(String bannerUid) {
        this.bannerUid = bannerUid;
    }

    public String getAdPlaceUid() {
        return adPlaceUid;
    }

    public void setAdPlaceUid(String adPlaceUid) {
        this.adPlaceUid = adPlaceUid;
    }

    public Integer getInstId() {
        return instId;
    }

    public void setInstId(Integer instId) {
        this.instId = instId;
    }

//    public Integer getBannerId() {
//        return bannerId;
//    }
//
//    public void setBannerId(Integer bannerId) {
//        this.bannerId = bannerId;
//    }
//
//    public Integer getAdPlaceId() {
//        return adPlaceId;
//    }
//
//    public void setAdPlaceId(Integer adPlaceId) {
//        this.adPlaceId = adPlaceId;
//    }

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public Date getTimeStampId() {
        return timeStampId;
    }

    public void setTimeStampId(Date timeStampId) {
        this.timeStampId = timeStampId;
    }

    public String getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(String uniqueId) {
        this.uniqueId = uniqueId;
    }
}
