package com.adserversoft.flexfuse.server.api.ui;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public interface ISettingsService {
    @INoLogin
    ServerResponse getSettings(ServerRequest sr, String lang) throws Exception;

    ServerResponse getBalance(ServerRequest sr, String lang) throws Exception;

    @INoLogin
    ServerResponse createDb(ServerRequest sr, String lang, Integer dbCount, String dbLogin, String dbPassword) throws Exception;
}