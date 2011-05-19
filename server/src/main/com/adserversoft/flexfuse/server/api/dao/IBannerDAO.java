package com.adserversoft.flexfuse.server.api.dao;

import com.adserversoft.flexfuse.server.api.*;
import com.adserversoft.flexfuse.server.dao.NextBannerProcResult;

import java.util.Date;
import java.util.List;

/**
 * Author: Vitaly Sazanovich
 * Vitaly.Sazanovich@gmail.com
 */
public interface IBannerDAO {

    public NextBannerProcResult getNextBanner(String adPlaceUid,
                                              Date nowTimestamp,
                                              Long ip,
                                              String uniqueId,
                                              int currentBrowser,
                                              int os,
                                              String language,
                                              String bannerUrl,
                                              String referrer,
                                              String pageLoadId,
                                              String dynamicParameters) throws Exception;

    public Banner getBannerByUid(String uid) throws Exception;

    public void removeBannersExcept(List<Banner> banners) throws Exception;

    public void saveOrUpdateBanners(List<Banner> banners) throws Exception;

    public void removeUrlPatternsExcept() throws Exception;

    public void removeReferrerPatternsExcept() throws Exception;

    public void removeDynamicParametersExcept() throws Exception;

    public void removeIpPatternsExcept() throws Exception;

    public void saveOrUpdateUrlPatterns(List<UrlPattern> urlPatterns) throws Exception;

    public void saveOrUpdateReferrerPatterns(List<ReferrerPattern> referrerPatterns) throws Exception;

    public void saveOrUpdateDynamicParameters(List<DynamicParameter> dynamicParameters) throws Exception;

    public void saveOrUpdateIpPatterns(List<IpPattern> ipPatterns) throws Exception;

    public List<Banner> getBanners() throws Exception;

    public List<TrashedObject> getTrashedBanners() throws Exception;

    public List<UrlPattern> getUrlPatterns() throws Exception;

    public List<ReferrerPattern> getReferrerPatterns() throws Exception;

    public List<DynamicParameter> getDynamicParameters() throws Exception;

    public List<IpPattern> getIpPatterns() throws Exception;

    public String getBannerUidById(String s) throws Exception;

    public List<String> getNotRemovedBannerUids() throws Exception;

    public List<String> getAssignedBannerUidsByAdPlaceUids() throws Exception;

}

