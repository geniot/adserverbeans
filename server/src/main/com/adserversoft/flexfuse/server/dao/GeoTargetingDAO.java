package com.adserversoft.flexfuse.server.dao;

import com.Ostermiller.util.CSVParser;
import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Country;
import com.adserversoft.flexfuse.server.api.dao.IGeoTargetingDAO;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 * User: Lemeshevsky D.
 */
public class GeoTargetingDAO extends AbstractDAO implements IGeoTargetingDAO {
    static Logger logger = Logger.getLogger(GeoTargetingDAO.class.getName());

    public List<Country> getCountries() throws Exception {
        List<Country> countries = getCountriesTable();
        if (countries.size() == 0) {
            updateCSV();
            countries = getCountriesTable();
        }
        return countries;
    }

    private List<Country> getCountriesTable() throws Exception {
        try {
            List<Country> countries = new ArrayList<Country>();
            SortedMap<String, Object> m = new Country().getFieldsMapExcept(new String[]{});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from country order by id";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql);
            for (Map row : rows) {
                Country country = new Country();
                country.mergePropertiesFromResultRow(row);
                countries.add(country);
            }
            return countries;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    public void updateCSV() throws Exception {
        int iRecord = 0;
        try {
            InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
            Properties appProperties = new Properties();
            appProperties.load(is);
            InputStream stream = this.getClass().getClassLoader().getResourceAsStream(
                    appProperties.getProperty("fileIp.path"));
            CSVParser reader = new CSVParser(new InputStreamReader(stream));
            String[][] records = reader.getAllValues();

            String sql;
            int progress = 0;
            Map<String, Integer> countryNameToId = new HashMap<String, Integer>();
            while (iRecord < records.length) {
                String[] record = records[iRecord++];
                String ipFrom = record[0];
                String ipTo = record[1];
                String countryAbbrSmall = record[2];
                String countryAbbr = record[3];
                String countryName = record[4];

                Integer countryId = countryNameToId.get(countryAbbrSmall);
                if (countryId == null) {
                    sql = "INSERT INTO country (country_abbr_small, country_abbr, country_name) VALUES (?, ?, ?);";
                    this.getJdbcTemplate().update(sql, countryAbbrSmall, countryAbbr, countryName);
                    countryId = getCountryId(countryAbbrSmall);
                    countryNameToId.put(countryAbbrSmall, countryId);
                }

                sql = "INSERT INTO ip_to_country (ip_from, ip_to, country_id) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE ip_to=?, country_id=?;";
                this.getJdbcTemplate().update(sql, Long.valueOf(ipFrom), Long.valueOf(ipTo), countryId, Long.valueOf(ipTo), countryId);

                int newProgress = iRecord * 100 / records.length;
                if (newProgress != progress) {
                    progress = newProgress;
                    logger.info("Progress: " + progress);
                }
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage(), e);
        }
        logger.info("Imported: " + iRecord + " items.");
    }

    private Integer getCountryId(String countryAbbrSmall) {
        Integer currentCountryId;
        try {
            currentCountryId = (Integer) this.getJdbcTemplate().queryForObject(
                    "select id from country where country_abbr_small = ?",
                    new Object[]{countryAbbrSmall},
                    new RowMapper() {
                        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                            Integer currentId = null;
                            try {
                                currentId = rs.getInt("id");
                            } catch (Exception e) {
                                logger.log(Level.SEVERE, e.getMessage(), e);
                            }
                            return currentId;
                        }
                    });
        }
        catch (EmptyResultDataAccessException e) {
            currentCountryId = null;
        }
        return currentCountryId;
    }
}