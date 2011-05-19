package com.adserversoft.flexfuse.server.adserver;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import com.adserversoft.flexfuse.server.dao.NextBannerProcResult;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class AdCodeProcessor extends AbstractProcessor {
    static Logger logger = Logger.getLogger(AdCodeProcessor.class.getName());
    private AdServerModelBuilder adServerModelBuilder;

    public void processRequest(RequestParametersForm form, Date d) {
        try {

            if (form.getAdPlaceUid().equals(ApplicationConstants.AD_PLACE_PREVIEW_UID)) { //preview
                Banner banner = getBanner(form);
                NextBannerProcResult dbProcResult = new NextBannerProcResult();
                InstallationContextHolder.setCustomerType(form.getServerRequest().installationId);
                dbProcResult.setBannerUid(form.getBannerUid());
                dbProcResult.setAdFormatId(banner.getAdFormatId());
                dbProcResult.setBannerContentTypeId(banner.getBannerContentTypeId());
                dbProcResult.setFrameTargeting(banner.getFrameTargeting() == null ? true : banner.getFrameTargeting());
                form.setNextBannerProcResult(dbProcResult);
                adServerModelBuilder.buildTemplateParams(form);
                Map<String, Object> paramsMap = createParameters(form);
                String result = getTemplatesManagementService().getAdCode(paramsMap, dbProcResult.getBannerContentTypeId());
                writeResponse(result, (HttpServletResponse) form.getResponse());
                return;
            }

            //else
            getAdFromDB(form, d);

            //dropping unique id cookie if necessary
            if (form.getUniqueId() == null && form.getResponse() != null)//response may be null when running tests
            {
                Cookie uniqueCookie = new Cookie(ApplicationConstants.UNIQUE_ID_COOKIE_NAME, form.getNextBannerProcResult().getUniqueUid());
                uniqueCookie.setMaxAge(100000000);
                ((HttpServletResponse) form.getResponse()).addCookie(uniqueCookie);
            }
            //no banner
            if ((form.getBannerUid() == null || form.getBannerUid().equals(""))
                    && form.getNextBannerProcResult().getBannerUid() == null) {
                form.setEventType(ApplicationConstants.MISSED_BANNER_ADSERVER_EVENT_TYPE);
                registerMissedEvent(form);
                writeResponse("", (HttpServletResponse) form.getResponse());
                return;
            }

            // yes banner
            // get code for href and src for banner
            adServerModelBuilder.buildTemplateParams(form);
            Map<String, Object> paramsMap = createParameters(form);
            String result = getTemplatesManagementService().getAdCode(paramsMap, form.getNextBannerProcResult().getBannerContentTypeId());
            writeResponse(result, (HttpServletResponse) form.getResponse());

        } catch (Exception ex) {
            ex.printStackTrace();
            logger.log(Level.SEVERE, ex.getMessage(), ex);
            writeResponse("", (HttpServletResponse) form.getResponse());
        }
    }

    @Override
    public void processRequest(RequestParametersForm form) {
        processRequest(form, new Date());
    }

    private void getAdFromDB(RequestParametersForm form, Date nowDateTime) throws Exception {
        InstallationContextHolder.setCustomerType(form.getServerRequest().installationId);

        NextBannerProcResult dbProcResult = getBannerDAO().getNextBanner(
                form.getAdPlaceUid(),
                nowDateTime, form.getIp(),
                form.getUniqueId(),
                form.getCurrentBrowser(),
                form.getOs(),
                form.getLanguage(),
                form.getBannerUrl(),
                form.getReferrer(),
                form.getPageLoadUid(),
                form.getDynamicParameters());

        form.setNextBannerProcResult(dbProcResult);
    }

    private Map<String, Object> createParameters(RequestParametersForm form) {
        Map<String, Object> paramsMap = new HashMap<String, Object>();
        paramsMap.put("TARGETURL_REQUEST_PARAM_KEY", form.getClickThroughUrl());
        paramsMap.put("TARGET_WINDOW_REQUEST_PARAM_KEY", form.getNextBannerProcResult().getFrameTargeting() ? "_blank" : "_top");
        paramsMap.put("IMAGE_ID_REQUEST_PARAM_KEY", "");
        paramsMap.put("KEYVALUEPARAMS_REQUEST_PARAM_KEY", "");
        paramsMap.put("ADSOURCE_ID_REQUEST_PARAM_KEY", form.getAdSourceUrl());
        paramsMap.put("WIDTH_REQUEST_PARAM_KEY", ApplicationConstants.AD_FORMATS_MAP.get(form.getNextBannerProcResult().getAdFormatId()).getWidth());
        paramsMap.put("HEIGHT_REQUEST_PARAM_KEY", ApplicationConstants.AD_FORMATS_MAP.get(form.getNextBannerProcResult().getAdFormatId()).getHeight());
        paramsMap.put("ALTTEXT_REQUEST_PARAM_KEY", "");
        paramsMap.put("STATUSBARTEXT_REQUEST_PARAM_KEY", "");
        paramsMap.put("BANNER_UID", form.getNextBannerProcResult().getBannerUid());
        return paramsMap;
    }

    public AdServerModelBuilder getAdServerModelBuilder() {
        return adServerModelBuilder;
    }

    public void setAdServerModelBuilder(AdServerModelBuilder adServerModelBuilder) {
        this.adServerModelBuilder = adServerModelBuilder;
    }

}
