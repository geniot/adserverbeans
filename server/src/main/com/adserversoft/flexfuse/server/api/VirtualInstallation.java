package com.adserversoft.flexfuse.server.api;

import java.io.Serializable;

public class VirtualInstallation implements Serializable {
    private String installationName;
    private Integer localId;
    private Integer globalId;


    public void setInstallationName(String installationName) {
        this.installationName = installationName;
    }

    public String getInstallationName() {
        return installationName;
    }

    public void setLocalId(Integer localId) {
        this.localId = localId;
    }

    public int getLocalId() {
        return localId;
    }

    public Integer getGlobalId() {
        return globalId;
    }

    public void setGlobalId(Integer globalId) {
        this.globalId = globalId;
    }
}
