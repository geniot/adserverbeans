package com.adserversoft.flexfuse.server.api;


import javax.persistence.Column;
import javax.servlet.http.HttpServletResponse;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.SortedMap;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class ApplicationConstants {
    public static String VERSION = "0.6.2";
    public static final int DEFAULT_INSTALLATION_ID = 1;
    public static final int ADVERTISER_ID = 1;

    public static final String FAILURE = "FAILURE";
    public static final String SUCCESS = "SUCCESS";

    public static final String SESSION_EXPIRED = "SESSION_EXPIRED";
    public static final String VERSION_EXPIRED = "VERSION_EXPIRED";
    public static final String RESET_PASSWORD_SUCCESS = "RESET_PASSWORD_SUCCESS";

    public static final String USER_DELETED_BY_PEER = "USER_DELETED_BY_PEER";
    public static final String USER_ALREADY_EXISTS = "USER_ALREADY_EXISTS";

    public static final String USER_NOT_EXISTS = "USER_NOT_EXISTS";
    public static final String RESET_CODE_OUTDATED = "RESET_CODE_OUTDATED";
    public static final String RESET_CODE_NOT_CORRECT = "RESET_CODE_NOT_CORRECT";

    public static final String emailSubjectPasswordReset = "Password Reset";

    public static final String BANNER_CLASS = "BANNER_CLASS";
    public static final String AD_PLACE_CLASS = "AD_PLACE_CLASS";

    public static String TEMPLATE_SPLITTER = "#splitter#";
    public static String PROPS_SPLITTER = "\n";
    public static final String EVENT_ID_REQUEST_PARAMETER_NAME = "eventId";
    public static final String BANNER_UID_REQUEST_PARAMETER_NAME = "bannerUid";
    public static final String BANNER_PARENT_UID_REQUEST_PARAMETER_NAME = "bannerParentUid";
    public static final String BANNER_TARGET_URL_REQUEST_PARAMETER_NAME = "targetUrl";
    public static final String INST_ID_REQUEST_PARAMETER_NAME = "instId";
    public static final String COUNT_REQUEST_PARAMETER_NAME = "count";
    public static final String AD_FORMAT_ID_REQUEST_PARAMETER_NAME = "adFormatId";
    public static final String PLACE_UID_REQUEST_PARAM_NAME = "placeUid";
    public static final String INSTID_REQUEST_PARAM_NAME = "instId";
    public static final String SESSIONID_REQUEST_PARAM_NAME = "sessionId";
    public static final String BANNER_CONTENT_TYPE = "bannerContentType";
    public static final String PAGE_LOAD_ID = "plId";
    public static final String DYNAMIC_PARAMETERS_PARAM_NAME = "asb_custom_parameters";
    public static final String BANNER_AD_TAG_REQUEST_PARAMETER_NAME = "adTag";

    public static final String UNIQUE_ID_COOKIE_NAME = "UNIQUE_ID_COOKIE_NAME";
    public static final String AD_PLACE_PREVIEW_UID = "preview_uid";

    //entity levels for reports
    public static final int WHOLE_SYSTEM_ENTITY_LEVEL = 0;
    public static final int BANNER_ENTITY_LEVEL = 1;
    public static final int AD_PLACE_ENTITY_LEVEL = 2;
    public static final int BANNER_X_AD_PLACE_ENTITY_LEVEL = 3;

    public static final Double AMOUNT_MONEY = 50D;
    public static final Double AMOUNT_VIEWS = 500000D;
    public static final Double PRICE_ONE_VIEW = AMOUNT_MONEY / AMOUNT_VIEWS;


    //type precision for reports
    public static final int NONE_PRECISION = -1;
    public static final int HOUR_PRECISION = 0;
    public static final int DAY_PRECISION = 1;
    public static final int MONTH_PRECISION = 2;
    public static final int YEAR_PRECISION = 3;

    public static final int BROWSER_FIREFOX = 1;
    public static final int BROWSER_OPERA = 2;
    public static final int BROWSER_CHROME = 3;
    public static final int BROWSER_IE = 4;
    public static final int BROWSER_SAFARI = 5;
    public static final int BROWSER_MOZILLA = 6;
    public static final int BROWSER_NETSCAPE = 7;
    public static final int BROWSER_OTHER = 8;

    public static final int OS_WINDOWS_7 = 1;
    public static final int OS_WINDOWS_XP = 2;
    public static final int OS_WINDOWS_VISTA = 3;
    public static final int OS_WINDOWS_SERVER_2003 = 4;
    public static final int OS_WINDOWS_2000 = 5;
    public static final int OS_WINDOWS_NT = 6;
    public static final int OS_WINDOWS_98 = 7;
    public static final int OS_WINDOWS_95 = 8;
    public static final int OS_WINDOWS_ME = 9;
    public static final int OS_WINDOWS_CE = 10;
    public static final int OS_LINUX = 11;
    public static final int OS_MAC_OS_X = 12;
    public static final int OS_MAC = 13;
    public static final int OS_FREEBSD = 14;
    public static final int OS_SOLARIS = 15;
    public static final int OS_UNKNOWN = 16;

    //adserver events
    public static final byte GET_AD_CODE_SERVER_EVENT_TYPE = 1;
    public static final byte GET_AD_FILE_SERVER_EVENT_TYPE = 2;
    public static final byte CLICK_AD_SERVER_EVENT_TYPE = 3;
    public static final byte MISSED_BANNER_ADSERVER_EVENT_TYPE = 10;

    public static final int STATE_ACTIVE = 1;
    public static final int STATE_INACTIVE = 2;
    public static final int STATE_REMOVED = 3;

    public static final int IMAGE_BANNER_CONTENT_TYPE_ID = 1;
    public static final int FLASH_BANNER_CONTENT_TYPE_ID = 2;
    public static final int HTML_BANNER_CONTENT_TYPE_ID = 3;
    public static final int AD_TAG_BANNER_CONTENT_TYPE_ID = 4;

    public static final Map<Integer, String> CONTENT_TYPES_MAP = new HashMap<Integer, String>();
    public static Map<Integer, AdFormat> AD_FORMATS_MAP;


    public static int DATABASE_COUNT = 10;
//    public static HashMap<String, String> dbLogMap = new HashMap<String, String>();
    public static final String DB_FILE_STATE_NAME = "database_state.xml";
    public static final String DB_FILE_PROPERTIES_NAME = ".dbProperties";
    public static final String DB_FAILURE = "DB_FAILURE";
    public static final String DB_NAME_FIRST = "myads";
    public static final String DATABASE_OK = "OK";
    public static final String DATABASE_DEPRECATED = "database schema is outdated - update required";
    public static final String TABLES_DO_NOT_EXISTS = "tables not found - update required";
    public static final String DB_DOES_NOT_EXISTS = "database not found - update required";
    public static Boolean IS_DB_UPDATE_REQUIRED = false;


    public static String generatePlaceHolders(SortedMap<String, Object> m) {
        StringBuffer s = new StringBuffer();
        int counter = 0;
        for (Object o : m.keySet()) {
            s.append("?");
            if (counter++ < m.size() - 1) s.append(",");
        }
        return s.toString();
    }

    public static String generatePlaceHolders(List m) {
        StringBuffer s = new StringBuffer();
        int counter = 0;
        for (Object o : m) {
            s.append("?");
            if (counter++ < m.size() - 1) s.append(",");
        }
        return s.toString();
    }

    public static String getColumnNames(SortedMap<String, Object> m) {
        StringBuffer s = new StringBuffer();
        int counter = 0;
        for (Object o : m.keySet()) {
            s.append(o);
            if (counter++ < m.size() - 1) s.append(",");
        }
        return s.toString();
    }

    public static Map<Integer, AdFormat> initializeAdFormats(Properties props) {
        Map<Integer, AdFormat> m = new HashMap<Integer, AdFormat>();
        for (Object key : props.keySet()) {
            if (key.toString().startsWith("ad_format.")) {
                AdFormat adFormat = new AdFormat();
                adFormat.setId(Integer.parseInt(props.getProperty(key.toString())));
                adFormat.setWidth(Integer.parseInt(key.toString().split(("\\."))[1].split("_")[0]));
                adFormat.setHeight(Integer.parseInt(key.toString().split(("\\."))[1].split("_")[1]));
                m.put(adFormat.getId(), adFormat);
            }
        }
        return m;
    }


    public static String generateParametrizedColumnNames(SortedMap<String, Object> m) {
        StringBuffer s = new StringBuffer();
        int counter = 0;
        for (Object o : m.keySet()) {
            s.append(o);
            s.append("=?");
            if (counter++ < m.size() - 1) s.append(",");
        }
        return s.toString();
    }

    public static String getColumnNameFromField(Field field) {
        Annotation[] annotations = field.getDeclaredAnnotations();
        for (Annotation an : annotations) {
            if (an instanceof Column) {
                return ((Column) an).name();
            }
        }
        return null;
    }

    public static String concatenateForIn(List<String> bannerUids) {
        StringBuffer s = new StringBuffer();
        int counter = 0;
        for (String uid : bannerUids) {
            s.append("'");
            s.append(uid);
            s.append("'");
            if (counter++ < bannerUids.size() - 1) s.append(",");
        }
        return s.toString();
    }

    public static String concatenateAdPlaceUidsForIn(List<AdPlace> adPlaces) {
        StringBuffer s = new StringBuffer();
        int counter = 0;
        for (AdPlace o : adPlaces) {
            s.append("'");
            s.append(o.getUid());
            s.append("'");
            if (counter++ < adPlaces.size() - 1) s.append(",");
        }
        return s.toString();
    }


    public static void bustCache(HttpServletResponse response) {
        response.addHeader("Cache-Control", "no-cache");               // HTTP/1.1
        response.addHeader("Cache-Control", "no-store");               // HTTP/1.1
        response.addHeader("Cache-Control", "must-revalidate");     // HTTP/1.1
        response.addHeader("Pragma", "no-cache");
        response.addDateHeader("Expires", 0);
    }

    public static String mirrorBytes(String property) {
        return property;
//        byte[] bbs = property.getBytes();
//        byte[] newBbs = new byte[bbs.length];
//        int counter = 0;
//        for (byte b : bbs) {
//            System.out.print(b + "->" + reverseByteBits(b));
//            newBbs[counter++] = reverseByteBits(b);
//        }
//        System.out.println("\n");
//        return new String(newBbs);
    }

    private static byte reverseByteBits(byte value) {
        byte ret = 0;
        for (int i = 0; i < 8; i++)
            if ((value & (byte) (1 << i)) != 0) ret += (byte) (1 << (7 - i));
        return ret;
    }
}
