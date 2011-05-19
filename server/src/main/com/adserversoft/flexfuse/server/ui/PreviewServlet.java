package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.AdFormat;
import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.dao.IBannerDAO;
import com.adserversoft.flexfuse.server.api.ui.ISessionService;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import flex.messaging.FlexContext;
import org.springframework.web.context.ContextLoaderListener;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class PreviewServlet extends AbstractService {
    private static Logger logger = Logger.getLogger(PreviewServlet.class.getName());
    private ISessionService sessionService;

    public void init() throws ServletException {

        try {
            sessionService = (ISessionService) ContextAwareSpringBean.APP_CONTEXT.getBean("sessionService");
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }

        super.init();
    }


    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        String previewHtml = "";
        try {
            int instId = Integer.parseInt(request.getParameter(ApplicationConstants.INSTID_REQUEST_PARAM_NAME));
            InstallationContextHolder.setCustomerType(instId);
            String adFormatId = request.getParameter(ApplicationConstants.AD_FORMAT_ID_REQUEST_PARAMETER_NAME);
            Integer bannerTypeId = Integer.parseInt(request.getParameter(ApplicationConstants.BANNER_CONTENT_TYPE));
            AdFormat adFormat = ApplicationConstants.AD_FORMATS_MAP.get(Integer.parseInt(adFormatId));
            String align = "right";
            if (adFormat.getWidth() > 399) {
                align = "top";
            }
            String bannerParentUid = null;
            String uid = request.getParameter(ApplicationConstants.BANNER_UID_REQUEST_PARAMETER_NAME);
            try {
                bannerParentUid = request.getParameter(ApplicationConstants.BANNER_PARENT_UID_REQUEST_PARAMETER_NAME);
            } catch (Exception ex) {
            }

            Banner banner = sessionService.getBannerFromSessions(uid);
            if (banner == null) {
                IBannerDAO bannerDAO = (IBannerDAO) ContextLoaderListener.getCurrentWebApplicationContext().getBean("bannerDAO" + InstallationContextHolder.getCustomerType().intValue());
                banner = bannerDAO.getBannerByUid(uid);

            }

            if (banner == null && bannerParentUid != null) {
                banner = sessionService.getBannerFromSessions(bannerParentUid);
            }

            if (banner == null && bannerParentUid != null) {
                IBannerDAO bannerDAO = (IBannerDAO) ContextLoaderListener.getCurrentWebApplicationContext().getBean("bannerDAO" + InstallationContextHolder.getCustomerType().intValue());
                banner = bannerDAO.getBannerByUid(bannerParentUid);
            }

            String url = request.getRequestURL().toString().split(
                    request.getRequestURI())[0] +
                    request.getContextPath() + "/show_ads.js";


            request.getRequestURI();
            Map<String, Object> paramsMap = new HashMap();
            paramsMap.put("FLOAT", align);
            paramsMap.put("AD_FORMAT_ID", adFormat.getId());
            paramsMap.put("AD_FORMAT_WIDTH", adFormat.getWidth());
            paramsMap.put("AD_FORMAT_HEIGHT", adFormat.getHeight());
            paramsMap.put("BANNER_UID", banner.getUid());
            paramsMap.put("WIDTH", adFormat.getWidth());
            paramsMap.put("HEIGHT", adFormat.getHeight());
            paramsMap.put("INST_ID", instId);
            paramsMap.put("BANNER_TYPE_ID", bannerTypeId);
            paramsMap.put("REQUESTURL_REQUEST_PARAM_KEY", url);

            previewHtml = getTemplatesManagementService().getPreviewPage(paramsMap);

        } catch (Exception ex) {
            ex.printStackTrace();
            logger.log(Level.SEVERE, ex.getMessage(), ex);
            response.getWriter().write("");
            response.getWriter().flush();
            return;
        }

        response.getWriter().write(previewHtml);
        response.getWriter().flush();
    }

}
