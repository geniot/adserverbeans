package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.dao.ISettingsDAO;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.CannotGetJdbcConnectionException;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import javax.servlet.ServletException;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ControlDBVersionServlet extends AbstractService {
    static Logger logger = Logger.getLogger(ControlVersionServlet.class.getName());
    private InstallerService installerService = new InstallerService();

    public void init() throws ServletException {

        try {
            String lastDbScriptName = installerService.getLastDbScriptName();
            Properties userProps = installerService.readUserProps();
            installerService.writeDbState(lastDbScriptName,userProps);
        }
        catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage(), ex);
        }
        super.init();
    }
}
