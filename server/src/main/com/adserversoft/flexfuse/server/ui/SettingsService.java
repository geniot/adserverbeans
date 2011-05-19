package com.adserversoft.flexfuse.server.ui;


import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ReportCriteria;
import com.adserversoft.flexfuse.server.api.ReportsRow;
import com.adserversoft.flexfuse.server.api.ui.ISettingsService;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.api.ui.ServerResponse;
import com.adserversoft.flexfuse.server.api.ui.Settings;
import flex.messaging.FlexContext;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class SettingsService extends AbstractService implements ISettingsService {
    private ReloadableResourceBundleMessageSource messageSource;
    private static Logger logger = Logger.getLogger(SettingsService.class.getName());
    private InstallerService installerService = new InstallerService();

    public ServerResponse getSettings(ServerRequest sr, String lang) throws Exception {
        ServerResponse sa = new ServerResponse();
        try {
            if (ApplicationConstants.IS_DB_UPDATE_REQUIRED) {
                sa.resultingObject = installerService.getDbState();
                sa.result = ApplicationConstants.DB_FAILURE;
                return sa;

            } else {
                Settings settings = new Settings();
                settings.installationId = sr.installationId;
                String url = FlexContext.getHttpRequest().getRequestURL().toString().split(
                        FlexContext.getHttpRequest().getRequestURI())[0] +
                        FlexContext.getHttpRequest().getContextPath() + "/show_ads.js";
                settings.adTag = getTemplatesManagementService().getAdTag(url);
                settings.maxBannerFileSize = getStateManagementService().getMaxBannerFileSize();
                settings.maxLogoFileSize = getStateManagementService().getMaxLogoFileSize();
                settings.countries = getStateManagementService().updateCountries();
                settings.languages = getStateManagementService().updateLanguages();
                sa.resultingObject = settings;
                sa.result = ApplicationConstants.SUCCESS;
                return sa;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            return sa;
        }
    }

    public ServerResponse getBalance(ServerRequest sr, String lang) throws Exception {
        ServerResponse sa = new ServerResponse();
        try {
            ReportCriteria reportRequest = new ReportCriteria();
            reportRequest.setType(ApplicationConstants.WHOLE_SYSTEM_ENTITY_LEVEL);
            reportRequest.setPrecision(ApplicationConstants.NONE_PRECISION);
            List<ReportsRow> result = getReportManagementService().loadReport(reportRequest);
            Double totalSpent = 0.0;
            if (result.size() > 0) {
                Integer views = result.get(0).getViews();
                totalSpent = views * ApplicationConstants.PRICE_ONE_VIEW;
            }

            List<Integer> payments = getSettingsManagementService().getPayments();
            Integer amountPayments = 0;
            for (Integer paid : payments) {
                amountPayments = amountPayments + paid;
            }

            Double balance = Math.round((amountPayments - totalSpent) * 100) / 100.0;

            sa.resultingObject = balance;
            sa.result = ApplicationConstants.SUCCESS;
            return sa;
        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            return sa;
        }
    }


    public ServerResponse createDb(ServerRequest sr, String lang, Integer dbCount, String dbLogin, String dbPassword) throws Exception {
        ServerResponse sa = new ServerResponse();
        try {
            installerService.createDb(dbCount, dbLogin, dbPassword);
            ApplicationConstants.DATABASE_COUNT = dbCount;
            ApplicationConstants.IS_DB_UPDATE_REQUIRED = false;
            sa.result = ApplicationConstants.SUCCESS;
            return sa;
        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage(),e);
            sa.result = ApplicationConstants.FAILURE;
            return sa;
        }
    }


    public ReloadableResourceBundleMessageSource getMessageSource() {
        return messageSource;
    }

    public void setMessageSource(ReloadableResourceBundleMessageSource messageSource) {
        this.messageSource = messageSource;
    }

}

