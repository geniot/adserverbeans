package com.adserversoft.flexfuse.server.api.ui;


import com.adserversoft.flexfuse.server.api.Banner;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public interface ISessionService {
    public String getNewSessionId();

    public void put(String sessionid, UserSession us);

    public UserSession get(String sessionId);

    public void remove(String sessionId);

    public void update();

    public Banner getBannerFromSessions(String bannerUid);

    public void deleteBannerFromSessions(String bannerUid);
}
