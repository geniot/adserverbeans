package com.adserversoft.flexfuse.server.api;

import java.util.Date;
import java.util.List;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class ReportCriteria {
    private Integer type;
    private Date fromDate;
    private Date toDate;
    private Integer precision;
    private List<String> bannerUids;
    private List<String> adPlaceUids;
    private List<String> bannerUidByAdPlaceUids;

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public Integer getPrecision() {
        return precision;
    }

    public void setPrecision(Integer precision) {
        this.precision = precision;
    }

    public List<String> getBannerUids() {
        return bannerUids;
    }

    public void setBannerUids(List<String> bannerUids) {
        this.bannerUids = bannerUids;
    }

    public List<String> getAdPlaceUids() {
        return adPlaceUids;
    }

    public void setAdPlaceUids(List<String> adPlaceUids) {
        this.adPlaceUids = adPlaceUids;
    }

    public List<String> getBannerUidByAdPlaceUids() {
        return bannerUidByAdPlaceUids;
    }

    public void setBannerUidByAdPlaceUids(List<String> bannerUidByAdPlaceUids) {
        this.bannerUidByAdPlaceUids = bannerUidByAdPlaceUids;
    }
}
