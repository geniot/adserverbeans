package com.adserversoft.flexfuse.server.adserver;

import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;

import javax.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class ClickProcessor extends AbstractProcessor {
    private String bannerNotFoundOnClickRedirectUrl;


    @Override
    public void processRequest(RequestParametersForm form) throws Exception {

        InstallationContextHolder.setCustomerType(form.getServerRequest().installationId);
        //IBannerDAO bannerDAO = (IBannerDAO) ContextLoaderListener.getCurrentWebApplicationContext().getBean("bannerDAO" + InstallationContextHolder.getCustomerType().intValue());
        Banner banner = getBanner(form);

        if (banner != null && banner.getTargetUrl() != null) {
            String targetUrl = checkTargetURl(banner.getTargetUrl());
            registerEvent(form, new Date());
            ((HttpServletResponse) (form.getResponse())).sendRedirect(targetUrl);
        } else {
            ((HttpServletResponse) (form.getResponse())).sendRedirect(bannerNotFoundOnClickRedirectUrl);
        }
    }

    private String checkTargetURl(String targetUrl) {
        if ((!targetUrl.startsWith("http://")) && (!targetUrl.startsWith("www"))) {
            return targetUrl = "http://www." + targetUrl;
        }
        return targetUrl;
    }


    public String getBannerNotFoundOnClickRedirectUrl() {
        return bannerNotFoundOnClickRedirectUrl;
    }

    public void setBannerNotFoundOnClickRedirectUrl(String bannerNotFoundOnClickRedirectUrl) {
        this.bannerNotFoundOnClickRedirectUrl = bannerNotFoundOnClickRedirectUrl;
    }
}
