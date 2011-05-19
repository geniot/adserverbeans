package com.adserversoft.flexfuse.server.adserver;


import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.dao.NextBannerProcResult;

import java.io.Serializable;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class RequestParametersForm implements Serializable {
    private String adPlaceUid;
    private String bannerUid;
    private String adServerUrl;
    private int eventType;
    private boolean count = true;
    private ServerRequest serverRequest;
    private String clickThroughUrl;
    private NextBannerProcResult nextBannerProcResult;
    private String adSourceUrl;
    private Long ip;
    private String uniqueId;
    private int currentBrowser;
    private int os;
    private String language;
    private String bannerUrl;
    private String referrer;
    private String pageLoadUid;
    private String dynamicParameters;
    private Object response;

    public String getPageLoadUid() {
        return pageLoadUid;
    }

    public void setPageLoadUid(String pageLoadUid) {
        this.pageLoadUid = pageLoadUid;
    }

    public String getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(String uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getAdSourceUrl() {
        return adSourceUrl;
    }

    public void setAdSourceUrl(String adSourceUrl) {
        this.adSourceUrl = adSourceUrl;
    }

    public String getReferrer() {
        return referrer;
    }

    public void setReferrer(String referrer) {
        this.referrer = referrer;
    }

    public String getClickThroughUrl() {
        return clickThroughUrl;
    }

    public void setClickThroughUrl(String clickThroughUrl) {
        this.clickThroughUrl = clickThroughUrl;
    }

    public Object getResponse() {
        return response;
    }

    public void setResponse(Object response) {
        this.response = response;
    }

    public ServerRequest getServerRequest() {
        return serverRequest;
    }

    public void setServerRequest(ServerRequest serverRequest) {
        this.serverRequest = serverRequest;
    }

    public boolean getCount() {
        return count;
    }

    public void setCount(boolean count) {
        this.count = count;
    }

    public NextBannerProcResult getNextBannerProcResult() {
        return nextBannerProcResult;
    }

    public void setNextBannerProcResult(NextBannerProcResult nextBannerProcResult) {
        this.nextBannerProcResult = nextBannerProcResult;
    }

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

    public int getEventType() {
        return eventType;
    }

    public void setEventType(int eventType) {
        this.eventType = eventType;
    }

    public String getAdServerUrl() {
        return adServerUrl;
    }

    public void setAdServerUrl(String adServerUrl) {
        this.adServerUrl = adServerUrl;
    }

    public Long getIp() {
        return ip;
    }

    public void setIp(Long ip) {
        this.ip = ip;
    }

    public int getCurrentBrowser() {
        return currentBrowser;
    }

    public void setCurrentBrowser(int currentBrowser) {
        this.currentBrowser = currentBrowser;
    }

    public int getOs() {
        return os;
    }

    public void setOs(int os) {
        this.os = os;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getBannerUrl() {
        return bannerUrl;
    }

    public void setBannerUrl(String bannerUrl) {
        this.bannerUrl = bannerUrl;
    }

    public String getDynamicParameters() {
        return dynamicParameters;
    }

    public void setDynamicParameters(String dynamicParameters) {
        this.dynamicParameters = dynamicParameters;
    }
}