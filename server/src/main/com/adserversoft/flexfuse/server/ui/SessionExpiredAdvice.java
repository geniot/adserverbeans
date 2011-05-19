package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ui.ISessionService;
import com.adserversoft.flexfuse.server.api.ui.INoLogin;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.api.ui.ServerResponse;
import com.adserversoft.flexfuse.server.api.ui.UserSession;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.springframework.web.context.ContextLoaderListener;

import java.lang.annotation.Annotation;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class SessionExpiredAdvice implements MethodInterceptor {
    private ISessionService sessionService;


    @Override
    public Object invoke(MethodInvocation methodInvocation) throws Throwable {
        //all guest methods are marked with INoLogin
        Annotation[] annotations = methodInvocation.getMethod().getDeclaredAnnotations();
        for (Annotation an : annotations) {
            if (an instanceof INoLogin) {
                Object rval = methodInvocation.proceed();
                return rval;
            }
        }

        Object[] args = methodInvocation.getArguments();
        ServerRequest serverRequest = (ServerRequest) args[0];
//        sessionService = (ISessionService) ContextLoaderListener.getCurrentWebApplicationContext().getBean("sessionService");
        UserSession us = sessionService.get(serverRequest.sessionId);

        if (us != null && us.userId != null) {//user is logged in
            us.lastAccess = System.currentTimeMillis();
            Object rval = methodInvocation.proceed();
            return rval;
        } else { //user session has expired
            ServerResponse sa = new ServerResponse();
            sa.message = ApplicationConstants.SESSION_EXPIRED;
            sa.result = ApplicationConstants.FAILURE;
            return sa;
        }


    }

    public ISessionService getSessionService() {
        return sessionService;
    }

    public void setSessionService(ISessionService sessionService) {
        this.sessionService = sessionService;
    }
}
