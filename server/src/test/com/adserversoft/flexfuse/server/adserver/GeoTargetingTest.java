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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;


public class GeoTargetingTest extends AbstractDependencyInjectionSpringContextTests {

    public static final Integer COUNTRY_BELARUS = 60;  //All banners show for BELARUS
    public static final String STRING_FOR_BANNER_NAME = "JUnit geo test Banner ";
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


    public void testGeo() {
        adPlaceUID = Long.toString(new Date().getTime()) + Double.toString(Math.random()).split("\\.")[1] + "test";
        AdPlace adPlace = new AdPlace();
        adPlace.setAdPlaceName("GeoTestAdPlace");
        adPlace.setUid(adPlaceUID);
        List<AdPlace> adPlaces = new ArrayList<AdPlace>();
        adPlaces.add(adPlace);
        try {
            adPlaceDAO.saveOrUpdateAdPlaces(adPlaces);
            saveBannerForSomeCountry(12);
            saveBannerForSomeCountry(49);
            saveBannerForSomeCountry(74);
            saveBannerForSomeCountry(190);
            saveBannerForSomeCountry(209);
            assertTrue(getBannerForSomeCountry(35651584L + 5, 12));
            assertTrue(getBannerForSomeCountry(3411559472L + 5, 49));
            assertTrue(getBannerForSomeCountry(3278943051L, 74));
            assertTrue(getBannerForSomeCountry(1484038400L + 5, 74));
            assertTrue(getBannerForSomeCountry(1347256320L + 5, 190));
            assertTrue(getBannerForSomeCountry(3240257536L + 5, 190));
            assertTrue(getBannerForSomeCountry(1481834496L + 5, 209));
            assertTrue(getBannerForSomeCountry(3266437120L + 5, 209));
            getBannerForSomeCountry(3260415488L + 5, 0); //Belarus IP, some banner must be show
            getBannerForSomeCountry(3285502528L + 5, 0); //Belarus IP
            getBannerForSomeCountry(3585662976L + 5, 0); //Belarus IP
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

    private void saveBannerForSomeCountry(int countryId) throws Exception {
        Banner geoBanner = new Banner();
        String bannerName = STRING_FOR_BANNER_NAME + countryId;
        String bannerUid = Long.toString(new Date().getTime()) + Double.toString(Math.random()).split("\\.")[1];
        long oneDay = (long) 1000.0 * 60 * 60 * 24;
        Date startDate = new Date(System.currentTimeMillis() - oneDay);
        Date endDate = new Date(System.currentTimeMillis() + oneDay);
        int bannerTrafficShare = 30;
        int bannerPriority = 1;
        int adFormatId = 5;
        int bannerContentTypeId = 1;
        String countryBits = "";
        for (int i = 0; i < 239; i++) {
            if (i + 1 == countryId || i + 1 == COUNTRY_BELARUS) {
                countryBits += "1";
            } else {
                countryBits += "0";
            }
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
        geoBanner.setAdFormatId(adFormatId);
        geoBanner.setStartDate(startDate);
        geoBanner.setEndDate(endDate);
        geoBanner.setPriority(bannerPriority);
        geoBanner.setBannerName(bannerName);
        geoBanner.setUid(bannerUid);
        geoBanner.setAdPlaceUid(adPlaceUID);
        geoBanner.setCountryBits(countryBits);
        geoBanner.setHourBits(hourBits);
        geoBanner.setDayBits(weekBits);
        geoBanner.setBrowserBits(browserBits);
        geoBanner.setOsBits(osBits);
        geoBanner.setLanguageBits(languageBits);
        geoBanner.setTrafficShare(bannerTrafficShare);
        geoBanner.setBannerContentTypeId(bannerContentTypeId);
        List<Banner> l = new ArrayList<Banner>();
        l.add(geoBanner);
        bannerDAO.saveOrUpdateBanners(l);
    }


    private boolean getBannerForSomeCountry(Long countryIP, int countryId) throws Exception {
        RequestParametersForm form = new RequestParametersForm();
        form.setAdPlaceUid(adPlaceUID);
        form.setIp(countryIP);
        form.setCurrentBrowser(ApplicationConstants.BROWSER_FIREFOX);
        ServerRequest serverRequest = new ServerRequest();
        serverRequest.installationId = 1;
        form.setServerRequest(serverRequest);
        form.setOs(ApplicationConstants.OS_WINDOWS_XP);
        form.setLanguage("ru-ru;ru;en-us;en;");
        adCodeProcessor.processRequest(form, new Date());
        NextBannerProcResult nbpr = form.getNextBannerProcResult();
        assertNotNull(nbpr.getBannerUid());
        Banner b = bannerDAO.getBannerByUid(nbpr.getBannerUid());
        return (b.getBannerName().compareTo(STRING_FOR_BANNER_NAME + countryId) == 0);
    }
}
