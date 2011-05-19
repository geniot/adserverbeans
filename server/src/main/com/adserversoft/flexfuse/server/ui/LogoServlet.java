package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.ui.ISessionService;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.api.ui.UserSession;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class LogoServlet extends AbstractService {
    static Logger logger = Logger.getLogger(LogoServlet.class.getName());
    private ISessionService sessionService;


    public void init() throws ServletException {
        try {
            sessionService = (ISessionService) ContextAwareSpringBean.APP_CONTEXT.getBean("sessionService");
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }
        super.init();
    }


    public void doGet(HttpServletRequest request, HttpServletResponse response) {

        try {
            response.setHeader("Cache-Control", "no-cache");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            ServerRequest sr = new ServerRequest();
            sr.installationId = Integer.parseInt(request.getParameter(ApplicationConstants.INST_ID_REQUEST_PARAMETER_NAME));
            InstallationContextHolder.setCustomerType(sr.installationId);

            String action = request.getParameter("action");

            if (action.equals("get_logo_from_DB")) {
                String idPar = request.getParameter("instId");
                Integer id = Integer.parseInt(idPar);
                sr.installationId = id;
                byte[] bbs = getUserManagementService().getLogo();
                if (bbs != null) {
                    response.getOutputStream().write(bbs);
                } else {
                    response.sendRedirect("images/logo.png");
                }
            }

            if (action.equals("get_logo_from_session")) {
                String idPar = request.getParameter("instId");
                Integer id = Integer.parseInt(idPar);
                sr.installationId = id;
                sr.sessionId = new String(request.getParameter(ApplicationConstants.SESSIONID_REQUEST_PARAM_NAME));
                UserSession currentUserSession = sessionService.get(sr.sessionId);
                byte[] bbs = currentUserSession.logo;
                if (bbs != null) {
                    response.getOutputStream().write(bbs);
                } else {
                    response.sendRedirect("images/logo.png");
                }
            }
            response.getOutputStream().flush();
            response.getOutputStream().close();

        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage());
        }
    }
}


