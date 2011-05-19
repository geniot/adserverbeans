package com.adserversoft.flexfuse.server.api.dao;

import com.adserversoft.flexfuse.server.api.AdFormat;
import com.adserversoft.flexfuse.server.api.State;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;

import java.util.List;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public interface IStateDAO {
    public void saveState(ServerRequest sr, State obj);

}
