package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Banner;
import com.adserversoft.flexfuse.server.api.ui.IBannerService;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.api.ui.ServerResponse;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Dmitrii Lemeshevsky
 * 30.7.2010 14.03.40
 */
public class BannerService extends AbstractService implements IBannerService {

    static Logger logger = Logger.getLogger(UserService.class.getName());

    private ReloadableResourceBundleMessageSource messageSource;

    @Override
    public ServerResponse update(ServerRequest sr, Banner banner) {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            getBannerManagementService().update(banner);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }
        sa.result = ApplicationConstants.SUCCESS;
        return sa;
    }

    public ReloadableResourceBundleMessageSource getMessageSource() {
        return messageSource;
    }

    public void setMessageSource(ReloadableResourceBundleMessageSource messageSource) {
        this.messageSource = messageSource;
    }

}
