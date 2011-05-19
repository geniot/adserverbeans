package com.adserversoft.flexfuse.server.api.dao;

import com.adserversoft.flexfuse.server.api.Country;

import java.util.List;

/**
 * User: Lemeshevsky D.
 * Date: 17.08.2010
 */
public interface IGeoTargetingDAO {
    public List<Country> getCountries() throws Exception;

    void updateCSV() throws Exception;
}