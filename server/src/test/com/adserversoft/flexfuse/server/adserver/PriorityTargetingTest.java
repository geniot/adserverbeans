package com.adserversoft.flexfuse.server.adserver;

import com.adserversoft.flexfuse.server.api.AdPlace;
import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.dao.IAdPlaceDAO;
import com.adserversoft.flexfuse.server.api.dao.IBannerDAO;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.dao.NextBannerProcResult;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.AbstractDependencyInjectionSpringContextTests;

import javax.sql.DataSource;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;


public class PriorityTargetingTest extends AbstractDependencyInjectionSpringContextTests {


    public static final String STRING_FOR_BANNER_NAME = "JUnit prior test Banner ";
    AdCodeProcessor adCodeProcessor;
    IBannerDAO bannerDAO;
    IAdPlaceDAO adPlaceDAO;
    JdbcOperations jdbcTemplate;
    String adPlaceUID;
    DataSource dataSource;


    protected String[] getConfigLocations() {
        return new String[]{"context/applicationContext-ui.xml"};
    }

    protected void onSetUp() throws Exception {
        System.out.println("setup");
        adCodeProcessor = (AdCodeProcessor) ContextAwareSpringBean.APP_CONTEXT.getBean("adCodeProcessor");
        bannerDAO = (IBannerDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("bannerDAO1");
        adPlaceDAO = (IAdPlaceDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("adPlaceDAO1");
        dataSource = (DataSource) ContextAwareSpringBean.APP_CONTEXT.getBean("dataSource1");
        jdbcTemplate = new JdbcTemplate(dataSource);
        Properties appProps = new Properties();
        InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
        appProps.load(is);
        ApplicationConstants.AD_FORMATS_MAP = ApplicationConstants.initializeAdFormats(appProps);
        super.onSetUp();
    }


    public void testPriority() {
        adPlaceUID = Long.toString(new Date().getTime()) + Double.toString(Math.random()).split("\\.")[1] + "test";
        AdPlace adPlace = new AdPlace();
        adPlace.setAdPlaceName("PriorityTestAdPlace");
        adPlace.setUid(adPlaceUID);
        List<AdPlace> adPlaces = new ArrayList<AdPlace>();
        adPlaces.add(adPlace);
        try {
            adPlaceDAO.saveOrUpdateAdPlaces(adPlaces);
            List<Integer> banners = new ArrayList<Integer>();

            for (int i = 0; i < 5; i++) {
                saveBannerForSomePriority(1, 10);      // 5 banners with 1 priority and 10 time-dayViewsLimit
            }

            for (int i = 0; i < 5; i++) {
                saveBannerForSomePriority(2, 20);      // 5 banners with 2 priority and 20 time-dayViewsLimit
            }

            for (int i = 0; i < 10; i++) {
                saveBannerForSomePriority(3, 5);      // 10 banners with 3 priority and 5 time-dayViewsLimit
            }

            for (int i = 0; i < 50; i++) {           //5 banners * 10 banners in day
                //System.out.println(i);
                assertTrue(getBannerForSomePriority(1, banners));
            }

            for (int i = 0; i < 100; i++) {          //5 banners * 20 banners in day
                //System.out.println(i);
                assertTrue(getBannerForSomePriority(2, banners));
            }

            for (int i = 0; i < 50; i++) {          //10 banners * 5 banners in day
                //System.out.println(i);
                assertTrue(getBannerForSomePriority(3, banners));
            }

        }
        catch (Exception e) {
            e.printStackTrace();
            fail(e.getMessage());
        } finally {
            jdbcTemplate.execute("DELETE FROM banner");
            jdbcTemplate.execute("DELETE FROM ad_place");
            jdbcTemplate.execute("DELETE FROM aggregate_reports");
            jdbcTemplate.execute("DELETE FROM ad_events_log");

        }
    }

    private void saveBannerForSomePriority(int priority, int bannerDayViewLimit) throws Exception {
        DateFormat dfm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Banner prioriryBanner = new Banner();
        String bannerName = STRING_FOR_BANNER_NAME + priority;
        String bannerUid = Long.toString(new Date().getTime()) + Double.toString(Math.random()).split("\\.")[1];
        Date startDate = dfm.parse("2010-09-30 00:00:00");
        Date endDate = dfm.parse("2010-11-30 00:00:00");
        int bannerTrafficShare = 30;
        int adFormatId = 5;
        int bannerContentTypeId = 1;
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
        prioriryBanner.setDailyViewsLimit(bannerDayViewLimit);
        prioriryBanner.setAdFormatId(adFormatId);
        prioriryBanner.setStartDate(startDate);
        prioriryBanner.setEndDate(endDate);
        prioriryBanner.setPriority(priority);
        prioriryBanner.setBannerName(bannerName);
        prioriryBanner.setUid(bannerUid);
        prioriryBanner.setAdPlaceUid(adPlaceUID);
        prioriryBanner.setCountryBits(countryBits);
        prioriryBanner.setHourBits(hourBits);
        prioriryBanner.setDayBits(weekBits);
        prioriryBanner.setBrowserBits(browserBits);
        prioriryBanner.setOsBits(osBits);
        prioriryBanner.setLanguageBits(languageBits);
        prioriryBanner.setTrafficShare(bannerTrafficShare);
        prioriryBanner.setBannerContentTypeId(bannerContentTypeId);
        List<Banner> l = new ArrayList<Banner>();
        l.add(prioriryBanner);
        bannerDAO.saveOrUpdateBanners(l);
    }


    private boolean getBannerForSomePriority(int priority, List<Integer> banners) throws Exception {
        DateFormat dfm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        RequestParametersForm form = new RequestParametersForm();
        form.setAdPlaceUid(adPlaceUID);
        form.setIp(1L);
        form.setCurrentBrowser(ApplicationConstants.BROWSER_FIREFOX);
        form.setOs(ApplicationConstants.OS_WINDOWS_XP);
        form.setLanguage("ru-ru;ru;en-us;en;");
        ServerRequest serverRequest = new ServerRequest();
        serverRequest.installationId = 1;
        form.setServerRequest(serverRequest);
        adCodeProcessor.processRequest(form, dfm.parse("2010-10-30 23:59:59"));
        NextBannerProcResult nbpr = form.getNextBannerProcResult();
        assertNotNull(nbpr.getBannerUid());
        Banner b = bannerDAO.getBannerByUid(nbpr.getBannerUid());
        return (b.getPriority() == priority);
    }
}