package com.adserversoft.flexfuse.server.api.ui;

import com.adserversoft.flexfuse.server.api.AdFormat;
import com.adserversoft.flexfuse.server.api.Country;
import com.adserversoft.flexfuse.server.api.Language;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class Settings implements Serializable {
    public SortedSet<AdFormat> adFormats;

    public List<Country> countries = new ArrayList<Country>();
    public List<Language> languages = new ArrayList<Language>();
    //public int installationId;
    public String sessionId;
    public String[] adTag;
    public int installationId;
    public Integer maxLogoFileSize;
    public Integer maxBannerFileSize;

    public SortedSet<AdFormat> getAdFormats() {
        return adFormats;
    }

    public void setAdFormats(SortedSet<AdFormat> adFormats) {
        this.adFormats = adFormats;
    }

    public String getSessionId() {
        return sessionId;
    }


    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public int getInstallationId() {
        return installationId;
    }

    public void setInstallationId(int installationId) {
        this.installationId = installationId;
    }

    public String[] getAdTag() {
        return adTag;
    }

    public void setAdTag(String[] adTag) {
        this.adTag = adTag;
    }

    public Integer getMaxLogoFileSize() {
        return maxLogoFileSize;
    }

    public void setMaxLogoFileSize(Integer maxLogoFileSize) {
        this.maxLogoFileSize = maxLogoFileSize;
    }

    public Integer getMaxBannerFileSize() {
        return maxBannerFileSize;
    }

    public void setMaxBannerFileSize(Integer maxBannerFileSize) {
        this.maxBannerFileSize = maxBannerFileSize;
    }

    public List<Country> getCountries() {
        return countries;
    }

    public void setCountries(List<Country> countries) {
        this.countries = countries;
    }

    public List<Language> getLanguages() {
        return languages;
    }

    public void setLanguages(List<Language> languages) {
        this.languages = languages;
    }
}