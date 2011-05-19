package com.adserversoft.flexfuse.server.api.ui;

import com.adserversoft.flexfuse.server.api.Banner;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Locale;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class UserSession implements Serializable {
    public String sessionId;
    public String email;
    public Integer userId;
    public long lastAccess;
    public Locale locale;
    public byte[] logo;
    public String filename;
    public Object customSessionObject;
    public HashMap<String,Banner> uploadedBanners = new HashMap<String, Banner>();

    public void reset() {
        userId = null;
        lastAccess = System.currentTimeMillis();
    }
}