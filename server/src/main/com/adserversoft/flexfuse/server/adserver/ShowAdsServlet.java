package com.adserversoft.flexfuse.server.adserver;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.service.FreemarkerTextProcessor;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class ShowAdsServlet extends HttpServlet {
    static Logger logger = Logger.getLogger(ShowAdsServlet.class.getName());
    private FreemarkerTextProcessor freemarkerTextProcessor = new FreemarkerTextProcessor();

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        try {
            Map<String, Object> paramsMap = new HashMap<String, Object>();
            paramsMap.put("asb_place_uid", request.getParameter("asb_place_uid"));
            paramsMap.put("asb_inst_id", request.getParameter("asb_inst_id"));
            paramsMap.put("asb_count", request.getParameter("asb_count") == null ? "true" : request.getParameter("asb_count"));
            paramsMap.put("asb_width", request.getParameter("asb_width"));
            paramsMap.put("asb_height", request.getParameter("asb_height"));
            paramsMap.put("asb_custom_parameters", request.getParameter("asb_custom_parameters") == null ? "" : request.getParameter("asb_custom_parameters").replace("&", "%26"));
            paramsMap.put("asb_ad_format_id", request.getParameter("asb_ad_format_id") == null ? "" : request.getParameter("asb_ad_format_id"));
            paramsMap.put("asb_banner_content_type", request.getParameter("asb_banner_content_type") == null ? "" : request.getParameter("asb_banner_content_type"));
            paramsMap.put("asb_banner_uid", request.getParameter("asb_banner_uid") == null ? "" : request.getParameter("asb_banner_uid"));
            String url = request.getRequestURL().toString().split(request.getRequestURI())[0] + request.getContextPath() + "/sv";
            paramsMap.put("asb_url", url);

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PrintWriter printWriter = new PrintWriter(baos);
            freemarkerTextProcessor.processTemplate("templates/serving/show_ads.ftl", paramsMap, printWriter);
            String result = new String(baos.toByteArray());

            ApplicationConstants.bustCache(response);
            writeResponse(result, response);
        } catch (Exception e) {
            e.printStackTrace();
            logger.log(Level.SEVERE, e.getMessage());
        }
    }

    protected void writeResponse(String str, HttpServletResponse response) {
        try {
            PrintWriter pw = response.getWriter();
            pw.write(str);
            pw.flush();
            pw.close();
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }
    }
}
