package com.adserversoft.flexfuse.server.api;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 * User: Lemeshevsky D.
 * Date: 28.12.2010
 * Time: 11:12:25
 */
public class ReferrerPattern extends BaseEntity{      

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    @Column(name = "referrer_pattern")
    private String referrerPattern;
    @Column(name = "banner_uid")
    private String bannerUid;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getReferrerPattern() {
        return referrerPattern;
    }

    public void setReferrerPattern(String referrerPattern) {
        this.referrerPattern = referrerPattern;
    }

    public String getBannerUid() {
        return bannerUid;
    }

    public void setBannerUid(String bannerUid) {
        this.bannerUid = bannerUid;
    }
}