package com.adserversoft.flexfuse.server.dao;

import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.Country;
import com.adserversoft.flexfuse.server.api.dao.IGeoTargetingDAO;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;

import java.util.List;


public class GeoTargetingDAOtest extends AbstractTransactionalDataSourceSpringContextTests {


    IGeoTargetingDAO geoTargetingDAO;


    protected String[] getConfigLocations() {
        setAutowireMode(AUTOWIRE_BY_NAME);
        setDependencyCheck(false);
        return new String[]{"context/applicationContext-ui.xml"};
    }

    protected void onSetUp() throws Exception {
        System.out.println("setup");
        geoTargetingDAO = (IGeoTargetingDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("geoTargetingDAO1");
        DataSourceTransactionManager tm = (DataSourceTransactionManager) ContextAwareSpringBean.APP_CONTEXT.getBean("transactionManager1");
        setTransactionManager(tm);
        super.onSetUp();
    }

    protected void onTearDown() throws Exception {
        super.onTearDown();
    }

    public void testGetCountry() {
        try {
            List<Country> country = geoTargetingDAO.getCountries();
            assertFalse(country.size()==0);
        } catch (Exception ex) {
            ex.printStackTrace();
            fail(ex.getMessage());
        }
    }
}
