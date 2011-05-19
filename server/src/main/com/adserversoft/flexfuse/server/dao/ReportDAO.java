package com.adserversoft.flexfuse.server.dao;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ReportCriteria;
import com.adserversoft.flexfuse.server.api.ReportsRow;
import com.adserversoft.flexfuse.server.api.dao.IReportDAO;
import org.springframework.dao.EmptyResultDataAccessException;

import java.util.*;
import java.util.logging.Logger;

public class ReportDAO extends AbstractDAO implements IReportDAO {
    static Logger logger = Logger.getLogger(ReportDAO.class.getName());

    @Override
    public List<ReportsRow> getReport(ReportCriteria reportCriteria) throws Exception {
        GetReportStoredProcedure storedProcedure = new GetReportStoredProcedure(getDataSource());
        Map inParameters = new HashMap();
        inParameters.put("type_in", reportCriteria.getType());
        inParameters.put("from_date_time_in", reportCriteria.getFromDate());
        inParameters.put("to_date_time_in", reportCriteria.getToDate());
        inParameters.put("precision_in", reportCriteria.getPrecision());
        String uids = "";
        switch (reportCriteria.getType().byteValue()) {
            case ApplicationConstants.BANNER_ENTITY_LEVEL:
                uids = listUidsToString(reportCriteria.getBannerUids());
                break;
            case ApplicationConstants.AD_PLACE_ENTITY_LEVEL:
                uids = listUidsToString(reportCriteria.getAdPlaceUids());
                break;
            case ApplicationConstants.BANNER_X_AD_PLACE_ENTITY_LEVEL:
                uids = listUidsToString(reportCriteria.getBannerUidByAdPlaceUids());
                break;
        }
        inParameters.put("uids_in", uids);
        Map results = storedProcedure.execute(inParameters);
        return addResultSet((ArrayList<Map>) results.get("#result-set-1"), reportCriteria.getType());
    }

    private List<ReportsRow> addResultSet(ArrayList<Map> resultSet, Integer type) throws Exception {
        try {
            List<ReportsRow> reportRowsList = new ArrayList<ReportsRow>();
            for (Map row : resultSet) {
                ReportsRow reportsRow = new ReportsRow();
                String entityKey = (String) row.get("entity_key");
                entityKey = entityKey.substring(entityKey.indexOf(":") + 1, entityKey.indexOf("("));

                switch (type.byteValue()) {
                    case ApplicationConstants.BANNER_ENTITY_LEVEL:
                        reportsRow.setBannerUid(getBannerDAO().getBannerUidById(entityKey));
                        reportsRow.setAdPlaceUid(null);
                        break;
                    case ApplicationConstants.AD_PLACE_ENTITY_LEVEL:
                        reportsRow.setBannerUid(null);
                        reportsRow.setAdPlaceUid(getAdPlaceDAO().getAdPlaceUidById(entityKey));
                        break;
                    case ApplicationConstants.BANNER_X_AD_PLACE_ENTITY_LEVEL:
                        reportsRow.setBannerUid(getBannerDAO().getBannerUidById(entityKey.substring(0, entityKey.indexOf("x"))));
                        reportsRow.setAdPlaceUid(getAdPlaceDAO().getAdPlaceUidById(entityKey.substring(entityKey.indexOf("x") + 1)));
                        break;
                }
                parseResultSet(row, reportsRow);
                reportRowsList.add(reportsRow);
            }
            return reportRowsList;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    private void parseResultSet(Map row, ReportsRow reportsRow) {
        reportsRow.setViews((Integer) row.get("views"));
        reportsRow.setClicks((Integer) row.get("clicks"));

        Calendar reportDateCalendar = Calendar.getInstance();
        if (row.get("ts_year") != null) reportDateCalendar.set(Calendar.YEAR, (Integer) row.get("ts_year"));
        if (row.get("ts_month") != null) reportDateCalendar.set(Calendar.MONTH, (Integer) row.get("ts_month") - 1);
        if (row.get("ts_date") != null) reportDateCalendar.set(Calendar.DATE, (Integer) row.get("ts_date"));
        if (row.get("ts_hour") != null) reportDateCalendar.set(Calendar.HOUR_OF_DAY, (Integer) row.get("ts_hour"));

        reportsRow.setDate(reportDateCalendar.getTime());
    }

    private String listUidsToString(List<String> listUids) {
        String uids = "";
        for (String uid : listUids) {
            uids += uid + ";";
        }
        return uids.isEmpty() ?  "" : uids.substring(0, uids.length() - 1);
    }
}