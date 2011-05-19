package com.adserversoft.flexfuse.server.api.service;


import java.io.InputStream;
import java.util.Map;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public interface ITemplatesManagementService {
    public String[] getAdTag(String adServerUrl);

    String getAdCode(Map<String, Object> paramsMap, Integer bannerContentTypeId);

    public String getPreviewPage(Map<String, Object> paramsMap);
    
    public String getHtmlBanner(InputStream template, Map<String, Object> paramsMap);
}
