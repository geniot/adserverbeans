package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.User;
import com.adserversoft.flexfuse.server.api.ui.ISessionService;
import com.adserversoft.flexfuse.server.api.ui.IUserService;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.api.ui.ServerResponse;
import com.adserversoft.flexfuse.server.api.ui.UserSession;
import flex.messaging.FlexContext;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Dmitrii Lemeshevsky
 * 13.7.2010 11.52.53
 */
public class UserService extends AbstractService implements IUserService {
    static Logger logger = Logger.getLogger(UserService.class.getName());

    private ReloadableResourceBundleMessageSource messageSource;
    private ISessionService sessionService;

    @Override
    public ServerResponse create(ServerRequest sr, User user) {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");

        try {
            getUserManagementService().create(user);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }
        sa.result = ApplicationConstants.SUCCESS;
        sa.message = messageSource.getMessage("success.registration", null, locale);
        return sa;

    }

    @Override
    public ServerResponse read(ServerRequest sr, Integer id) {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            User l = getUserManagementService().read(id);
            sa.resultingObject = l;
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }
        sa.result = ApplicationConstants.SUCCESS;
        sa.message = messageSource.getMessage("success.registration", null, locale);
        return sa;
    }

    @Override
    public ServerResponse update(ServerRequest sr, User user) {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            getUserManagementService().update(user);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            if (ex.getMessage().equals("failure.notExists")) {
                sa.result = ApplicationConstants.USER_DELETED_BY_PEER;
            } else {
                sa.result = ApplicationConstants.FAILURE;
            }

            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }
        sa.result = ApplicationConstants.SUCCESS;
        sa.message = messageSource.getMessage("success.registration", null, locale);
        return sa;
    }


    @Override
    public ServerResponse getList(ServerRequest sr) {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            List<User> l = getUserManagementService().getList();
            sa.resultingObject = l;
            sa.result = ApplicationConstants.SUCCESS;
            sa.message = messageSource.getMessage("success.registration", null, locale);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        } finally {
            return sa;
        }
    }

    @Override
    public ServerResponse logoutUser(ServerRequest sr, User user) {
        ServerResponse sa = new ServerResponse();
        UserSession us = sessionService.get(sr.sessionId);
        if (us != null) {
            us.reset();
        }
        sa.result = ApplicationConstants.SUCCESS;
        return sa;
    }

    @Override
    public ServerResponse loginUser(ServerRequest sr, User user) {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            User currentUser = getUserManagementService().login(user);
            UserSession currentUserSession = sessionService.get(sr.sessionId);
            if (currentUserSession == null) {
                currentUserSession = new UserSession();
                logger.log(Level.FINE, "Logging in user without a guest session");
            }
            currentUserSession.locale = new Locale("en", "US");
            currentUserSession.lastAccess = System.currentTimeMillis();
            currentUserSession.sessionId = sessionService.getNewSessionId();
            currentUserSession.userId = currentUser.getId();
            sessionService.put(currentUserSession.sessionId, currentUserSession);
            currentUser.setSessionId(currentUserSession.sessionId);
            sa.result = ApplicationConstants.SUCCESS;
            sa.resultingObject = currentUser;
            return sa;
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }

    }

    public ServerResponse resetPassword(ServerRequest sr, String email, String password) throws Exception {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            User currentUser = getUserManagementService().updateResetPasswordUser(email, password);
            UserSession currentUserSession = sessionService.get(sr.sessionId);
            if (currentUserSession == null) {
                currentUserSession = new UserSession();
                logger.log(Level.FINE, "Logging in user without a guest session");
            }
            currentUserSession.locale = new Locale("en", "US");
            currentUserSession.lastAccess = System.currentTimeMillis();
            currentUserSession.email = currentUser.getEmail();
            currentUserSession.sessionId = sessionService.getNewSessionId();
            currentUserSession.userId = currentUser.getId();
            sessionService.put(currentUserSession.sessionId, currentUserSession);
            currentUser.setSessionId(currentUserSession.sessionId);
            sa.result = ApplicationConstants.SUCCESS;
            sa.resultingObject = currentUser;
            return sa;
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }
    }

    public ServerResponse remindPassword(ServerRequest sr, String email) throws Exception {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            getUserManagementService().updateRemindPasswordUser(email);
            sa.result = ApplicationConstants.SUCCESS;
            return sa;
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }
    }

    public ServerResponse verifyRemindPassword(ServerRequest sr, String resetPassword, Integer id) {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            User currentUser = getUserManagementService().verifyRemindPassword(resetPassword, id);

            sa.result = ApplicationConstants.RESET_PASSWORD_SUCCESS;
            sa.resultingObject = currentUser;
            return sa;
        }

        catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            if (ex.getMessage().equals("failure.userNotExists")) {
                sa.result = ApplicationConstants.USER_NOT_EXISTS;
            } else if (ex.getMessage().equals("failure.resetCodeIsOutdated")) {
                sa.result = ApplicationConstants.RESET_CODE_OUTDATED;
            } else if (ex.getMessage().equals("failure.resetCodeNotCorrect")) {
                sa.result = ApplicationConstants.RESET_CODE_NOT_CORRECT;
            } else {
                sa.result = ApplicationConstants.FAILURE;
            }
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }

    }

    @Override
    public ServerResponse updateSettings(ServerRequest sr, User user, Boolean isNewLogo) throws Exception {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            String adServerUrl = FlexContext.getHttpRequest().getRequestURL().toString().split(FlexContext.getHttpRequest().getRequestURI())[0];
            UserSession currentUserSession = sessionService.get(sr.sessionId);
            byte[] bbs = null;
            String filename = null;
            if (isNewLogo) {
                bbs = currentUserSession.logo;
                filename = currentUserSession.filename;
            }
            getUserManagementService().updateSettings(user, adServerUrl, bbs, filename);
            sa.result = ApplicationConstants.SUCCESS;
            return sa;
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }
    }

    public ServerResponse remindEmail(ServerRequest sr, String firstName, String lastName) throws Exception {
        ServerResponse sa = new ServerResponse();
        Locale locale = new Locale("en");
        try {
            User currentUser = getUserManagementService().updateRemindEmail(firstName, lastName);
            sa.result = ApplicationConstants.SUCCESS;
            sa.resultingObject = currentUser;
            return sa;
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
            sa.result = ApplicationConstants.FAILURE;
            sa.message = messageSource.getMessage(ex.getMessage(), null, locale);
            return sa;
        }
    }

    public ReloadableResourceBundleMessageSource getMessageSource() {
        return messageSource;
    }

    public void setMessageSource(ReloadableResourceBundleMessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public ISessionService getSessionService() {
        return sessionService;
    }

    public void setSessionService(ISessionService sessionService) {
        this.sessionService = sessionService;
    }
}
