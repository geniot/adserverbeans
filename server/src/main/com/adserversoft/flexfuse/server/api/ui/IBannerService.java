package com.adserversoft.flexfuse.server.api.ui;

import com.adserversoft.flexfuse.server.api.Banner;

import java.util.List;

/**
 * Author: Dmitrii Lemeshevsky
 * 30.7.2010 14.02.49
 */
public interface IBannerService {

    public ServerResponse update(ServerRequest sr, Banner banner);

}