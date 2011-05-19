package com.adserversoft.flexfuse.server.service;


import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.dao.IBannerDAO;
import com.adserversoft.flexfuse.server.api.service.IBannerManagementService;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;

import java.util.Date;

public class BannerManagementServiceTest extends AbstractTransactionalDataSourceSpringContextTests {

    IBannerManagementService bannerManagementService;
    IBannerDAO bannerDAO;

    protected String[] getConfigLocations() {
        setAutowireMode(AUTOWIRE_BY_NAME);
        setDependencyCheck(false);
        return new String[]{"context/applicationContext-ui.xml"};
    }

    protected void onSetUp() throws Exception {
        System.out.println("setup");
        bannerManagementService = (IBannerManagementService) getApplicationContext().getBean("bannerManagementServiceTarget1");
        bannerDAO = (IBannerDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("bannerDAO1");
        DataSourceTransactionManager tm = (DataSourceTransactionManager) ContextAwareSpringBean.APP_CONTEXT.getBean("transactionManager1");
        setTransactionManager(tm);
        super.onSetUp();
    }

    protected void onTearDown() throws Exception {
        super.onTearDown();
    }

    public void testCreate() {
        try {
            Banner saveBanner = new Banner();
            saveBanner.setBannerName("testBanner");
            saveBanner.setTargetUrl("www.www");
            saveBanner.setBannerState(ApplicationConstants.STATE_ACTIVE);
            saveBanner.setUid(Double.toString(new Date().getTime() + (Math.random())));
            saveBanner.setAdFormatId(10);
            saveBanner.setBannerContentTypeId(1);
            saveBanner.setDailyViewsLimit(10);
            saveBanner.setDayBits("0001000");
            saveBanner.setEndDate(new Date(2010, 12, 11));
            saveBanner.setFilename("file.jpg");
            saveBanner.setFileSize(10000);
            saveBanner.setHourBits("000001111100000111110000");
            saveBanner.setMaxNumberViews(100);
            saveBanner.setOngoing(true);
            saveBanner.setStartDate(new Date(2010, 12, 8));
            InstallationContextHolder.setCustomerType(1);
            bannerManagementService.update(saveBanner);
            Banner loadBanner = bannerDAO.getBannerByUid(saveBanner.getUid());
            assertEquals(saveBanner.getAdFormatId(), loadBanner.getAdFormatId());
            assertEquals(saveBanner.getBannerName(), loadBanner.getBannerName());
            assertEquals(saveBanner.getBannerContentTypeId(), loadBanner.getBannerContentTypeId());
            assertEquals(saveBanner.getBannerState(), loadBanner.getBannerState());
            assertEquals(saveBanner.getDailyViewsLimit(), loadBanner.getDailyViewsLimit());
            assertEquals(saveBanner.getDayBits(), loadBanner.getDayBits());
            assertEquals(saveBanner.getEndDate(), loadBanner.getEndDate());
            assertEquals(saveBanner.getFilename(), loadBanner.getFilename());
            assertEquals(saveBanner.getFileSize(), loadBanner.getFileSize());
            assertEquals(saveBanner.getStartDate(), loadBanner.getStartDate());
            assertEquals(saveBanner.getMaxNumberViews(), loadBanner.getMaxNumberViews());
            assertEquals(saveBanner.getOngoing(), loadBanner.getOngoing());
            assertEquals(saveBanner.getTargetUrl(), loadBanner.getTargetUrl());
            assertEquals(saveBanner.getUid(), loadBanner.getUid());
            assertEquals(saveBanner.getHourBits(), loadBanner.getHourBits());
        } catch (Exception ex) {
            ex.printStackTrace();
            fail(ex.getMessage());
        }
    }

}