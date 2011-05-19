package com.adserversoft.flexfuse.server.dao;

import org.springframework.util.Assert;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class InstallationContextHolder {

    private static final ThreadLocal<Integer> contextHolder = new ThreadLocal<Integer>();

    public static void setCustomerType(int instId) {
        contextHolder.set(instId);
    }

    public static Integer getCustomerType() {
        return (Integer) contextHolder.get();
    }

    public static void clearCustomerType() {
        contextHolder.remove();
    }
}

