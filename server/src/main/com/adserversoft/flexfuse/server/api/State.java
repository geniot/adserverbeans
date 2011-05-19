package com.adserversoft.flexfuse.server.api;

import java.io.Serializable;
import java.util.List;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class State implements Serializable {

    private List<Banner> banners;
    private List<AdPlace> adPlaces;
    private List<UrlPattern> urlPatterns;
    private List<ReferrerPattern> referrerPatterns;
    private List<DynamicParameter> dynamicParameters;
    private List<IpPattern> ipPatterns;

    public List<UrlPattern> getUrlPatterns() {
        return urlPatterns;
    }

    public void setUrlPatterns(List<UrlPattern> urlPatterns) {
        this.urlPatterns = urlPatterns;
    }

    public List<ReferrerPattern> getReferrerPatterns() {
        return referrerPatterns;
    }

    public void setReferrerPatterns(List<ReferrerPattern> referrerPattern) {
        this.referrerPatterns = referrerPattern;
    }

    public List<DynamicParameter> getDynamicParameters() {
        return dynamicParameters;
    }

    public void setDynamicParameters(List<DynamicParameter> dynamicParameters) {
        this.dynamicParameters = dynamicParameters;
    }

    public List<AdPlace> getAdPlaces() {
        return adPlaces;
    }

    public void setAdPlaces(List<AdPlace> adPlaces) {
        this.adPlaces = adPlaces;
    }

    public List<Banner> getBanners() {
        return banners;
    }

    public void setBanners(List<Banner> banners) {
        this.banners = banners;
    }

    public List<IpPattern> getIpPatterns() {
        return ipPatterns;
    }

    public void setIpPatterns(List<IpPattern> ipPatterns) {
        this.ipPatterns = ipPatterns;
    }
}
