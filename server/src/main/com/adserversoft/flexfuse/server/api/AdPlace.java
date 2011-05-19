package com.adserversoft.flexfuse.server.api;


import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class AdPlace extends BaseEntity {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    @Column(name = "uid")
    private String uid;
    @Column(name = "ad_place_name")
    private String adPlaceName;
    @Column(name = "ad_place_state")
    private Integer adPlaceState = ApplicationConstants.STATE_ACTIVE;
    @Column(name = "ad_format_id")
    private Integer adFormatId;
    @Column(name = "display_order")
    private Integer displayOrder;

    private Integer views;
    private Integer clicks;
    @Column(name = "label")
    private String label;

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

    public Integer getAdPlaceState() {
        return adPlaceState;
    }

    public void setAdPlaceState(Integer adPlaceState) {
        this.adPlaceState = adPlaceState;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAdPlaceName() {
        return adPlaceName;
    }

    public void setAdPlaceName(String adPlaceName) {
        this.adPlaceName = adPlaceName;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public Integer getAdFormatId() {
        return adFormatId;
    }

    public void setAdFormatId(Integer adFormatId) {
        this.adFormatId = adFormatId;
    }

    public String getCtr() {
        return ((views == 0) ? 0 : Math.round(((clicks * 100 / views)) * 100) / 100) + "%";
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }
}