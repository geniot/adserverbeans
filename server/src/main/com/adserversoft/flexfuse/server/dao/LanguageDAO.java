package com.adserversoft.flexfuse.server.dao;

import com.Ostermiller.util.CSVParser;
import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.Language;
import com.adserversoft.flexfuse.server.api.dao.ILanguageDAO;
import org.springframework.dao.EmptyResultDataAccessException;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LanguageDAO extends AbstractDAO implements ILanguageDAO {
    static Logger logger = Logger.getLogger(LanguageDAO.class.getName());

    public List<Language> getLanguages() throws Exception {
        List<Language> languages = getLanguagesTable();
        if (languages.size() == 0) {
            updateCSV();
            languages = getLanguagesTable();
        }
        return languages;
    }

    private List<Language> getLanguagesTable() throws Exception {
        try {
            List<Language> languages = new ArrayList<Language>();
            SortedMap<String, Object> m = new Language().getFieldsMapExcept(new String[]{});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from t_language order by id";
            List<Map<String, Object>> rows = this.getJdbcTemplate().queryForList(sql);
            for (Map row : rows) {
                Language language = new Language();
                language.mergePropertiesFromResultRow(row);
                languages.add(language);
            }
            return languages;
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
                    appProperties.getProperty("fileLanguages.path"));
            CSVParser reader = new CSVParser(new InputStreamReader(stream));
            String[][] records = reader.getAllValues();

            String sql;
            while (iRecord < records.length) {
                String[] record = records[iRecord++];
                String languageAbbrSmall = record[0];
                String languageName = record[1];

                sql = "INSERT INTO t_language (language_abbr_small, language_name) VALUES (?, ?) ON DUPLICATE KEY UPDATE language_abbr_small=?, language_name=?;";
                this.getJdbcTemplate().update(sql, languageAbbrSmall, languageName, languageAbbrSmall, languageName);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage(), e);
        }
        logger.info("Imported: " + iRecord + " items.");
    }
}