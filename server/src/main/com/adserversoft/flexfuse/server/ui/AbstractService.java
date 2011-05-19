package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.service.*;
import com.adserversoft.flexfuse.server.api.ui.ISessionService;
import com.adserversoft.flexfuse.server.api.ui.ISettingsManagementService;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;

import javax.servlet.http.HttpServlet;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public abstract class AbstractService extends HttpServlet {
    protected IUserManagementService getUserManagementService() {
        return (IUserManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("userManagementService" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected ITemplatesManagementService getTemplatesManagementService() {
        return (ITemplatesManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("templatesManagementService" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IStateManagementService getStateManagementService() {
        return (IStateManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("stateManagementService" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IReportManagementService getReportManagementService() {
        return (IReportManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("reportManagementService" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IBannerManagementService getBannerManagementService() {
        return (IBannerManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("bannerManagementService" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected ISettingsManagementService getSettingsManagementService() {
        return (ISettingsManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("settingsManagementService" + InstallationContextHolder.getCustomerType().intValue());
    }
}
