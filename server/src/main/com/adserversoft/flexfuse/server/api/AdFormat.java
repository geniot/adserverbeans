package com.adserversoft.flexfuse.server.api;


import java.io.Serializable;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class AdFormat implements Serializable, Comparable {

    private Integer id;
    private String adFormatName;
    private int width;
    private int height;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAdFormatName() {
        return adFormatName;
    }

    public void setAdFormatName(String adFormatName) {
        this.adFormatName = adFormatName;
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public int compareTo(Object o) {
        if (o == null) return -1;
        if (!(o instanceof AdFormat)) return -1;
        if (this.hashCode() == o.hashCode()) return 0;
        AdFormat af = (AdFormat) o;
        return this.getAdFormatName().compareTo(af.getAdFormatName());
    }
}
