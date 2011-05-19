package com.adserversoft.flexfuse.server.dao;

import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.dao.IAdEventDAO;
import com.adserversoft.flexfuse.server.api.dao.IAdPlaceDAO;
import com.adserversoft.flexfuse.server.api.dao.IBannerDAO;
import com.adserversoft.flexfuse.server.api.dao.IReportDAO;
import com.adserversoft.flexfuse.server.api.dao.IUserDAO;
import org.springframework.jdbc.core.support.JdbcDaoSupport;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public abstract class AbstractDAO extends JdbcDaoSupport {
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

    protected IAdEventDAO getAdEventDAO() {
        return (IAdEventDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("adEventDAO" + InstallationContextHolder.getCustomerType().intValue());
    }
}
