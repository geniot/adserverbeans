package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.dao.*;
import com.adserversoft.flexfuse.server.api.service.IMailManagementService;
import com.adserversoft.flexfuse.server.api.service.ITemplatesManagementService;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;


public abstract class AbstractManagementService {
    protected IBannerDAO getBannerDAO() {
        return (IBannerDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("bannerDAO" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IAdPlaceDAO getAdPlaceDAO() {
        return (IAdPlaceDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("adPlaceDAO" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IUserDAO getUserDAO() {
        return (IUserDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("userDAO" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IReportDAO getReportDAO() {
        return (IReportDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("reportDAO" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IMailManagementService getMailManagementService() {
        return (IMailManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("mailManagementService" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected ITemplatesManagementService getTemplatesManagementService() {
        return (ITemplatesManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("templatesManagementService" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IGeoTargetingDAO getGeoTargetingDAO() {
        return (IGeoTargetingDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("geoTargetingDAO" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected ILanguageDAO getLanguageDAO() {
        return (ILanguageDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("languageDAO" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected IAdEventDAO getAdEventDAO() {
        return (IAdEventDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("adEventDAO" + InstallationContextHolder.getCustomerType().intValue());
    }

    protected ISettingsDAO getSettingsDAO() {
        return (ISettingsDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("settingsDAO" + InstallationContextHolder.getCustomerType().intValue());
    }
}
