package com.adserversoft.flexfuse.server.api.dao;

import com.adserversoft.flexfuse.server.api.User;

import java.util.List;

/**
 * Author: Dmitrii Lemeshevsky
 * 13.7.2010 11.24.48
 */
public interface IUserDAO {

    public void create(User u) throws Exception;

    public User getUserById(Integer id) throws Exception;

    public User getUserByEmail(String email) throws Exception;

    public User getUserByNames(String firstName, String lastName) throws Exception;

    public List<User> getList();

    public void updateLogo(User user);

    public void update(User user) throws Exception;

    public void updateSettingsExceptPassword(User user) throws Exception;


}
