package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.dao.ILanguageDAO;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class UpdateLanguageTable {
    ILanguageDAO languageDAO;

    public static void main(String[] args) {
        try {
            new UpdateLanguageTable();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public UpdateLanguageTable() throws Exception {
        ClassPathXmlApplicationContext appContext = new ClassPathXmlApplicationContext(new String[]{"context/applicationContext-ui.xml"});
        languageDAO= (ILanguageDAO)appContext.getBean("languageDAO1");
        languageDAO.updateCSV();
    }
}
