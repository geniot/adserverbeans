package com.adserversoft.flexfuse.server.api;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Banner extends BaseEntity {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    @Column(name = "uid")
    private String uid;
    @Column(name = "parent_uid")
    private String parentUid;
    @Column(name = "ad_place_uid")
    private String adPlaceUid;
    @Column(name = "target_url")
    private String targetUrl;
    @Column(name = "banner_name")
    private String bannerName;
    @Column(name = "ad_format_id")
    private Integer adFormatId;
    @Column(name = "banner_content")
    private byte[] content;
    @Column(name = "banner_content_type_id")
    private Integer bannerContentTypeId;
    @Column(name = "file_size")
    private Integer fileSize;
    @Column(name = "filename")
    private String filename;
    @Column(name = "banner_priority")
    private Integer priority = -1;
    @Column(name = "banner_state")
    private Integer bannerState = ApplicationConstants.STATE_ACTIVE;
    @Column(name = "daily_views_limit")
    private Integer dailyViewsLimit;
    @Column(name = "max_number_views")
    private Integer maxNumberViews;
    @Column(name = "ongoing")
    private Boolean ongoing = true;
    @Column(name = "start_date")
    private Date startDate;
    @Column(name = "end_date")
    private Date endDate;
    @Column(name = "one_on_page")
    private Boolean oneOnPage = true;
    @Column(name = "party_ad_tag")
    private Boolean partyAdTag = true;
    @Column(name = "ad_tag")
    private String adTag;
    @Column(name = "hour_bits")
    private String hourBits;
    @Column(name = "day_bits")
    private String dayBits;
    @Column(name = "browser_bits")
    private String browserBits;
    @Column(name = "country_bits")
    private String countryBits;
    @Column(name = "os_bits")
    private String osBits;
    @Column(name = "language_bits")
    private String languageBits;
    @Column(name = "traffic_share")
    private Integer trafficShare;
    @Column(name = "display_order")
    private Integer displayOrder;
    @Column(name = "label")
    private String label;
    @Column(name = "frame_targeting")
    private Boolean frameTargeting;

    private Integer views;
    private Integer clicks;

    public String getDayBits() {
        return dayBits;
    }

    public void setDayBits(String dayBits) {
        this.dayBits = dayBits;
    }

    public String getHourBits() {
        return hourBits;
    }

    public void setHourBits(String hourBits) {
        this.hourBits = hourBits;
    }

    public String getCountryBits() {
        return countryBits;
    }

    public void setCountryBits(String countryBits) {
        this.countryBits = countryBits;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public String getAdPlaceUid() {
        return adPlaceUid;
    }

    public void setAdPlaceUid(String adPlaceUid) {
        this.adPlaceUid = adPlaceUid;
    }

    public String getParentUid() {
        return parentUid;
    }

    public void setParentUid(String parentUid) {
        this.parentUid = parentUid;
    }

    public Integer getAdFormatId() {
        return adFormatId;
    }

    public void setAdFormatId(Integer adFormatId) {
        this.adFormatId = adFormatId;
    }

    public Integer getBannerState() {
        return bannerState;
    }

    public void setBannerState(Integer bannerState) {
        this.bannerState = bannerState;
    }

    public Integer getDailyViewsLimit() {
        return dailyViewsLimit == null ? null : (dailyViewsLimit <= 0 ? null : dailyViewsLimit);
    }

    public void setDailyViewsLimit(Integer dailyViewsLimit) {
        this.dailyViewsLimit = dailyViewsLimit;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTargetUrl() {
        return targetUrl;
    }

    public void setTargetUrl(String targetUrl) {
        this.targetUrl = targetUrl;
    }

    public String getBannerName() {
        return bannerName;
    }

    public void setBannerName(String bannerName) {
        this.bannerName = bannerName;
    }

    public byte[] getContent() {
        return content;
    }

    public void setContent(byte[] content) {
        this.content = content;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
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

    public Integer getFileSize() {
        return fileSize;
    }

    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }

    public Boolean getOngoing() {
        return ongoing;
    }

    public void setOngoing(Boolean ongoing) {
        this.ongoing = ongoing;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Boolean getOneOnPage() {
        return oneOnPage;
    }

    public void setOneOnPage(Boolean oneOnPage) {
        this.oneOnPage = oneOnPage;
    }


    public Boolean getPartyAdTag() {
        return partyAdTag;
    }

    public void setPartyAdTag(Boolean partyAdTag) {
        this.partyAdTag = partyAdTag;
    }

    public String getAdTag() {
        return adTag;
    }

    public void setAdTag(String adTag) {
        this.adTag = adTag;
    }

    public Integer getMaxNumberViews() {
        return maxNumberViews;
    }

    public void setMaxNumberViews(Integer maxNumberViews) {
        this.maxNumberViews = maxNumberViews;
    }

    public String getCtr() {
        return ((views == 0) ? 0 : Math.round(((clicks * 100 / views)) * 100) / 100) + "%";
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public Integer getBannerContentTypeId() {
        return bannerContentTypeId;
    }

    public void setBannerContentTypeId(Integer bannerContentTypeId) {
        this.bannerContentTypeId = bannerContentTypeId;
    }

    public Integer getTrafficShare() {
        return trafficShare;
    }

    public void setTrafficShare(Integer trafficShare) {
        this.trafficShare = trafficShare;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getBrowserBits() {
        return browserBits;
    }

    public void setBrowserBits(String browserBits) {
        this.browserBits = browserBits;
    }

    public String getOsBits() {
        return osBits;
    }

    public void setOsBits(String osBits) {
        this.osBits = osBits;
    }

    public String getLanguageBits() {
        return languageBits;
    }

    public void setLanguageBits(String languageBits) {
        this.languageBits = languageBits;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public Boolean getFrameTargeting() {
        return frameTargeting;
    }

    public void setFrameTargeting(Boolean frameTargeting) {
        this.frameTargeting = frameTargeting;
    }
}