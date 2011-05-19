package com.adserversoft.flexfuse.server.ui;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;

import javax.servlet.ServletException;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Dmitrii Lemeshevsky
 * 16.7.2010 15.00.17
 */
public class ControlVersionServlet extends AbstractService {
    static Logger logger = Logger.getLogger(ControlVersionServlet.class.getName());


    public void init() throws ServletException {

        try {
//            Properties props = new Properties();
//            props.load(new FileInputStream(getServletContext().getRealPath("build.num")));
//            ApplicationConstants.VERSION += "." + props.getProperty("build.number");

            Properties appProps = new Properties();
            InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
            appProps.load(is);
            ApplicationConstants.AD_FORMATS_MAP = ApplicationConstants.initializeAdFormats(appProps);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }

        super.init();
    }
}
