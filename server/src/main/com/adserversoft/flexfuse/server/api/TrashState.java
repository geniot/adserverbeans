package com.adserversoft.flexfuse.server.api;

import java.io.Serializable;
import java.util.List;

/**
 * Author: Vladimir Budanov
 * Email: budanov.vladimir@gmail.com
 */
public class TrashState implements Serializable {

    private List<TrashedObject> trashedObjects;

    public List<TrashedObject> getTrashedObjects() {
        return trashedObjects;
    }

    public void setTrashedObjects(List<TrashedObject> trashedObjects) {
        this.trashedObjects = trashedObjects;
    }
}