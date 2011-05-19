package com.adserversoft.flexfuse.server.api;

/**
 * Author: Vladimir Budanov
 * Email: budanov.vladimir@gmail.com
 * Date: 21.02.2011
 * Time: 15:04:20
 */
public class TrashedObject extends BaseEntity {
    private String uid;
    private String name;
    private Boolean type;
    private Integer clicks;
    private Integer views;

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getViews() {
        return views;
    }

    public void setViews(Integer views) {
        this.views = views;
    }

    public Integer getClicks() {
        return clicks;
    }

    public void setClicks(Integer clicks) {
        this.clicks = clicks;
    }

    public Boolean getType() {
        return type;
    }

    public void setType(Boolean type) {
        this.type = type;
    }
}
