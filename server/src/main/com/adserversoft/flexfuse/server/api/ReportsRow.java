package com.adserversoft.flexfuse.server.api;

import java.io.Serializable;
import java.util.Date;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class ReportsRow implements Serializable {
    private String adPlaceUid;
    private String bannerUid;
    private Integer views;
    private Integer clicks;
    private Date date;

    public String getAdPlaceUid() {
        return adPlaceUid;
    }

    public void setAdPlaceUid(String adPlaceUid) {
        this.adPlaceUid = adPlaceUid;
    }

    public String getBannerUid() {
        return bannerUid;
    }

    public void setBannerUid(String bannerUid) {
        this.bannerUid = bannerUid;
    }

    public Integer getViews() {
        return views;
    }

    public void setViews(Integer views) {
        this.views = views;
    }

    public Integer getClicks() {
        return clicks;
    }

    public void setClicks(Integer clicks) {
        this.clicks = clicks;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}