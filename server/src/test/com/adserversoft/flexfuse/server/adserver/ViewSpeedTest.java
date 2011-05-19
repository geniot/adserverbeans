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


public class ViewSpeedTest extends AbstractDependencyInjectionSpringContextTests {

    public static final String STRING_FOR_BANNER_NAME = "JUnit speed test Banner ";
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


    public void testViewSpeed() {
        adPlaceUID = Long.toString(new Date().getTime()) + Double.toString(Math.random()).split("\\.")[1] + "test";
        AdPlace adPlace = new AdPlace();
        adPlace.setAdPlaceName("SpeedTestAdPlace");
        adPlace.setUid(adPlaceUID);
        List<AdPlace> adPlaces = new ArrayList<AdPlace>();
        adPlaces.add(adPlace);
        try {
            adPlaceDAO.saveOrUpdateAdPlaces(adPlaces);
            saveBanner();
            for (int i = 0; i < 12; i += 2) {
                assertNotNull(getBannerForSomeTime(i).getBannerUid());
                assertNull(getBannerForSomeTime(i + 1).getBannerUid());
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

    private void saveBanner() throws Exception {
        DateFormat dfm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Banner speedBanner = new Banner();
        String bannerName = STRING_FOR_BANNER_NAME;
        String bannerUid = Long.toString(new Date().getTime()) + Double.toString(Math.random()).split("\\.")[1];
        Date startDate = dfm.parse("2010-09-30 00:00:00");
        Date endDate = dfm.parse("2010-11-30 00:00:00");
        int bannerWeight = 30;
        int bannerPriority = 1;
        int adFormatId = 5;
        int bannerContentTypeId = 1;
        int dailyViewLimit = 12;
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
        speedBanner.setDailyViewsLimit(dailyViewLimit);
        speedBanner.setAdFormatId(adFormatId);
        speedBanner.setStartDate(startDate);
        speedBanner.setEndDate(endDate);
        speedBanner.setPriority(bannerPriority);
        speedBanner.setBannerName(bannerName);
        speedBanner.setUid(bannerUid);
        speedBanner.setAdPlaceUid(adPlaceUID);
        speedBanner.setCountryBits(countryBits);
        speedBanner.setHourBits(hourBits);
        speedBanner.setDayBits(weekBits);
        speedBanner.setBrowserBits(browserBits);
        speedBanner.setOsBits(osBits);
        speedBanner.setLanguageBits(languageBits);
        speedBanner.setTrafficShare(bannerWeight);
        speedBanner.setBannerContentTypeId(bannerContentTypeId);
        List<Banner> l = new ArrayList<Banner>();
        l.add(speedBanner);
        bannerDAO.saveOrUpdateBanners(l);
    }


    private NextBannerProcResult getBannerForSomeTime(Integer hour) throws Exception {
        DateFormat dfm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String templateDate = "2010-10-30 !!:15:00";
        RequestParametersForm form = new RequestParametersForm();
        form.setAdPlaceUid(adPlaceUID);
        form.setIp(1L);
        form.setCurrentBrowser(ApplicationConstants.BROWSER_FIREFOX);
        form.setOs(ApplicationConstants.OS_WINDOWS_XP);
        form.setLanguage("ru-ru;ru;en-us;en;");
        ServerRequest serverRequest = new ServerRequest();
        serverRequest.installationId = 1;
        form.setServerRequest(serverRequest);
        String dateString = templateDate.replaceAll("!!", hour.toString());
        adCodeProcessor.processRequest(form, dfm.parse(dateString));
        NextBannerProcResult nbpr = form.getNextBannerProcResult();
        return nbpr;

    }
}