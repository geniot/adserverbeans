package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.dao.IGeoTargetingDAO;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.logging.Logger;



public class UpdateCountriesTable {
    static Logger logger = Logger.getLogger(UpdateCountriesTable.class.getName());
    IGeoTargetingDAO geoTargetingDAO;

    public static void main(String[] args) {
        try {
            new UpdateCountriesTable();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public UpdateCountriesTable() throws Exception {
        ClassPathXmlApplicationContext appContext = new ClassPathXmlApplicationContext(new String[]{"context/applicationContext-ui.xml"});
        geoTargetingDAO= (IGeoTargetingDAO)appContext.getBean("geoTargetingDAO1");
        geoTargetingDAO.updateCSV();
    }
}
