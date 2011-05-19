package com.adserversoft.flexfuse.server.api.dao;

import com.adserversoft.flexfuse.server.api.VirtualInstallation;

import java.util.List;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public interface ISettingsDAO {
    public VirtualInstallation getVirtualInstallationByGlobalId(int globalId);

    public List<Integer> getPayments() throws Exception;

    public String getLastChange(String lastChangeSet) throws Exception;
    
}
