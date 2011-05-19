package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Sets instId to this thread so it can be used by transaction manager to return the right session factory.
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class InstSetterAdvice implements MethodInterceptor {
    private static Logger logger = Logger.getLogger(InstSetterAdvice.class.getName());


    @Override
    public Object invoke(MethodInvocation methodInvocation) throws Throwable {
        Object[] args = methodInvocation.getArguments();
        try {
            int instId = ((ServerRequest) args[0]).installationId;
            InstallationContextHolder.setCustomerType(instId);
            Object rval = methodInvocation.proceed();
            return rval;
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage(), e);
        }
        return null;
    }

}