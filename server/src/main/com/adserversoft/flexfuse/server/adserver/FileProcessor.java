package com.adserversoft.flexfuse.server.adserver;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.dao.NextBannerProcResult;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class FileProcessor extends AbstractProcessor {
    static Logger logger = Logger.getLogger(FileProcessor.class.getName());

    private AdServerModelBuilder adServerModelBuilder;

    @Override
    public void processRequest(RequestParametersForm form) {
        try {
            Banner banner = getBanner(form);
            InputStream is = new ByteArrayInputStream(banner.getAdTag() == null ? banner.getContent() : banner.getAdTag().getBytes());
            if (is == null) {
                logger.log(Level.SEVERE, "Banner file not found for:" + ((banner == null) ? "null banner" : banner.getId()));
            } else {
                if (banner.getBannerContentTypeId() == ApplicationConstants.HTML_BANNER_CONTENT_TYPE_ID ||
                        banner.getBannerContentTypeId() == ApplicationConstants.AD_TAG_BANNER_CONTENT_TYPE_ID) {
                    NextBannerProcResult res = new NextBannerProcResult();
                    res.setBannerUid(banner.getUid());
                    res.setAdFormatId(banner.getAdFormatId());
                    form.setNextBannerProcResult(res);
                    adServerModelBuilder.buildTemplateParams(form);
                    Map<String, Object> paramsMap = new HashMap<String, Object>();
                    paramsMap.put("clickTAG", form.getClickThroughUrl());
                    paramsMap.put("targetAS", "_blank");
                    String result = getTemplatesManagementService().getHtmlBanner(is, paramsMap);
                    writeResponse(result, (HttpServletResponse) form.getResponse());
                } else {
                    byte[] bbs = new byte[is.available()];
                    is.read(bbs);
                    is.close();

                    ((HttpServletResponse) (form.getResponse())).setContentLength(bbs.length);
                    ((HttpServletResponse) (form.getResponse())).getOutputStream().write(bbs);
                    ((HttpServletResponse) (form.getResponse())).getOutputStream().flush();
                    ((HttpServletResponse) (form.getResponse())).getOutputStream().close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.log(Level.SEVERE, e.getMessage());
            e.printStackTrace();
        }
    }

    public AdServerModelBuilder getAdServerModelBuilder() {
        return adServerModelBuilder;
    }

    public void setAdServerModelBuilder(AdServerModelBuilder adServerModelBuilder) {
        this.adServerModelBuilder = adServerModelBuilder;
    }

}