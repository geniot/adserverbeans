package com.adserversoft.flexfuse.server.dao;

import com.adserversoft.flexfuse.server.api.*;
import com.adserversoft.flexfuse.server.api.dao.IAdPlaceDAO;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Dmitrii Lemeshevsky
 * 26.7.2010 12.12.31
 */
public class AdPlaceDAO extends AbstractDAO implements IAdPlaceDAO {
    static Logger logger = Logger.getLogger(AdPlaceDAO.class.getName());

    @Override
    public void removeAdPlacesExcept(List<AdPlace> adPlaces) {
        if (adPlaces.size() == 0) {
            this.getJdbcTemplate().update("update ad_place set ad_place_state=" + ApplicationConstants.STATE_REMOVED + ";");
            return;
        }
        String mass_uid = ApplicationConstants.concatenateAdPlaceUidsForIn(adPlaces);
        String sql = "update ad_place set ad_place_state=" + ApplicationConstants.STATE_REMOVED + " where uid not in(" + mass_uid + ")";
        this.getJdbcTemplate().update(sql);
    }

    @Override
    public String getAdPlaceUidById(String s) throws Exception {
        AdPlace adPlace;
        try {
            adPlace = (AdPlace) this.getJdbcTemplate().queryForObject(
                    "select uid from ad_place where id = ?",
                    new Object[]{s},
                    new RowMapper() {
                        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                            AdPlace banner = new AdPlace();
                            try {
                                banner.mergePropertiesFromResultSet(rs);
                            } catch (Exception e) {
                                logger.log(Level.SEVERE, e.getMessage(), e);
                            }
                            return banner;
                        }
                    });
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
        return adPlace.getUid();
    }

    @Override
    public void saveOrUpdateAdPlaces(List<AdPlace> adPlaces) throws Exception {
        for (int i = 0; i < adPlaces.size(); i++) {
            AdPlace adPlace = adPlaces.get(i);
            SortedMap<String, Object> m = adPlace.getFieldsMapExcept(new String[]{"id"});

            List parameters = new ArrayList();
            parameters.addAll(m.values());
            parameters.addAll(m.values());

            String sql = "insert into ad_place (" + ApplicationConstants.getColumnNames(m) + ") values (" + ApplicationConstants.generatePlaceHolders(m) + ") " + "ON DUPLICATE KEY UPDATE " + ApplicationConstants.generateParametrizedColumnNames(m) + ";";
            this.getJdbcTemplate().update(sql, parameters.toArray());
        }
    }

    @Override
    public List<AdPlace> getAdPlaces() throws Exception {
        try {
            List<AdPlace> adPlaces = new ArrayList<AdPlace>();
            SortedMap<String, Object> m = new AdPlace().getFieldsMapExcept(new String[]{});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from ad_place where ad_place_state != ?";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql, new Object[]{ApplicationConstants.STATE_REMOVED});

            for (Map row : rows) {
                AdPlace adPlace = new AdPlace();
                try {
                    adPlace.mergePropertiesFromResultRow(row);
                } catch (Exception e) {
                    logger.log(Level.SEVERE, e.getMessage(), e);
                }
                adPlaces.add(adPlace);
            }
            return adPlaces;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public List<TrashedObject> getTrashedAdPlaces() throws Exception {
        ReportCriteria reportRequest = new ReportCriteria();
        reportRequest.setAdPlaceUids(new ArrayList<String>());
        reportRequest.setType(ApplicationConstants.AD_PLACE_ENTITY_LEVEL);
        reportRequest.setPrecision(ApplicationConstants.NONE_PRECISION);
        try {

            Map<String, TrashedObject> adPlaces = new HashMap<String, TrashedObject>();
            SortedMap<String, Object> m = new AdPlace().getFieldsMapByName(new String[]{"uid", "adPlaceName"});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from ad_place where ad_place_state = ?";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql, new Object[]{ApplicationConstants.STATE_REMOVED});

            for (Map row : rows) {
                AdPlace adPlace = new AdPlace();
                adPlace.mergePropertiesFromResultRow(row);
                TrashedObject tAdPlace = new TrashedObject();
                tAdPlace.setType(false);
                tAdPlace.setUid(adPlace.getUid());
                tAdPlace.setName(adPlace.getAdPlaceName());
                adPlaces.put(tAdPlace.getUid(), tAdPlace);
                reportRequest.getAdPlaceUids().add(adPlace.getUid());
            }

            List<ReportsRow> report = getReportDAO().getReport(reportRequest);
            for (ReportsRow rr : report) {
                adPlaces.get(rr.getAdPlaceUid()).setClicks(rr.getClicks());
                adPlaces.get(rr.getAdPlaceUid()).setViews(rr.getViews());
            }
            return new ArrayList<TrashedObject>(adPlaces.values());
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public List<String> getNotRemovedAdPlaceUids() throws Exception {
        try {
            List<String> adPlaceUids = new ArrayList<String>();
            String sql = "select uid from ad_place where ad_place_state != ?";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql, new Object[]{ApplicationConstants.STATE_REMOVED});

            for (Map row : rows) {
                AdPlace adPlace = new AdPlace();
                try {
                    adPlace.mergePropertiesFromResultRow(row);
                } catch (Exception e) {
                    logger.log(Level.SEVERE, e.getMessage(), e);
                }
                adPlaceUids.add(adPlace.getUid());
            }
            return adPlaceUids;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public AdPlace getAdPlaceByUid(String uid) throws Exception {
        AdPlace adPlace;
        SortedMap<String, Object> m = new AdPlace().getFieldsMapExcept(new String[]{});
        try {
            adPlace = (AdPlace) this.getJdbcTemplate().queryForObject(
                    "select " + ApplicationConstants.getColumnNames(m) + " from ad_place where uid = ?",
                    new Object[]{uid},
                    new RowMapper() {
                        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                            AdPlace adPlace = new AdPlace();
                            try {
                                adPlace.mergePropertiesFromResultSet(rs);
                            } catch (Exception e) {
                                logger.log(Level.SEVERE, e.getMessage(), e);
                            }
                            return adPlace;
                        }
                    });
        } catch (EmptyResultDataAccessException e) {
            adPlace = null;
        }
        return adPlace;
    }

}