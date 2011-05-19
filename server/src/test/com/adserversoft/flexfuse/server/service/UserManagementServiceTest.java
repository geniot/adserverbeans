package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.ContextAwareSpringBean;
import com.adserversoft.flexfuse.server.api.User;
import com.adserversoft.flexfuse.server.api.dao.IUserDAO;
import com.adserversoft.flexfuse.server.api.service.IUserManagementService;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class UserManagementServiceTest extends AbstractTransactionalDataSourceSpringContextTests {
    IUserManagementService userManagementServiceTarget;
    IUserDAO userDAO;


    protected String[] getConfigLocations() {
        setAutowireMode(AUTOWIRE_BY_NAME);
        setDependencyCheck(false);
        return new String[]{"context/applicationContext-ui.xml"};
    }

    protected void onSetUp() throws Exception {
        System.out.println("setup");
        userManagementServiceTarget = (IUserManagementService) ContextAwareSpringBean.APP_CONTEXT.getBean("userManagementServiceTarget1");
        userDAO = (IUserDAO) ContextAwareSpringBean.APP_CONTEXT.getBean("userDAO1");

        DataSourceTransactionManager tm = (DataSourceTransactionManager) ContextAwareSpringBean.APP_CONTEXT.getBean("transactionManager1");
        setTransactionManager(tm);
        super.onSetUp();
    }

    protected void onTearDown() throws Exception {
        super.onTearDown();
    }

    public void testCreate() {
        try {
            String email = "some@gmail.com";
            String firstName = "Vitaly";
            String lastName = "Sazanovich";

            User u = new User();
            u.setEmail(email);
            u.setFirstName(firstName);
            u.setLastName(lastName);
            InstallationContextHolder.setCustomerType(1);
            userManagementServiceTarget.create(u);
            User dbUser = userDAO.getUserByEmail(email);
            assertEquals(dbUser.getFirstName(), firstName);
            assertEquals(dbUser.getLastName(), lastName);

        } catch (Exception ex) {
            ex.printStackTrace();
            fail(ex.getMessage());
        }
    }


    public void testUpdate() {
        try {
            String email = "test_for_update@gmail.com";
            String firstName = "Vladimir";
            String lastName = "Budanov";
            String emailFrom = "email_from@gmail.com";
            String pass = "my_long_password";
            User u = new User();
            u.setEmail(email);
            u.setFirstName(firstName);
            u.setLastName(lastName);
            u.setFromEmail(emailFrom);
            u.setPassword(BCrypt.hashpw(pass, BCrypt.gensalt()));
            InstallationContextHolder.setCustomerType(1);
            userManagementServiceTarget.create(u);
            u = userDAO.getUserByEmail(email);
            String newFirstName = "Vitaly";
            String newLastName = "Sazanovich";
            String newEmailFrom = "some@gmail.com";
            String newPass = "new_long_password";
            u.setFirstName(newFirstName);
            u.setLastName(newLastName);
            u.setFromEmail(newEmailFrom);
            u.setPassword(BCrypt.hashpw(newPass, BCrypt.gensalt()));
            userDAO.update(u);

            User dbUser = userDAO.getUserByEmail(email);
            assertEquals(dbUser.getFirstName(), newFirstName);
            assertEquals(dbUser.getLastName(), newLastName);
            assertEquals(dbUser.getFromEmail(), newEmailFrom);
            assertTrue(BCrypt.checkpw(newPass, dbUser.getPassword()));

        } catch (Exception ex) {
            ex.printStackTrace();
            fail(ex.getMessage());
        }
    }


}
