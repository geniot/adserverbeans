package com.adserversoft.flexfuse.server.api.service;

import com.adserversoft.flexfuse.server.api.Country;
import com.adserversoft.flexfuse.server.api.Language;
import com.adserversoft.flexfuse.server.api.State;
import com.adserversoft.flexfuse.server.api.TrashState;

import java.util.List;


/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public interface IStateManagementService {

    public List<Country> updateCountries() throws Exception;

    public List<Language> updateLanguages() throws Exception;

    public void updateState(State st) throws Exception;

    public State loadState() throws Exception;

    public TrashState loadTrashState() throws Exception;

    Integer getMaxBannerFileSize();

    Integer getMaxLogoFileSize();
}
