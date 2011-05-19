package com.adserversoft.flexfuse.server.api.service;


import com.adserversoft.flexfuse.server.api.User;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;

/**
 * Author: Dmitrii Lemeshevsky
 * 22.02.2010 15:09:01
 */
public interface IMailManagementService {

    public String getPasswordResetEmailContent(User currentUser);

    public void sendEmail(String emailText, String emailSubject, String emailAddress, User currentUser) throws Exception;


}
