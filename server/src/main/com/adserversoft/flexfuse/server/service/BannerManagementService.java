package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.AdPlace;
import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.api.service.IBannerManagementService;
import org.apache.commons.fileupload.FileItem;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Author: Vitaly Sazanovich
 * Vitaly Sazanovich@gmail.com
 */

public class BannerManagementService extends AbstractManagementService implements IBannerManagementService {


    @Override
    public void update(Banner b) throws Exception {
        List<Banner> banners = new ArrayList<Banner>();
        banners.add(b);
        getBannerDAO().saveOrUpdateBanners(banners);
    }
}

   
