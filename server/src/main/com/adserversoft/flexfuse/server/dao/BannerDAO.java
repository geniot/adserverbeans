package com.adserversoft.flexfuse.server.dao;

import com.adserversoft.flexfuse.server.api.*;
import com.adserversoft.flexfuse.server.api.dao.IBannerDAO;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class BannerDAO extends AbstractDAO implements IBannerDAO {
    static Logger logger = Logger.getLogger(BannerDAO.class.getName());

    @Override
    public NextBannerProcResult getNextBanner(final String adPlaceUid,
                                              Date nowTimestamp,
                                              Long ip,
                                              String uniqueUid,
                                              int currentBrowser,
                                              int os,
                                              String language,
                                              String bannerUrl,
                                              String referrer,
                                              String pageLoadId,
                                              String dynamicParameters) throws Exception {

        GetBannerStoredProcedure msp = new GetBannerStoredProcedure(getDataSource());
        Map inParameters = new HashMap();
        inParameters.put("ad_place_uid", adPlaceUid);
        inParameters.put("now_date_time", nowTimestamp);
        inParameters.put("ip", ip);
        inParameters.put("unique_uid_in", uniqueUid);
        inParameters.put("time_stamp_long_in", nowTimestamp.getTime());
        inParameters.put("browser", currentBrowser);
        inParameters.put("os_in", os);
        inParameters.put("language_in", language);
        inParameters.put("banner_url", bannerUrl.length() > 255 ? bannerUrl.substring(0, 255) : bannerUrl);
        inParameters.put("referrer_in", referrer.length() > 255 ? referrer.substring(0, 255) : referrer);
        inParameters.put("page_load_id", pageLoadId);
        inParameters.put("dynamic_parameters_in", dynamicParameters);

        Map results = msp.execute(inParameters);
        NextBannerProcResult gnbp = new NextBannerProcResult();
        try {
            gnbp.setBannerUid((String) results.get("banner_uid"));
            gnbp.setAdFormatId((Integer) results.get("ad_format_id"));
            gnbp.setBannerContentTypeId((Integer) results.get("banner_content_type_id"));
            gnbp.setUniqueUid((String) results.get("unique_uid_out"));
            gnbp.setFrameTargeting((Boolean) results.get("frame_targeting"));
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }
        return gnbp;
    }


    @Override
    public void removeBannersExcept(List<Banner> banners) throws Exception {
        if (banners.size() == 0) {
            this.getJdbcTemplate().update("update banner set banner_state=?;", ApplicationConstants.STATE_REMOVED);
            return;
        }
        String paramPlaceHolders = ApplicationConstants.generatePlaceHolders(banners);
        List l = new ArrayList();
        l.add(ApplicationConstants.STATE_REMOVED);
        for (Banner b : banners) {
            l.add(b.getUid());
        }
        this.getJdbcTemplate().update("update banner set banner_state=? where uid not in (" + paramPlaceHolders + ");", l.toArray());
    }


    @Override
    public void saveOrUpdateBanners(List<Banner> banners) throws Exception {
        for (int i = 0; i < banners.size(); i++) {
            Banner b = banners.get(i);
            SortedMap<String, Object> m = b.getFieldsMapExcept(b.getContent() == null ?
                    new String[]{"id"} : new String[]{"id"});

            List parameters = new ArrayList();
            parameters.addAll(m.values());
            parameters.addAll(m.values());

            String sql = "INSERT INTO banner (" + ApplicationConstants.getColumnNames(m) + ") " +
                    "VALUES (" + ApplicationConstants.generatePlaceHolders(m) + ") " +
                    "ON DUPLICATE KEY UPDATE " + ApplicationConstants.generateParametrizedColumnNames(m) + ";";

            this.getJdbcTemplate().update(sql, parameters.toArray());
        }
    }

    @Override
    public void removeUrlPatternsExcept() throws Exception {
        this.getJdbcTemplate().update("delete from url_patterns;");
    }

    @Override
    public void removeReferrerPatternsExcept() throws Exception {
        this.getJdbcTemplate().update("delete from referrer_patterns;");
    }

    @Override
    public void removeDynamicParametersExcept() throws Exception {
        this.getJdbcTemplate().update("delete from dynamic_parameters;");
    }

    @Override
    public void removeIpPatternsExcept() throws Exception {
        this.getJdbcTemplate().update("delete from ip_patterns;");
    }

    @Override
    public void saveOrUpdateUrlPatterns(List<UrlPattern> urlPatterns) throws Exception {
        for (int i = 0; i < urlPatterns.size(); i++) {
            UrlPattern currentPattern = urlPatterns.get(i);
            SortedMap<String, Object> m = currentPattern.getFieldsMapExcept(new String[]{"id"});

            List parameters = new ArrayList();
            parameters.addAll(m.values());
            parameters.addAll(m.values());

            String sql = "INSERT INTO url_patterns (" + ApplicationConstants.getColumnNames(m) + ") " +
                    "VALUES (" + ApplicationConstants.generatePlaceHolders(m) + ") " +
                    "ON DUPLICATE KEY UPDATE " + ApplicationConstants.generateParametrizedColumnNames(m) + ";";

            this.getJdbcTemplate().update(sql, parameters.toArray());
        }
    }

    @Override
    public void saveOrUpdateReferrerPatterns(List<ReferrerPattern> referrerPatterns) throws Exception {
        for (int i = 0; i < referrerPatterns.size(); i++) {
            ReferrerPattern currentPattern = referrerPatterns.get(i);
            SortedMap<String, Object> m = currentPattern.getFieldsMapExcept(new String[]{"id"});

            List parameters = new ArrayList();
            parameters.addAll(m.values());
            parameters.addAll(m.values());

            String sql = "INSERT INTO referrer_patterns (" + ApplicationConstants.getColumnNames(m) + ") " +
                    "VALUES (" + ApplicationConstants.generatePlaceHolders(m) + ") " +
                    "ON DUPLICATE KEY UPDATE " + ApplicationConstants.generateParametrizedColumnNames(m) + ";";

            this.getJdbcTemplate().update(sql, parameters.toArray());
        }
    }

    @Override
    public void saveOrUpdateDynamicParameters(List<DynamicParameter> dynamicParameters) throws Exception {
        for (int i = 0; i < dynamicParameters.size(); i++) {
            DynamicParameter currentTargeting = dynamicParameters.get(i);
            SortedMap<String, Object> m = currentTargeting.getFieldsMapExcept(new String[]{"id"});

            List parameters = new ArrayList();
            parameters.addAll(m.values());
            parameters.addAll(m.values());

            String sql = "INSERT INTO dynamic_parameters (" + ApplicationConstants.getColumnNames(m) + ") " +
                    "VALUES (" + ApplicationConstants.generatePlaceHolders(m) + ") " +
                    "ON DUPLICATE KEY UPDATE " + ApplicationConstants.generateParametrizedColumnNames(m) + ";";

            this.getJdbcTemplate().update(sql, parameters.toArray());
        }
    }

    @Override
    public void saveOrUpdateIpPatterns(List<IpPattern> ipPatterns) throws Exception {
        for (int i = 0; i < ipPatterns.size(); i++) {
            IpPattern currentIpPatten = ipPatterns.get(i);
            currentIpPatten.setToAndFromIp();
            SortedMap<String, Object> m = currentIpPatten.getFieldsMapExcept(new String[]{"id"});

            List parameters = new ArrayList();
            parameters.addAll(m.values());
            parameters.addAll(m.values());

            String sql = "INSERT INTO ip_patterns (" + ApplicationConstants.getColumnNames(m) + ") " +
                    "VALUES (" + ApplicationConstants.generatePlaceHolders(m) + ") " +
                    "ON DUPLICATE KEY UPDATE " + ApplicationConstants.generateParametrizedColumnNames(m) + ";";

            this.getJdbcTemplate().update(sql, parameters.toArray());
        }
    }


    @Override
    public Banner getBannerByUid(String uid) throws Exception {
        Banner banner;
        SortedMap<String, Object> m = new Banner().getFieldsMapExcept(new String[]{});
        try {
            banner = (Banner) this.getJdbcTemplate().queryForObject(
                    "select " + ApplicationConstants.getColumnNames(m) + " from banner where uid = ?",
                    new Object[]{uid},
                    new RowMapper() {
                        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                            Banner banner = new Banner();
                            try {
                                banner.mergePropertiesFromResultSet(rs);
                            } catch (Exception e) {
                                logger.log(Level.SEVERE, e.getMessage(), e);
                            }
                            return banner;
                        }
                    });
        } catch (EmptyResultDataAccessException e) {
            banner = null;
        }
        return banner;
    }

    @Override
    public String getBannerUidById(String s) throws Exception {
        Banner banner;
        try {
            banner = (Banner) this.getJdbcTemplate().queryForObject(
                    "select uid from banner where id = ?",
                    new Object[]{s},
                    new RowMapper() {
                        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                            Banner banner = new Banner();
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
        return banner.getUid();
    }

    @Override
    public List<Banner> getBanners() throws Exception {
        try {
            List<Banner> banners = new ArrayList<Banner>();
            SortedMap<String, Object> m = new Banner().getFieldsMapExcept(new String[]{"content"});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from banner where banner_state != ?";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql, new Object[]{ApplicationConstants.STATE_REMOVED});

            for (Map row : rows) {
                Banner banner = new Banner();
                banner.mergePropertiesFromResultRow(row);
                banners.add(banner);
            }
            /* for (Banner currentBanner : banners) {    //VA
                setPageAndReferrerTarget(currentBanner);
            }*/

            return banners;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public List<TrashedObject> getTrashedBanners() throws Exception {
        ReportCriteria reportRequest = new ReportCriteria();
        reportRequest.setBannerUids(new ArrayList<String>());
        reportRequest.setType(ApplicationConstants.BANNER_ENTITY_LEVEL);
        reportRequest.setPrecision(ApplicationConstants.NONE_PRECISION);
        try {

            Map<String, TrashedObject> banners = new HashMap<String, TrashedObject>();
            SortedMap<String, Object> m = new Banner().getFieldsMapByName(new String[]{"uid", "bannerName"});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from banner where banner_state = ?";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql, new Object[]{ApplicationConstants.STATE_REMOVED});

            for (Map row : rows) {
                Banner banner = new Banner();
                banner.mergePropertiesFromResultRow(row);
                TrashedObject tBanner = new TrashedObject();
                tBanner.setType(true);
                tBanner.setUid(banner.getUid());
                tBanner.setName(banner.getBannerName());
                banners.put(tBanner.getUid(), tBanner);
                reportRequest.getBannerUids().add(banner.getUid());
            }

            List<ReportsRow> report = getReportDAO().getReport(reportRequest);
            for (ReportsRow rr : report) {
                banners.get(rr.getBannerUid()).setClicks(rr.getClicks());
                banners.get(rr.getBannerUid()).setViews(rr.getViews());
            }
            return new ArrayList<TrashedObject>(banners.values());
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public List<UrlPattern> getUrlPatterns() throws Exception {
        List<UrlPattern> urlPatterns = new ArrayList<UrlPattern>();
        SortedMap<String, Object> m = new UrlPattern().getFieldsMapExcept(new String[]{});
        String targetPageUrlSql = "select " + ApplicationConstants.getColumnNames(m) + " from url_patterns";
        List<Map<String, Object>> rowsPageUrlTarget = this.getJdbcTemplate().queryForList(targetPageUrlSql);
        for (Map row : rowsPageUrlTarget) {
            UrlPattern urlPattern = new UrlPattern();
            urlPattern.mergePropertiesFromResultRow(row);
            urlPatterns.add(urlPattern);
        }
        return urlPatterns;
    }

    @Override
    public List<ReferrerPattern> getReferrerPatterns() throws Exception {
        List<ReferrerPattern> referrerPatterns = new ArrayList<ReferrerPattern>();
        SortedMap<String, Object> m = new ReferrerPattern().getFieldsMapExcept(new String[]{});
        String targetReferrerUrlSql = "select " + ApplicationConstants.getColumnNames(m) + " from referrer_patterns";
        List<Map<String, Object>> rowsTargetReferrer = this.getJdbcTemplate().queryForList(targetReferrerUrlSql);
        for (Map row : rowsTargetReferrer) {
            ReferrerPattern referrerPattern = new ReferrerPattern();
            referrerPattern.mergePropertiesFromResultRow(row);
            referrerPatterns.add(referrerPattern);
        }
        return referrerPatterns;
    }

    @Override
    public List<DynamicParameter> getDynamicParameters() throws Exception {
        List<DynamicParameter> dynamicParameters = new ArrayList<DynamicParameter>();
        SortedMap<String, Object> m = new DynamicParameter().getFieldsMapExcept(new String[]{});
        String dynamicParametersSql = "select " + ApplicationConstants.getColumnNames(m) + " from dynamic_parameters";
        List<Map<String, Object>> rowsTargetDynamicParameters = this.getJdbcTemplate().queryForList(dynamicParametersSql);
        for (Map row : rowsTargetDynamicParameters) {
            DynamicParameter dp = new DynamicParameter();
            dp.mergePropertiesFromResultRow(row);
            dynamicParameters.add(dp);
        }
        return dynamicParameters;
    }


    @Override
    public List<IpPattern> getIpPatterns() throws Exception {
        List<IpPattern> IpPatterns = new ArrayList<IpPattern>();
        SortedMap<String, Object> m = new IpPattern().getFieldsMapExcept(new String[]{});
        String ipPatternsSql = "select " + ApplicationConstants.getColumnNames(m) + " from ip_patterns";
        List<Map<String, Object>> rowsTargetIpPatterns = this.getJdbcTemplate().queryForList(ipPatternsSql);
        for (Map row : rowsTargetIpPatterns) {
            IpPattern ipPattern = new IpPattern();
            ipPattern.mergePropertiesFromResultRow(row);
            ipPattern.setIpPatternFromAndToIp();
            IpPatterns.add(ipPattern);
        }
        return IpPatterns;
    }


    @Override
    public List<String> getAssignedBannerUidsByAdPlaceUids() throws Exception {
        try {
            List<String> bannerUidsByAdPlaceUids = new ArrayList<String>();
            SortedMap<String, Object> m = new Banner().getFieldsMapExcept(new String[]{"banner_content"});
            String sql = "select uid,ad_place_uid  from banner where banner_state != ? and ad_place_uid is not null";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql, new Object[]{ApplicationConstants.STATE_REMOVED});

            for (Map row : rows) {
                Banner banner = new Banner();
                banner.mergePropertiesFromResultRow(row);
                bannerUidsByAdPlaceUids.add(banner.getUid() + "x" + banner.getAdPlaceUid());
            }
            return bannerUidsByAdPlaceUids;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }


    @Override
    public List<String> getNotRemovedBannerUids() throws Exception {
        try {
            List<String> bannerUids = new ArrayList<String>();
            String sql = "select uid from banner where banner_state != ?";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql, new Object[]{ApplicationConstants.STATE_REMOVED});

            for (Map row : rows) {
                Banner banner = new Banner();
                try {
                    banner.mergePropertiesFromResultRow(row);
                } catch (Exception e) {
                    logger.log(Level.SEVERE, e.getMessage(), e);
                }
                bannerUids.add(banner.getUid());
            }
            return bannerUids;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

}