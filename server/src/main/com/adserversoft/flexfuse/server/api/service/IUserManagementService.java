package com.adserversoft.flexfuse.server.api.service;

import com.adserversoft.flexfuse.server.api.User;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import org.apache.commons.fileupload.FileItem;

import java.util.List;

/**
 * Author: Dmitrii Lemeshevsky
 * 13.7.2010 11.22.44
 */
public interface    IUserManagementService {

    public User read(Integer id) throws Exception;

    public void create(User u) throws Exception;

    public void update(User u) throws Exception;

    public User login(User user) throws Exception;

    public List<User> getList() throws Exception;

    public void updateRemindPasswordUser(String email) throws Exception;

    public User updateResetPasswordUser(String username, String password) throws Exception;

    public User verifyRemindPassword(String resetPassword, Integer id) throws Exception;

    public void updateLogoInDB(Integer id, byte[] bbs, String filename);

    byte[] getLogo();
    
    public void updateSettings(User user, String url, byte[] bbs, String filename) throws Exception;

    public User updateRemindEmail(String firstName, String lastName) throws Exception;

}
