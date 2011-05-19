package com.adserversoft.flexfuse.server.api;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 * User: Lemeshevsky D.
 * Date: 24.08.2010
 * Time: 12:45:38
 */
public class Country extends BaseEntity {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    @Column(name = "country_abbr_small")
    private String countryAbbrSmall;
    @Column(name = "country_abbr")
    private String countryAbbr;
    @Column(name = "country_name")
    private String countryName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCountryAbbrSmall() {
        return countryAbbrSmall;
    }

    public void setCountryAbbrSmall(String countryAbbrSmall) {
        this.countryAbbrSmall = countryAbbrSmall;
    }

    public String getCountryAbbr() {
        return countryAbbr;
    }

    public void setCountryAbbr(String countryAbbr) {
        this.countryAbbr = countryAbbr;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }
}