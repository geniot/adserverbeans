package com.adserversoft.flexfuse.server.api;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 * Author: Vladimir Budanov
 * Email: budanov.vladimir@gmail.com
 * Date: 08.02.2011
 * Time: 16:46:08
 */
public class IpPattern extends BaseEntity {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private String ipPattern;

    @Column(name = "ip_from")
    private long ipFrom;

    @Column(name = "ip_to")
    private long ipTo;

    @Column(name = "banner_uid")
    private String bannerUid;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getIpPattern() {
        return ipPattern;
    }

    public void setIpPattern(String ipPattern) {
        this.ipPattern = ipPattern;
    }

    public String getBannerUid() {
        return bannerUid;
    }

    public void setBannerUid(String bannerUid) {
        this.bannerUid = bannerUid;
    }

    public long getIpTo() {
        return ipTo;
    }

    public void setIpTo(long ipTo) {
        this.ipTo = ipTo;
    }

    public long getIpFrom() {
        return ipFrom;
    }

    public void setIpFrom(long ipFrom) {
        this.ipFrom = ipFrom;
    }

    public void setToAndFromIp() {
        String[] addrArray = ipPattern.split("\\.");
        boolean mask = false;
        long[] num = new long[2];

        for (int i = 0; i < addrArray.length; i++) {
            int power = 3 - i;
            if (addrArray[i].equals("*") || mask) {
                mask = true;
                num[0] += ((Integer.parseInt("0") % 256 * Math.pow(256, power)));
                num[1] += ((Integer.parseInt("255") % 256 * Math.pow(256, power)));
            } else {
                num[0] += ((Integer.parseInt(addrArray[i]) % 256 * Math.pow(256, power)));
                num[1] += ((Integer.parseInt(addrArray[i]) % 256 * Math.pow(256, power)));
            }
        }
        setIpFrom(num[0]);
        setIpTo(num[1]);

    }

    public void setIpPatternFromAndToIp() {
        long[] num = new long[2];
        num[0] = getIpFrom();
        num[1] = getIpTo();
        String ip = intToIp(num);
        setIpPattern(ip);
    }

    public static String intToIp(long i) {
        return ((i >> 24) & 0xFF) + "." +
                ((i >> 16) & 0xFF) + "." +
                ((i >> 8) & 0xFF) + "." +
                (i & 0xFF);
    }

    public static String intToIp(long[] num) {
        String fIp = intToIp(num[0]);
        String sIp = intToIp(num[1]);
        if (fIp.equals(sIp)) return fIp;
        String result = new String();
        boolean mask = false;
        String[] fIpArray = fIp.split("\\.");
        String[] sIpArray = sIp.split("\\.");

        for (int i = 0; i < 4; i++) {
            if (!fIpArray[i].equals(sIpArray[i]) || mask) {
                result += "*";
            } else {
                result += fIpArray[i];
            }
            if (i != 3) {
                result += ".";
            }
        }
        return result;
    }
}
