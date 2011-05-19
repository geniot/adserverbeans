package com.adserversoft.flexfuse.server.api;

/**
 * User: Lemeshevsky D.
 * Date: 19.01.2011
 * Time: 14:54:30
 */
public class DataBaseState extends BaseEntity {


    private String dbName;
    private String dbState;

    public String getDbName() {
        return dbName;
    }

    public void setDbName(String dbName) {
        this.dbName = dbName;
    }

    public String getDbState() {
        return dbState;
    }

    public void setDbState(String dbState) {
        this.dbState = dbState;
    }
}
