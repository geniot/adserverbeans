package com.adserversoft.flexfuse.server.api.ui;

import com.adserversoft.flexfuse.server.api.State;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public interface IStateService {
    ServerResponse saveState(ServerRequest sr, State state);

    ServerResponse loadState(ServerRequest se);

    ServerResponse loadTrashState(ServerRequest se);
}
