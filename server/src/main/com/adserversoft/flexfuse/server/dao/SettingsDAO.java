package com.adserversoft.flexfuse.server.dao;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.VirtualInstallation;
import com.adserversoft.flexfuse.server.api.dao.ISettingsDAO;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.support.JdbcDaoSupport;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class SettingsDAO extends AbstractDAO implements ISettingsDAO {

    @Override
    public VirtualInstallation getVirtualInstallationByGlobalId(int globalId) {
        return null;
    }

    public List<Integer> getPayments() throws Exception {
        try {
            List<Integer> payments = new ArrayList<Integer>();
            String sql = "select amount from payments";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql);

            for (Map row : rows) {
                Integer paid = (Integer) row.get("amount");
                payments.add(paid);
            }
            return payments;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }


    public String getLastChange(String lastChangeSet) throws Exception {
        try {
            String lastChange = ApplicationConstants.DATABASE_DEPRECATED;
            String sql = "select FILENAME from DATABASECHANGELOG where FILENAME = ?";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql, new Object[]{lastChangeSet});

            for (Map row : rows) {
                lastChange = (String) row.get("FILENAME");
            }
            return lastChange;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }


}
