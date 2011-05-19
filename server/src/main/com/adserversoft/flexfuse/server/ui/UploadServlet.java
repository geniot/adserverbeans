package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.User;
import com.adserversoft.flexfuse.server.api.dao.IBannerDAO;
import com.adserversoft.flexfuse.server.api.ui.ISessionService;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.api.ui.UserSession;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.web.context.ContextLoaderListener;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class UploadServlet extends AbstractService {
    static Logger logger = Logger.getLogger(UploadServlet.class.getName());
    private ISessionService sessionService;
    private FileItemFactory factory = new DiskFileItemFactory();

    public void init() throws ServletException {

        try {
            sessionService = (ISessionService) ContextAwareSpringBean.APP_CONTEXT.getBean("sessionService");
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }

        super.init();
    }


    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setHeader("Cache-Control", "no-cache");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            Map<String, String> params;
            List<FileItem> items = null;
            byte[] bbs = new byte[]{};
            FileItem item = null;

            if (request.getContentType().equals("application/x-www-form-urlencoded")) {
                params = new HashMap<String, String>();
                Map<String, String[]> map = request.getParameterMap();
                for (Map.Entry<String, String[]> entry : map.entrySet()) {
                    params.put(entry.getKey(), entry.getValue()[0]);
                }
            } else {
                ServletFileUpload upload = new ServletFileUpload(factory);
                items = upload.parseRequest(request);
                params = getParams(items);
                if (items != null) {
                    item = getFileItem(items);
                    bbs = new byte[item.getInputStream().available()];
                    item.getInputStream().read(bbs);
                    item.getInputStream().close();
                    if (bbs.length == 0) {
                        throw new Exception("failed upload banner file");
                    }
                }
            }
            ServerRequest sr = new ServerRequest();
            sr.installationId = Integer.parseInt(params.get(ApplicationConstants.INST_ID_REQUEST_PARAMETER_NAME));
            InstallationContextHolder.setCustomerType(sr.installationId);
            sr.sessionId = params.get(ApplicationConstants.SESSIONID_REQUEST_PARAM_NAME);

            String action = params.get("action");

            if (action.equals("saveBannerToDB")) {
                try {
                    Banner b = new Banner();
                    String bannerUid = params.get(ApplicationConstants.BANNER_UID_REQUEST_PARAMETER_NAME);
                    b.setUid(bannerUid);
                    String bannerTargetUrl = params.get(ApplicationConstants.BANNER_TARGET_URL_REQUEST_PARAMETER_NAME);
                    b.setTargetUrl(bannerTargetUrl);
                    Integer bannerAdFormat = Integer.parseInt(params.get(ApplicationConstants.AD_FORMAT_ID_REQUEST_PARAMETER_NAME));
                    b.setAdFormatId(bannerAdFormat);
                    Integer bannerContenTypeId = Integer.parseInt(params.get(ApplicationConstants.BANNER_CONTENT_TYPE));
                    b.setBannerContentTypeId(bannerContenTypeId);
                    String bannerParentUid = null;
                    try {
                        bannerParentUid = params.get(ApplicationConstants.BANNER_PARENT_UID_REQUEST_PARAMETER_NAME);
                        b.setParentUid(bannerParentUid);
                    } catch (Exception ex) {
                    }
                    String adTag = params.get(ApplicationConstants.BANNER_AD_TAG_REQUEST_PARAMETER_NAME);
                    if (adTag != null) {
                        b.setAdTag(adTag);
                    }

                    if (items != null) {
                        b.setContent(bbs);
                    }
                    UserSession currentUserSession = sessionService.get(sr.sessionId);
                    Banner oldBanner = currentUserSession.uploadedBanners.get(bannerUid);
                    if (oldBanner != null) {
                        oldBanner.setTargetUrl(b.getTargetUrl());
                        oldBanner.setAdFormatId(b.getAdFormatId());
                        oldBanner.setBannerContentTypeId(b.getBannerContentTypeId());
                        if (b.getContent() != null) {
                            oldBanner.setContent(b.getContent());
                            oldBanner.setAdTag(null);
                        }
                        if (b.getParentUid() != null) {
                            oldBanner.setParentUid(b.getParentUid());
                        }

                        if (b.getAdTag() != null) {
                            oldBanner.setContent(null);
                            oldBanner.setAdTag(b.getAdTag());
                        }
                        b = oldBanner;
                    }

                    if (b.getContent() == null && b.getParentUid() == null && b.getAdTag() == null) {//right banner without content
                        /* if (b.getParentUid() != null && currentUserSession.uploadedBanners.get(b.getParentUid()) != null) {
                          Banner parentBanner = currentUserSession.uploadedBanners.get(b.getParentUid());
                          b.setContent(parentBanner.getContent());
                      } else {*/
                        IBannerDAO bannerDAO = (IBannerDAO) ContextLoaderListener.getCurrentWebApplicationContext().getBean("bannerDAO" + InstallationContextHolder.getCustomerType().intValue());
                        b.setContent(bannerDAO.getBannerByUid(b.getUid()).getContent());
                        //  }
                    }
                    currentUserSession.uploadedBanners.put(bannerUid, b);
                } catch (Exception e) {
                    e.printStackTrace();
                    logger.log(Level.SEVERE, e.getMessage());
                }
            } else if (action.equals("saveLogoToSession")) {
                String userId = params.get("userId");
                Integer id = Integer.parseInt(userId);
                try {
                    User dbuser = new User();
                    dbuser.setId(id);
                    if (bbs.length == 0) {
                        throw new Exception("failed upload logo");
                    }
                    UserSession currentUserSession = sessionService.get(sr.sessionId);
                    currentUserSession.logo = bbs;
                    currentUserSession.filename = item.getName();
                } catch (Exception e) {
                    logger.log(Level.SEVERE, e.getMessage());
                }

            }

        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage(), ex);
            response.getWriter().write(ex.getMessage());
            response.getWriter().flush();
            return;
        }

        response.getWriter().write(ApplicationConstants.SUCCESS);
        response.getWriter().flush();
    }

    private Map<String, String> generateParamsMap2(HttpServletRequest request) {
        Map<String, String> m = new HashMap<String, String>();
        for (Object o : request.getParameterMap().keySet()) {
            m.put(o.toString(), request.getParameter(o.toString()));
        }
        return m;
    }


    private FileItem getFileItem(List items) {

        Iterator it = items.iterator();
        while (it.hasNext()) {
            FileItem item = (FileItem) it.next();
            if (item.getFieldName().equals("Filedata")) {
                return item;
            }
        }
        return null;
    }

    private Map<String, String> getParams(List items) {
        Map<String, String> m = new HashMap<String, String>();
        Iterator it = items.iterator();
        while (it.hasNext()) {
            FileItem item = (FileItem) it.next();
            if (!item.getFieldName().equals("Filedata")) {
                m.put(item.getFieldName(), item.getString());
            }
        }
        return m;
    }


}


