package com.adserversoft.flexfuse.server.adserver;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import com.adserversoft.flexfuse.server.service.AbstractManagementService;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class AdServerModelBuilder extends AbstractManagementService {
    static Logger logger = Logger.getLogger(AdServerModelBuilder.class.getName());

    private String bannerNotFoundOnClickRedirectUrl;

    public RequestParametersForm buildParamsFromRequest(HttpServletRequest request,
                                                        HttpServletResponse response) {
        RequestParametersForm requestParametersForm = new RequestParametersForm();
        Map<String, String> requestParametersMap = getParametersFromRequest(request);

        requestParametersForm.setResponse(response);
        ServerRequest sr = new ServerRequest();

        String currentUserAgent = request.getHeader("user-agent");

        try {
            if (requestParametersMap.containsKey("wlpru"))
                requestParametersForm.setReferrer(URLDecoder.decode(requestParametersMap.get("wlpru"), "UTF-8"));
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }

        try {
            if (requestParametersMap.containsKey("wlpu"))
                requestParametersForm.setBannerUrl(URLDecoder.decode(requestParametersMap.get("wlpu"), "UTF-8"));
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }

        //browser
        requestParametersForm.setCurrentBrowser(getBrowserFromUserAgent(currentUserAgent));

        //os
        requestParametersForm.setOs(getOsFromUserAgent(currentUserAgent));


        //language
        String acceptLanguage = request.getHeader("Accept-Language");
        acceptLanguage = acceptLanguage.replace(",", ";");
        String[] acceptLanguageTokens = acceptLanguage.split(";");
        acceptLanguage = "";
        for (String acceptLanguageToken : acceptLanguageTokens) {
            if (!acceptLanguageToken.contains("=")) {
                acceptLanguage += acceptLanguageToken + ";";
            }
        }
        requestParametersForm.setLanguage(acceptLanguage);

        //count
        try {
            String countStr = requestParametersMap.get(ApplicationConstants.COUNT_REQUEST_PARAMETER_NAME);
            if (countStr == null) {
                requestParametersForm.setCount(true);
            } else {
                requestParametersForm.setCount(Boolean.parseBoolean(countStr));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            requestParametersForm.setCount(true);
        }


        //instId
        int instId = ApplicationConstants.DEFAULT_INSTALLATION_ID;
        try {
            String instIdStr = requestParametersMap.get(ApplicationConstants.INST_ID_REQUEST_PARAMETER_NAME);
            instId = Byte.parseByte(instIdStr);
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.log(Level.SEVERE, "Couldn't find or parse instId:" + ex.getMessage());
        }
        sr.installationId = instId;
        InstallationContextHolder.setCustomerType(instId);
        requestParametersForm.setServerRequest(sr);


        //eventType
        Byte eventType;
        try {
            String eventTypeStr = requestParametersMap.get(ApplicationConstants.EVENT_ID_REQUEST_PARAMETER_NAME);
            eventType = Byte.parseByte(eventTypeStr);
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.log(Level.SEVERE, "Couldn't find or parse eventId:" + ex.getMessage());
            eventType = ApplicationConstants.GET_AD_CODE_SERVER_EVENT_TYPE;
        }
        requestParametersForm.setEventType(eventType);


        //ip address
        try {
            if (requestParametersForm.getEventType() == ApplicationConstants.GET_AD_CODE_SERVER_EVENT_TYPE) {
                String ipAddress;
                ipAddress = request.getHeader("X-Forwarded-For") == null ?
                        request.getRemoteAddr() : request.getHeader("X-Forwarded-For");
                // Chop off everything from the comma onwards
                StringBuffer buffer = new StringBuffer(ipAddress);
                int index = buffer.indexOf(",");
                if (index > 0) { // See if there is  comma
                    buffer = buffer.delete(index, buffer.length());
                }
                String ipKey = buffer.toString();
                StringTokenizer stringTokenizer = new StringTokenizer(ipKey, ".");
                if (stringTokenizer.countTokens() == 4) {
                    long ip = 0L;
                    int counter = 3;
                    while (stringTokenizer.hasMoreTokens() && counter >= 0) {
                        long read = new Long(stringTokenizer.nextToken());
                        long calculated = new Double(read * (Math.pow(256, counter))).longValue();
                        ip += calculated;
                        counter--;
                    }
                    requestParametersForm.setIp(ip);
                } else {
                    logger.log(Level.SEVERE, "Couldn't find ip:" + stringTokenizer);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.log(Level.SEVERE, "Couldn't find ip:" + e.getMessage());
        }

        //bannerUid
        try {
            if (requestParametersMap.containsKey(ApplicationConstants.BANNER_UID_REQUEST_PARAMETER_NAME)) {
                String bannerUidStr = requestParametersMap.get(ApplicationConstants.BANNER_UID_REQUEST_PARAMETER_NAME);
                requestParametersForm.setBannerUid(bannerUidStr);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        //adplaceUID
        try {
            if (requestParametersMap.containsKey(ApplicationConstants.PLACE_UID_REQUEST_PARAM_NAME)) {
                String adPlaceUIDStr = requestParametersMap.get(ApplicationConstants.PLACE_UID_REQUEST_PARAM_NAME);
                requestParametersForm.setAdPlaceUid(adPlaceUIDStr);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            ex.getStackTrace();
        }

        //ad server url
        try {
            requestParametersForm.setAdServerUrl(request.getRequestURL().toString().split(request.getRequestURI())[0] + request.getContextPath() + "/sv");
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        //response
        try {
            requestParametersForm.setResponse(response);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        //unique id
        try {
            Cookie cc = getCookieByName(request, ApplicationConstants.UNIQUE_ID_COOKIE_NAME);
            if (cc != null) requestParametersForm.setUniqueId(cc.getValue());
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        //page load id
        try {
            if (requestParametersMap.containsKey(ApplicationConstants.PAGE_LOAD_ID)) {
                String pageLoadId = requestParametersMap.get(ApplicationConstants.PAGE_LOAD_ID);
                requestParametersForm.setPageLoadUid(pageLoadId);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }


          //dynamic parameters
        try {
            String dynamicParametersStr = requestParametersMap.get(ApplicationConstants.DYNAMIC_PARAMETERS_PARAM_NAME);
            if (dynamicParametersStr == null) {
                requestParametersForm.setDynamicParameters(null);
            } else {
                requestParametersForm.setDynamicParameters(dynamicParametersStr);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            requestParametersForm.setCount(true);
        }


        return requestParametersForm;
    }

    private Cookie getCookieByName(HttpServletRequest request, String cookieName) {
        Cookie[] ccs = request.getCookies();
        if (ccs == null) return null;
        for (Cookie cc : ccs) {
            if (cc.getName().equals(cookieName)) return cc;
        }
        return null;
    }

    private Map<String, String> getParametersFromRequest
            (HttpServletRequest
                    req) {
        Map<String, String> parametersMap = new HashMap<String, String>();
        for (Object key : req.getParameterMap().keySet()) {
            String value = req.getParameter((String) key);
            parametersMap.put((String) key, value);
        }

        String[] keyValuePairs = req.getQueryString().split("(\\||\\&)");
        if (keyValuePairs.length > 0) {
            parametersMap.put("clickTAG", keyValuePairs[0]);
            for (String keyValuePairStr : keyValuePairs) {
                String[] keyValuePair = keyValuePairStr.split("=");
                if (keyValuePair.length == 2) {
                    parametersMap.put(keyValuePair[0], keyValuePair[1]);
                }
            }
        }
        return parametersMap;
    }

    public void buildTemplateParams(RequestParametersForm form) {

        StringBuffer adPlaceUidPar = form.getAdPlaceUid() == null ? null : new StringBuffer().append(ApplicationConstants.PLACE_UID_REQUEST_PARAM_NAME).append("=").append(form.getAdPlaceUid());

        StringBuffer targetUrl = new StringBuffer()
                .append(form.getAdServerUrl())
                .append("?")
                .append(ApplicationConstants.EVENT_ID_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(ApplicationConstants.CLICK_AD_SERVER_EVENT_TYPE)
                .append("|")
                .append(ApplicationConstants.BANNER_UID_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(form.getNextBannerProcResult().getBannerUid())
                .append("|")
                .append(ApplicationConstants.INST_ID_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(form.getServerRequest().installationId)
                .append("|")
                .append(ApplicationConstants.COUNT_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(form.getCount());
        if (adPlaceUidPar != null) {
            targetUrl.append("|").append(adPlaceUidPar);
        }
        form.setClickThroughUrl(targetUrl.toString());

        StringBuffer adSource = new StringBuffer()
                .append(form.getAdServerUrl())
                .append("?")
                .append(ApplicationConstants.EVENT_ID_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(ApplicationConstants.GET_AD_FILE_SERVER_EVENT_TYPE)
                .append("&")
                .append(ApplicationConstants.BANNER_UID_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(form.getNextBannerProcResult().getBannerUid())
                .append("&")
                .append(ApplicationConstants.INST_ID_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(form.getServerRequest().installationId)
                .append("&")
                .append(ApplicationConstants.BANNER_CONTENT_TYPE)
                .append("=")
                .append(form.getNextBannerProcResult().getBannerContentTypeId())
                .append("&")
                .append(ApplicationConstants.COUNT_REQUEST_PARAMETER_NAME)
                .append("=")
                .append(form.getCount())
                .append("&rnd=")
                .append(System.currentTimeMillis());
        if (adPlaceUidPar != null) {
            adSource.append("&").append(adPlaceUidPar);
        }
        form.setAdSourceUrl(adSource.toString());
    }

    public String getBannerNotFoundOnClickRedirectUrl() {
        return bannerNotFoundOnClickRedirectUrl;
    }

    public void setBannerNotFoundOnClickRedirectUrl(String bannerNotFoundOnClickRedirectUrl) {
        this.bannerNotFoundOnClickRedirectUrl = bannerNotFoundOnClickRedirectUrl;
    }

    public int getBrowserFromUserAgent(String userAgent) {
        if (userAgent.indexOf("MSIE") > -1) {
            return ApplicationConstants.BROWSER_IE;
        } else if ((userAgent.indexOf("Netscape") > -1) || (userAgent.indexOf("Navigator") > -1)) {
            return ApplicationConstants.BROWSER_NETSCAPE;
        } else if (userAgent.indexOf("Chrome") > -1) {
            return ApplicationConstants.BROWSER_CHROME;
        } else if (userAgent.indexOf("Firefox") > -1) {
            return ApplicationConstants.BROWSER_FIREFOX;
        } else if (userAgent.indexOf("Opera") > -1) {
            return ApplicationConstants.BROWSER_OPERA;
        } else if (userAgent.indexOf("Safari") > -1) {
            return ApplicationConstants.BROWSER_SAFARI;
        } else if (userAgent.indexOf("Mozilla") > -1) {
            return ApplicationConstants.BROWSER_MOZILLA;
        } else {
            return ApplicationConstants.BROWSER_OTHER;
        }
    }

    public int getOsFromUserAgent(String userAgent) {
        int osType = ApplicationConstants.OS_UNKNOWN;

        if (userAgent.indexOf("Win") > -1) {
            if (userAgent.indexOf("NT 4.0") > -1) {
                return ApplicationConstants.OS_WINDOWS_NT;
            } else if (userAgent.indexOf("NT 6.1") > -1) {
                return ApplicationConstants.OS_WINDOWS_7;
            } else if (userAgent.indexOf("NT 6.0") > -1) {
                return ApplicationConstants.OS_WINDOWS_VISTA;
            } else if (userAgent.indexOf("NT 5.2") > -1) {
                return ApplicationConstants.OS_WINDOWS_SERVER_2003;
            } else if ((userAgent.indexOf("NT 5.1") > -1) ||
                    (userAgent.indexOf("Win32") > -1) || (userAgent.indexOf("XP") > -1)) {
                return ApplicationConstants.OS_WINDOWS_XP;
            } else if (userAgent.indexOf("NT 5.0") > -1) {
                return ApplicationConstants.OS_WINDOWS_2000;
            } else if (userAgent.indexOf("Me") > -1) {
                return ApplicationConstants.OS_WINDOWS_ME;
            } else if (userAgent.indexOf("Ce") > -1) {
                return ApplicationConstants.OS_WINDOWS_CE;
            } else if (userAgent.indexOf("98") > -1) {
                return ApplicationConstants.OS_WINDOWS_98;
            } else if (userAgent.indexOf("95") > -1) {
                return ApplicationConstants.OS_WINDOWS_95;
            }
        } else {
            if ((userAgent.indexOf("Linux") > -1) ||
                    (userAgent.indexOf("Lynx") > -1) || (userAgent.indexOf("Unix") > -1)) {
                return ApplicationConstants.OS_LINUX;
            } else if (userAgent.indexOf("Mac OS X") > -1) {
                return ApplicationConstants.OS_MAC_OS_X;
            } else if (userAgent.indexOf("Mac") > -1) {
                return ApplicationConstants.OS_MAC;
            } else if ((userAgent.indexOf("Solaris") > -1) ||
                    (userAgent.indexOf("Sun") > -1)) {
                return ApplicationConstants.OS_SOLARIS;
            } else if (userAgent.indexOf("FreeBSD") > -1) {
                return ApplicationConstants.OS_FREEBSD;
            }
        }
        return osType;
    }
}
