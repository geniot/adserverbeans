package com.adserversoft.flexfuse.server.api.dao;

import com.adserversoft.flexfuse.server.api.AdPlace;
import com.adserversoft.flexfuse.server.api.TrashedObject;

import java.util.List;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * Time: 17.33.48
 * http://www.adserversoft.com
 */
public interface IAdPlaceDAO {
    public void removeAdPlacesExcept(List<AdPlace> adPlaces);

    public void saveOrUpdateAdPlaces(List<AdPlace> adPlaces) throws Exception;

    public List<AdPlace> getAdPlaces() throws Exception;

    public AdPlace getAdPlaceByUid(String uid) throws Exception;

    public List<TrashedObject> getTrashedAdPlaces() throws Exception;

    public List<String> getNotRemovedAdPlaceUids() throws Exception;

    public String getAdPlaceUidById(String s) throws Exception;
}