package com.adserversoft.flexfuse.server.service;


import com.adserversoft.flexfuse.server.adserver.AdCodeProcessor;
import com.adserversoft.flexfuse.server.adserver.ClickProcessor;
import com.adserversoft.flexfuse.server.adserver.RequestParametersForm;
import com.adserversoft.flexfuse.server.api.*;
import com.adserversoft.flexfuse.server.api.dao.IAdPlaceDAO;
import com.adserversoft.flexfuse.server.api.dao.IBannerDAO;
import com.adserversoft.flexfuse.server.api.service.IReportManagementService;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.dao.NextBannerProcResult;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;
import winstone.WinstoneResponse;

import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class ReportManagementServiceTest extends AbstractTransactionalDataSourceSpringContextTests {

    public static final String STRING_FOR_BANNER_NAME = "JUnit report test Banner ";

    public static final long oneDay = (long) 1000.0 * 60 * 60 * 24;
    public static final long tenDay = 10 * oneDay;
    public static final long nowDate = System.currentTimeMillis();

    IBannerDAO bannerDAO;
    IAdPlaceDAO adPlaceDAO;
    IReportManagementService reportManagementService;
    AdCodeProcessor adCodeProcessor;
    ClickProcessor clickProcessor;
    DataSource dataSource;

    protected String[] getConfigLocations() {
        setAutowireMode(AUTOWIRE_BY_NAME);
        setDependencyCheck(false);
        return new String[]{"context/applicationContext-ui.xml"};
    }

    protected void onSetUp() throws Exception {
        System.out.println("setup");
        adPlaceDAO = (IAdPlaceDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("adPlaceDAO1");
        bannerDAO = (IBannerDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("bannerDAO1");
        reportManagementService = (IReportManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("reportManagementServiceTarget1");
        adCodeProcessor = (AdCodeProcessor) ContextAwareSpringBean.APP_CONTEXT.getBean("adCodeProcessor");
        clickProcessor = (ClickProcessor) ContextAwareSpringBean.APP_CONTEXT.getBean("clickProcessor");
        dataSource = (DataSource) ContextAwareSpringBean.APP_CONTEXT.getBean("dataSource1");
        jdbcTemplate = new JdbcTemplate(dataSource);
        Properties appProps = new Properties();
        InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
        appProps.load(is);
        ApplicationConstants.AD_FORMATS_MAP = ApplicationConstants.initializeAdFormats(appProps);
        super.onSetUp();
    }

    protected void onTearDown() throws Exception {
        super.onTearDown();
    }

    public void testTemp() {
        assertNull(null);
    }

    public void testReport() {
        try {
            String adPlaceUID = Long.toString(new Date().getTime()) + Double.toString(Math.random()).split("\\.")[1] + "test";
            AdPlace adPlace = new AdPlace();
            adPlace.setAdPlaceName("ReportManagementServiceTest");
            adPlace.setUid(adPlaceUID);
            List<AdPlace> adPlaces = new ArrayList<AdPlace>();
            adPlaces.add(adPlace);
            adPlaceDAO.saveOrUpdateAdPlaces(adPlaces);
//            Integer adPlaceId = adPlaceDAO.getAdPlaceByUid(adPlaceUID).getId();
            HashMap<String, Banner> banners = new HashMap<String, Banner>();

            for (int i = 0; i < 20; i++) {
                saveBannerForSomePriority(adPlaceUID, banners);
            }

            for (int i = 0; i < 100; i++) {
                Banner b = getBannerView(adPlaceUID);
                b = banners.get(b.getUid());
                if (b.getViews() == null) {
                    b.setViews(1);
                } else {
                    b.setViews(b.getViews() + 1);
                }
            }

            for (int i = 0; i < 100; i++) {
                Random rnd = new Random();
                int x = rnd.nextInt(banners.size()) + 1;
                Banner b = (Banner) banners.values().toArray()[x - 1];
//                Integer bannerId = bannerDAO.getBannerByUid(b.getUid()).getId();
                getBannerClick(adPlaceUID, b.getUid());
                if (b.getClicks() == null) {
                    b.setClicks(1);
                } else {
                    b.setClicks(b.getClicks() + 1);
                }
            }


            ReportCriteria testReportCriteria = new ReportCriteria();
            testReportCriteria.setBannerUidByAdPlaceUids(new ArrayList<String>());
            for (int i = 0; i < 20; i++) {
                Banner b = (Banner) banners.values().toArray()[i];
                testReportCriteria.getBannerUidByAdPlaceUids().add(b.getUid() + "x" + b.getAdPlaceUid());
            }
            testReportCriteria.setFromDate(new Date(nowDate - oneDay));
            testReportCriteria.setToDate(new Date(nowDate + oneDay));
            testReportCriteria.setPrecision(0);
            testReportCriteria.setType(3);

            List<ReportsRow> reportsRows = reportManagementService.loadReport(testReportCriteria);
            for (ReportsRow requestRow : reportsRows) {
                Banner b = banners.get(requestRow.getBannerUid());
                if (requestRow.getViews() != null && b.getViews() != null) {
                    assertEquals(requestRow.getViews(), b.getViews());
                } else {
                    assertNull(b.getViews());
                    assertEquals(requestRow.getViews(), new Integer(0));
                }
                if (requestRow.getClicks() != null && b.getClicks() != null) {
                    assertEquals(requestRow.getClicks(), b.getClicks());
                } else {
                    assertNull(b.getClicks());
                    assertEquals(requestRow.getClicks(), new Integer(0));
                }
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            fail(ex.getMessage());
        } finally {
            jdbcTemplate.execute("DELETE FROM banner");
            jdbcTemplate.execute("DELETE FROM ad_place");
            jdbcTemplate.execute("DELETE FROM aggregate_reports");
            jdbcTemplate.execute("DELETE FROM ad_events_log");
        }
    }


    private void saveBannerForSomePriority(String adPlaceUID, HashMap<String, Banner> banners) throws Exception {
        Banner reportBanner = new Banner();
        String bannerName = STRING_FOR_BANNER_NAME;
        String bannerUid = Long.toString(new Date().getTime()) + Double.toString(Math.random()).split("\\.")[1];
        int bannerTrafficShare = 30;
        int bannerDayViewLimit = 10;
        int adFormatId = 5;
        int bannerContentTypeId = 1;
        int priority = 1;
        String targetURL = "bash.org.ru";
        String countryBits = "";
        for (int i = 0; i < 239; i++) {
            countryBits += "1";
        }
        String hourBits = "";
        for (int i = 0; i < 24; i++) {
            hourBits += "1";
        }
        String weekBits = "";
        for (int i = 0; i < 7; i++) {
            weekBits += "1";
        }
        String browserBits = "";
        for (int i = 0; i < 8; i++) {
            browserBits += "1";
        }
        String osBits = "";
        for (int i = 0; i < 16; i++) {
            osBits += "1";
        }
        String languageBits = "";
        for (int i = 0; i < 16; i++) {
            languageBits += "1";
        }
        reportBanner.setDailyViewsLimit(bannerDayViewLimit);
        reportBanner.setAdFormatId(adFormatId);
        reportBanner.setStartDate(new Date(nowDate - tenDay));
        reportBanner.setEndDate(new Date(nowDate + oneDay));
        reportBanner.setPriority(priority);
        reportBanner.setBannerName(bannerName);
        reportBanner.setUid(bannerUid);
        reportBanner.setAdPlaceUid(adPlaceUID);
        reportBanner.setCountryBits(countryBits);
        reportBanner.setHourBits(hourBits);
        reportBanner.setDayBits(weekBits);
        reportBanner.setBrowserBits(browserBits);
        reportBanner.setOsBits(osBits);
        reportBanner.setLanguageBits(languageBits);
        reportBanner.setTrafficShare(bannerTrafficShare);
        reportBanner.setBannerContentTypeId(bannerContentTypeId);
        reportBanner.setTargetUrl(targetURL);
        banners.put(bannerUid, reportBanner);
        List<Banner> l = new ArrayList<Banner>();
        l.add(reportBanner);
        bannerDAO.saveOrUpdateBanners(l);
    }


    private Banner getBannerView(String adPlaceUID) throws Exception {
        RequestParametersForm form = new RequestParametersForm();
        form.setAdPlaceUid(adPlaceUID);
        form.setIp(1L);
        form.setCurrentBrowser(ApplicationConstants.BROWSER_FIREFOX);
        ServerRequest serverRequest = new ServerRequest();
        serverRequest.installationId = 1;
        form.setServerRequest(serverRequest);
        form.setEventType(ApplicationConstants.GET_AD_CODE_SERVER_EVENT_TYPE);
        form.setOs(ApplicationConstants.OS_WINDOWS_XP);
        form.setLanguage("ru-ru;ru;en-us;en;");
        adCodeProcessor.processRequest(form, new Date(nowDate));
        NextBannerProcResult nbpr = form.getNextBannerProcResult();
        assertNotNull(nbpr.getBannerUid());
        return bannerDAO.getBannerByUid(nbpr.getBannerUid());
    }

    private void getBannerClick(String adPlaceUid, String bannerUid) throws Exception {
        RequestParametersForm form = new RequestParametersForm();
        form.setIp(1L);
        form.setCurrentBrowser(ApplicationConstants.BROWSER_FIREFOX);
        form.setBannerUid(bannerUid);
        form.setAdPlaceUid(adPlaceUid);
        form.setEventType(ApplicationConstants.CLICK_AD_SERVER_EVENT_TYPE);
        ServerRequest serverRequest = new ServerRequest();
        HttpServletResponse serverResponse = new WinstoneResponse();
        form.setResponse(serverResponse);
        serverRequest.installationId = 1;
        form.setServerRequest(serverRequest);
        clickProcessor.registerEvent(form, new Date(nowDate));
    }


}