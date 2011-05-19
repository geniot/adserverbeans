package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.DataBaseState;
import com.adserversoft.flexfuse.server.api.dao.ISettingsDAO;
import liquibase.Liquibase;
import liquibase.database.Database;
import liquibase.database.DatabaseFactory;
import liquibase.database.JdbcConnection;
import liquibase.resource.ClassLoaderResourceAccessor;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.CannotGetJdbcConnectionException;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class InstallerService {
    static Logger logger = Logger.getLogger(InstallerService.class.getName());

    public String getLastDbScriptName() throws Exception {
        Properties appProps = new Properties();
        InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
        appProps.load(is);
        String changeLogPath = appProps.getProperty("changelog.path");

        String lastDbScriptName = "";
        InputStream file = InstallerService.class.getClassLoader().getResourceAsStream(changeLogPath);
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(file);
        doc.getDocumentElement().normalize();
        NodeList nodeLst = doc.getElementsByTagName("include");

        for (int i = 0; i < nodeLst.getLength(); i++) {
            Element fstNmElmnt = (Element) nodeLst.item(i);
            lastDbScriptName = fstNmElmnt.getAttribute("file");
        }
        return lastDbScriptName;
    }

    public List<DataBaseState> getDbState() {
        try {
            FileInputStream readDbStateFile = new FileInputStream(System.getProperty("user.home") + System.getProperty("file.separator") + ApplicationConstants.DB_FILE_STATE_NAME);
            DocumentBuilderFactory dbStateFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dbStateBuilder = dbStateFactory.newDocumentBuilder();
            Document docDbState = dbStateBuilder.parse(readDbStateFile);
            docDbState.getDocumentElement().normalize();
            NodeList nodeLstDbState = docDbState.getElementsByTagName("count");

            List<DataBaseState> dbLog = new ArrayList<DataBaseState>();

            for (int s = 0; s < nodeLstDbState.getLength(); s++) {
                Node fstNode = nodeLstDbState.item(s);
                if (fstNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element fstElmnt = (Element) fstNode;
                    NodeList fstNmElmntLst = fstElmnt.getElementsByTagName("db");
                    for (int i = 0; i < fstNmElmntLst.getLength(); i++) {
                        Element fstNmElmnt = (Element) fstNmElmntLst.item(i);
                        String dbName = fstNmElmnt.getAttribute("name");
                        NodeList fstNm = fstNmElmnt.getChildNodes();
                        String dbStatus = ((Node) fstNm.item(0)).getNodeValue();
//                            ApplicationConstants.dbLogMap.put(dbName, dbStatus);
                        DataBaseState currentDataBaseState = new DataBaseState();
                        currentDataBaseState.setDbName(dbName);
                        currentDataBaseState.setDbState(dbStatus);
                        dbLog.add(currentDataBaseState);
                    }
                }
            }
            return dbLog;
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage(), ex);
            return new ArrayList<DataBaseState>();
        }
    }

    public void createDb(Integer dbCount, String dbLogin, String dbPassword) throws Exception {
        Connection conn = null;
        InputStream readProcFiles = null;
        Properties appProps = new Properties();
        InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
        appProps.load(is);
        String changeLogPath = appProps.getProperty("changelog.path");

        try {
            conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306", dbLogin, dbPassword);
            int i = 1;

            PathMatchingResourcePatternResolver pmr = new PathMatchingResourcePatternResolver(this.getClass().getClassLoader());
            Resource[] procs = pmr.getResources("classpath:procs/*.sql");

            for (; i <= dbCount; i++) {
//                if (ApplicationConstants.dbLogMap.get(ApplicationConstants.DB_NAME_FIRST + i).equals(ApplicationConstants.DB_DOES_NOT_EXISTS)) {
                Statement currentStatement = conn.createStatement();
                String databaseName = ApplicationConstants.DB_NAME_FIRST + i;
                ResultSet result = currentStatement.executeQuery("show DATABASES like \'" + databaseName + "\'");
                if (!result.next()) {
                    currentStatement.executeUpdate("create database " + databaseName + " DEFAULT CHARACTER SET 'utf8' DEFAULT COLLATE utf8_bin;");
                }
//                }
                DriverManagerDataSource currentDataSource = (DriverManagerDataSource) ContextAwareSpringBean.APP_CONTEXT.getBean("dataSource" + i);
                currentDataSource.setUsername(dbLogin);
                currentDataSource.setPassword(dbPassword);

                Connection liquiConnection = currentDataSource.getConnection();
                ClassLoaderResourceAccessor liquiLoader = new ClassLoaderResourceAccessor();
                Database currentDataBase = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(new JdbcConnection(liquiConnection));

                Liquibase liquibase1 = new Liquibase(changeLogPath, liquiLoader, currentDataBase);
//                liquibase1.validate(); if need validate before execute liquibase
                liquibase1.update(changeLogPath);

                //format sql:" delimiter;; DROP....; CREATE...END ;;delimiter;  "
                Statement forProcStatement = liquiConnection.createStatement();
                for (Resource proc : procs) {
                    readProcFiles = proc.getInputStream();
                    Scanner in = new Scanner(readProcFiles);
                    StringBuffer data = new StringBuffer();
                    while (in.hasNext()) {
                        data.append(in.nextLine()).append("\n");
                    }
                    String fullSql = data.toString();
                    int poz = fullSql.indexOf(";;");
                    String preSql = fullSql.substring((poz + 2));
                    int pozDelete = preSql.indexOf(";");
                    int pozDelim = preSql.indexOf(";;");

                    String firstSql = preSql.substring(0, pozDelete);
                    String secondSql = preSql.substring(++pozDelete, pozDelim);
                    forProcStatement.executeUpdate(firstSql);
                    forProcStatement.executeUpdate(secondSql);
                }
            }

            writeUserProps(dbCount, dbLogin, dbPassword);

        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage(), e);
            throw new Exception(e);
        } finally {
            if (conn != null) {
                conn.close();
            }
            if (readProcFiles != null) {
                readProcFiles.close();
            }
        }
    }

    public void writeUserProps(int dbCount, String dbLogin, String dbPassword) {
        try {
            Properties props = new Properties();
            props.setProperty("db.count", String.valueOf(dbCount));
            props.setProperty("db.username", ApplicationConstants.mirrorBytes(dbLogin));
            props.setProperty("db.password", ApplicationConstants.mirrorBytes(dbPassword));
            props.setProperty("db.update.required", "false");
            props.storeToXML(new FileOutputStream(System.getProperty("user.home") + System.getProperty("file.separator") + ApplicationConstants.DB_FILE_PROPERTIES_NAME), "no comment");
        } catch (Exception ex) {
            logger.log(Level.WARNING, "Couldn't save props file to user home folder", ex);
        }
    }

    public Properties readUserProps() {
        Properties props = new Properties();
        try {
            props.loadFromXML(new FileInputStream(System.getProperty("user.home") + System.getProperty("file.separator") + ApplicationConstants.DB_FILE_PROPERTIES_NAME));
            ApplicationConstants.DATABASE_COUNT = Integer.parseInt(props.getProperty("db.count"));
            ApplicationConstants.IS_DB_UPDATE_REQUIRED = props.getProperty("db.update.required") == null ? true : Boolean.parseBoolean(props.getProperty("db.update.required"));
        } catch (Exception ex) {
            logger.log(Level.FINE, "Props file not found in user home folder.");
            ApplicationConstants.IS_DB_UPDATE_REQUIRED = true;
        }
        return props;
    }

    public void writeDbState(String lastDbScriptName, Properties props) {

        FileWriter sw = null;
        FileInputStream readDbPropertiesFile = null;
        try {
            sw = new FileWriter(System.getProperty("user.home") + System.getProperty("file.separator") + ApplicationConstants.DB_FILE_STATE_NAME, false);
            sw.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            sw.write("<count value=\"" + ApplicationConstants.DATABASE_COUNT + "\">" + "\n");
            for (int i = 1; i <= ApplicationConstants.DATABASE_COUNT; i++) {
                try {
                    if (!props.isEmpty()) {
                        DriverManagerDataSource currentDataSource = (DriverManagerDataSource) ContextAwareSpringBean.APP_CONTEXT.getBean("dataSource" + i);
                        currentDataSource.setUsername(ApplicationConstants.mirrorBytes(props.getProperty("db.username")));
                        currentDataSource.setPassword(ApplicationConstants.mirrorBytes(props.getProperty("db.password")));
                    }

                    ISettingsDAO settingsDAO = (ISettingsDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("settingsDAO" + i);
                    String versionDB = settingsDAO.getLastChange(lastDbScriptName);
                    if (versionDB.equals(ApplicationConstants.DATABASE_DEPRECATED)) {
                        //database deprecated
                        sw.write("<db name=\"" + ApplicationConstants.DB_NAME_FIRST + i + "\">" + ApplicationConstants.DATABASE_DEPRECATED + "</db>\n");
                        ApplicationConstants.IS_DB_UPDATE_REQUIRED = true;
                    } else {
                        //database is ok
                        sw.write("<db name=\"" + ApplicationConstants.DB_NAME_FIRST + i + "\">" + ApplicationConstants.DATABASE_OK + "</db>\n");
                    }
                } catch (BadSqlGrammarException e) {
                    //tables don't  exist
                    sw.write("<db name=\"" + ApplicationConstants.DB_NAME_FIRST + i + "\">" + ApplicationConstants.TABLES_DO_NOT_EXISTS + "</db>\n");
                    ApplicationConstants.IS_DB_UPDATE_REQUIRED = true;

                } catch (CannotGetJdbcConnectionException e) {
                    //database doesn't exist
                    sw.write("<db name=\"" + ApplicationConstants.DB_NAME_FIRST + i + "\">" + ApplicationConstants.DB_DOES_NOT_EXISTS + "</db>\n");
                    ApplicationConstants.IS_DB_UPDATE_REQUIRED = true;
                }
            }
            sw.write("</count>");
            sw.close();
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        } finally {
            try {
                if (sw != null) {
                    sw.close();
                }
                if (readDbPropertiesFile != null) {
                    readDbPropertiesFile.close();
                }
            } catch (IOException e) {
                logger.log(Level.SEVERE, e.getMessage());
            }
        }
    }
}
