package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.ui.ISettingsManagementService;

import java.util.List;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class SettingsManagementService  extends AbstractManagementService implements ISettingsManagementService {


   public List<Integer> getPayments() throws Exception{
       return getSettingsDAO().getPayments();
   }
}
