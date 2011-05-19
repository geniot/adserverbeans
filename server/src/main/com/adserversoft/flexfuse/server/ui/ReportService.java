package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ReportCriteria;
import com.adserversoft.flexfuse.server.api.ReportsRow;
import com.adserversoft.flexfuse.server.api.ui.IReportService;
import com.adserversoft.flexfuse.server.api.ui.ISessionService;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.api.ui.ServerResponse;
import com.adserversoft.flexfuse.server.api.ui.UserSession;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReportService extends AbstractService implements IReportService {
    static Logger logger = Logger.getLogger(ReportService.class.getName());
    private ReloadableResourceBundleMessageSource messageSource;
    private ISessionService sessionService;

    @Override
    public ServerResponse loadReport(ServerRequest serverRequest, ReportCriteria reportRequest) {
        return load(serverRequest, reportRequest);
    }

    @Override
    public ServerResponse loadCustomReport(ServerRequest serverRequest, ReportCriteria reportRequest) {
        return load(serverRequest, reportRequest);
    }

    private ServerResponse load(ServerRequest serverRequest, ReportCriteria reportRequest) {
        ServerResponse serverResponse = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            List<ReportsRow> report = getReportManagementService().loadReport(reportRequest);
            serverResponse.result = ApplicationConstants.SUCCESS;
            serverResponse.resultingObject = report;
            return serverResponse;
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            serverResponse.result = ApplicationConstants.FAILURE;
            serverResponse.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return serverResponse;
        }
    }

    @Override
    public ServerResponse setCustomObjectToSession(ServerRequest serverRequest, Object objectForSession) {
        ServerResponse serverResponse = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            UserSession currentUserSession = sessionService.get(serverRequest.sessionId);
            currentUserSession.customSessionObject = objectForSession;
            serverResponse.result = ApplicationConstants.SUCCESS;
            return serverResponse;
        } catch (Exception ex) {
            logger.log(Level.FINE, ex.getMessage());
            serverResponse.result = ApplicationConstants.FAILURE;
            serverResponse.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return serverResponse;
        }
    }

    public ReloadableResourceBundleMessageSource getMessageSource() {
        return messageSource;
    }

    public void setMessageSource(ReloadableResourceBundleMessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public ISessionService getSessionService() {
        return sessionService;
    }

    public void setSessionService(ISessionService sessionService) {
        this.sessionService = sessionService;
    }
}