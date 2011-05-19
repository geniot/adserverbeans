package com.adserversoft.flexfuse.client;

import junit.framework.AssertionFailedError;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class LoginTest extends SeleniumFlexTestCase {
    static Logger logger = Logger.getLogger(LoginTest.class.getName());
    private DefaultSeleniumFlex selenium;

    @Before
    public void setUp() throws Exception {
        super.setUp();
        selenium = getDefaultSeleniumFlex();
        logger.log(Level.INFO, "Starting selenium browser");
        selenium.start();
    }

    @After
    public void tearDown() throws Exception {
        selenium.stop();
        super.tearDown();
    }

    @Test
    public void testLogin() {
        try {
            logger.log(Level.INFO, "Starting to interact with the browser");
            String rnd = String.valueOf(new Random().nextFloat());
            selenium.open(baseURL + "?rnd=" + rnd);

            selenium.waitForPageToLoad("10000");
            Thread.sleep(3000);
            //login
            selenium.flexSetFocus("email");
            selenium.flexType("email", "admin@gmail.com");

            selenium.flexSetFocus("password");
            selenium.flexType("password", "admin");

            selenium.flexCheckBox("rememberMe", "true");
            selenium.flexClick("loginBtn");
            Thread.sleep(3000);

            //adding banner
            selenium.flexClick("addBannerB");

            selenium.flexSetFocus("bannerNameTI");
            selenium.flexType("bannerNameTI", "banner test name");

            selenium.flexSetFocus("adFormat");
            selenium.flexSelectIndex("adFormat", "10");

            selenium.flexSetFocus("targetURLTI");
            selenium.flexType("targetURLTI", "http://www.agentpress.com");

            selenium.flexSetFocus("bannerFileTI");
            selenium.flexType("bannerFileTI", "/opt/checkout/myads/server/src/web/images/sample_banners/250x250_agent_press.jpg");

            selenium.flexClick("saveBtn");
            selenium.flexWaitForElement("bannerNameTI");
            Thread.sleep(3000);

            selenium.executeCommand("verifyFlexProperty", "bannerNameTI.text", "banner test name");

            Thread.sleep(3000);

        } catch (Exception e) {
            System.err.println("\nTest FAILED (" + e.getMessage() + ")");
            throw new AssertionFailedError();
        }
    }

}
