package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.api.ui.ServerResponse;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class VersionExpiredAdvice implements MethodInterceptor {

    @Override
    public Object invoke(MethodInvocation methodInvocation) throws Throwable {
        Object[] args = methodInvocation.getArguments();
        String version = ((ServerRequest) args[0]).version;
        if (!version.equals(ApplicationConstants.VERSION)) {
            ServerResponse sa = new ServerResponse();
            sa.message = ApplicationConstants.VERSION_EXPIRED;
            sa.result = ApplicationConstants.FAILURE;
            return sa;
        } else {
            Object rval = methodInvocation.proceed();
            return rval;
        }
    }

}