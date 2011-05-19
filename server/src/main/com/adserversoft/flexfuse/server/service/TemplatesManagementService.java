package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.service.ITemplatesManagementService;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class TemplatesManagementService extends AbstractManagementService implements ITemplatesManagementService {
    static Logger logger = Logger.getLogger(TemplatesManagementService.class.getName());
    private FreemarkerTextProcessor freemarkerTextProcessor = new FreemarkerTextProcessor();
//    private Map<String, String> pathsToTemplates;
    private Properties appProperties;
    private String splitter = "#splitter#";

    public TemplatesManagementService() {
        try {
            appProperties = new Properties();
            InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
            appProperties.load(is);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage(), ex);
        }
    }

    public String getAdCode(Map<String, Object> paramsMap, Integer bannerContentTypeId) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintWriter printWriter = new PrintWriter(baos);
        String templateName;
        switch (bannerContentTypeId) {
            case ApplicationConstants.FLASH_BANNER_CONTENT_TYPE_ID:
                templateName = "template.path.adcode-flash-js";
                break;
            case ApplicationConstants.HTML_BANNER_CONTENT_TYPE_ID:
                templateName = "template.path.adcode-html-js";
                break;
            case ApplicationConstants.AD_TAG_BANNER_CONTENT_TYPE_ID:
                templateName = "template.path.adcode-adtag-js";
                break;
            case ApplicationConstants.IMAGE_BANNER_CONTENT_TYPE_ID:
            default:
                templateName = "template.path.adcode-image-js";
        }
        freemarkerTextProcessor.processTemplate(appProperties.getProperty(templateName), paramsMap, printWriter);
        return new String(baos.toByteArray());
    }


    public String getPreviewPage(Map<String, Object> paramsMap) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintWriter printWriter = new PrintWriter(baos);
        freemarkerTextProcessor.processTemplate("templates/serving/previewTemplate.ftl", paramsMap, printWriter);
        String previewStr = new String(baos.toByteArray());
        return previewStr;
    }


    public String[] getAdTag(String adServerUrl) {
        Map<String, Object> paramsMap = new HashMap();
        paramsMap.put("REQUESTURL_REQUEST_PARAM_KEY", adServerUrl);
        StringBuffer keyValueParams = new StringBuffer();
        keyValueParams.append(ApplicationConstants.EVENT_ID_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(ApplicationConstants.GET_AD_CODE_SERVER_EVENT_TYPE)
                .append("&")
                .append(ApplicationConstants.PLACE_UID_REQUEST_PARAM_NAME)
                .append("='+")
                .append(ApplicationConstants.PLACE_UID_REQUEST_PARAM_NAME)
                .append("+'")
                .append("&")
                .append(ApplicationConstants.INSTID_REQUEST_PARAM_NAME)
                .append("='+")
                .append(ApplicationConstants.INSTID_REQUEST_PARAM_NAME)
                .append("+'");
        paramsMap.put("KEYVALUEPARAMS_REQUEST_PARAM_KEY", keyValueParams);
        paramsMap.put("SPLITTER", splitter);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintWriter printWriter = new PrintWriter(baos);
        freemarkerTextProcessor.processTemplate(appProperties.getProperty("template.path.adtag"), paramsMap, printWriter);
        String adTagStr = new String(baos.toByteArray());
        String[] parts = adTagStr.split(splitter);
        return parts;
    }

    public String getHtmlBanner(InputStream template, Map<String, Object> paramsMap) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintWriter printWriter = new PrintWriter(baos);
        freemarkerTextProcessor.processTemplateByContent(template, paramsMap, printWriter);
        return new String(baos.toByteArray());
    }
}