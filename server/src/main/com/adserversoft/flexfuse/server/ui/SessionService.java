package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.api.ui.ISessionService;
import com.adserversoft.flexfuse.server.api.ui.UserSession;
import com.adserversoft.flexfuse.server.service.AbstractManagementService;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class SessionService extends AbstractManagementService implements ISessionService {
    private static Logger logger = Logger.getLogger(SessionService.class.getName());
    private Map<String, UserSession> userSessionsMap = Collections.synchronizedMap(new HashMap());
    private long expireIn;

    public String getNewSessionId() {
        String id = UUID.randomUUID().toString();
        while (userSessionsMap.containsKey(id)) {
            id = UUID.randomUUID().toString();
        }
        return id;
    }

    public void put(String sessionid, UserSession us) {
        if (us != null) us.lastAccess = System.currentTimeMillis();
        userSessionsMap.put(sessionid, us);
    }

    public UserSession get(String sessionId) {
        UserSession us = userSessionsMap.get(sessionId);
        if (us != null) us.lastAccess = System.currentTimeMillis();
        return us;
    }

    public void remove(String sessionId) {
        userSessionsMap.remove(sessionId);
    }


    public void update() {
        Map<String, UserSession> newMap = new HashMap();
        long currentTime = System.currentTimeMillis();
        for (String sessionId : userSessionsMap.keySet()) {
            UserSession us = userSessionsMap.get(sessionId);
            if (currentTime - us.lastAccess < expireIn) {
                newMap.put(sessionId, us);
            }
        }
        logger.fine("Cleaned " + (userSessionsMap.size() - newMap.size()) + " sessions");
        userSessionsMap = newMap;
    }

    public Banner getBannerFromSessions(String bannerUid) {
        for (UserSession session : (Collection<UserSession>) userSessionsMap.values()) {
            for (String key : (Set<String>) session.uploadedBanners.keySet()) {
                if (key.equals(bannerUid)) {
                    return (Banner) session.uploadedBanners.get(key);
                }
            }
        }
        return null;
    }

    public void deleteBannerFromSessions(String bannerUid) {
        for (UserSession session : (Collection<UserSession>) userSessionsMap.values()) {
            for (String key : (Set<String>) session.uploadedBanners.keySet()) {
                if (key.equals(bannerUid)) {
                    session.uploadedBanners.remove(key);
                }
            }
        }
    }


    public long getExpireIn() {
        return expireIn;
    }

    public void setExpireIn(long expireIn) {
        this.expireIn = expireIn;
    }
}

