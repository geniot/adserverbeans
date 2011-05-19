package com.adserversoft.flexfuse.server.api.ui;

import com.adserversoft.flexfuse.server.api.User;

/**
 * Author: Dmitrii Lemeshevsky
 * 13.7.2010 11.19.26
 */
public interface IUserService {

    @INoLogin
    public ServerResponse create(ServerRequest sr, User user);

    public ServerResponse read(ServerRequest sr, Integer id);

    public ServerResponse update(ServerRequest sr, User user);

    public ServerResponse getList(ServerRequest sr);

    @INoLogin
    public ServerResponse logoutUser(ServerRequest sr, User user);

    @INoLogin
    public ServerResponse loginUser(ServerRequest sr, User user);

    @INoLogin
    public ServerResponse resetPassword(ServerRequest sr, String username, String password) throws Exception;

    @INoLogin
    public ServerResponse remindPassword(ServerRequest sr, final String email) throws Exception;

    @INoLogin
    public ServerResponse verifyRemindPassword(ServerRequest sr, String resetPassword, Integer id);

    public ServerResponse updateSettings(ServerRequest sr, User user, Boolean isNewLogo) throws Exception;

    @INoLogin
    public ServerResponse remindEmail(ServerRequest sr, final String firstName, final String lastName) throws Exception;
}
