package com.adserversoft.flexfuse.server.api.service;

import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import org.apache.commons.fileupload.FileItem;

import javax.xml.crypto.dsig.keyinfo.KeyInfo;
import java.util.List;
import java.util.Map;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */


public interface IBannerManagementService {

    public void update(Banner b) throws Exception;

}

