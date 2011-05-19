package com.adserversoft.flexfuse.server.api.ui;

import com.adserversoft.flexfuse.server.api.AdFormat;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;

import java.util.SortedSet;
import java.util.List;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public interface ISettingsManagementService {

   List<Integer> getPayments() throws Exception;
}
