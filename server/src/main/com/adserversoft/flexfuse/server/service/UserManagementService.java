package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.User;
import com.adserversoft.flexfuse.server.api.service.IUserManagementService;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Dmitrii Lemeshevsky
 * 13.7.2010 11.31.50
 */
public class UserManagementService extends AbstractManagementService implements IUserManagementService {
    private Logger logger = Logger.getLogger(UserManagementService.class.getName());

    @Override
    public User read(Integer id) throws Exception {
        User u = getUserDAO().getUserById(id);
        if (u != null) {
            throw new Exception("failure.userNotExists");
        }
        return u;
    }

    @Override
    public void create(User u) throws Exception {
        User dbu = getUserDAO().getUserByEmail(u.getEmail());
        if (dbu != null) {
            throw new Exception("failure.userExists");
        }
        String pw_hash = BCrypt.hashpw(u.getPassword(), BCrypt.gensalt());
        u.setPassword(pw_hash);
        u.setVerified(true);
        getUserDAO().create(u);

    }

    @Override
    public void updateLogoInDB(Integer userId, byte[] bbs, String filename) {
        try {
            User dbuser = new User();
            dbuser.setId(userId);
            if (bbs.length == 0) {
                throw new Exception("failed upload logo");
            }
            dbuser.setPic(bbs);
            dbuser.setFilename(filename);
            getUserDAO().updateLogo(dbuser);
        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage());
        }
    }

    @Override
    public void update(User u) throws Exception {
        User dbu = getUserDAO().getUserByEmail(u.getEmail());
        if (dbu != null && u.getId() != dbu.getId()) {
            throw new Exception("failure.userExists");
        }
        if (dbu == null) throw new Exception("failure.userNotExists");
        if (!u.isPasswordReset()) {
            u.setPassword(dbu.getPassword());
        } else {
            String pw_hash = BCrypt.hashpw(u.getPassword(), BCrypt.gensalt());
            u.setPassword(pw_hash);
            u.setVerified(true);
        }
        getUserDAO().update(u);

    }


    @Override
    public User login(User user) throws Exception {
        User dbUser = getUserDAO().getUserByEmail(user.getEmail());
        if (dbUser == null) throw new Exception("failure.userNotExists");
        if (BCrypt.checkpw(user.getPassword(), dbUser.getPassword())) {
            return dbUser;
        } else {
            throw new Exception("failure.invalidPassword");
        }
//        }
    }

    @Override
    public List<User> getList() throws Exception {
        List<User> l = null;
//        if (us.role.equals(ApplicationConstants.ROLE_ADMIN)) {
        l = getUserDAO().getList();
//        } else if (us.role.equals(ApplicationConstants.ROLE_RETAILER)) {
//            l = userDAO.getUsersByRole(sr, ApplicationConstants.ROLE_MANUFACTURER);
//        }
        return l;
    }

    public void updateRemindPasswordUser(String email) throws Exception {

        User currentUser = getUserDAO().getUserByEmail(email);
        if (currentUser == null) {
            throw new Exception("failure.emailNotExists");
        }
        String emailContent = getMailManagementService().getPasswordResetEmailContent(currentUser);
        String emailAddress = currentUser.getEmail();

        //todo: load subject from applicationresources by key!
        String emailSubject = "";//ApplicationConstants.emailSubjectPasswordReset;
        getMailManagementService().sendEmail(emailContent, emailSubject, emailAddress, currentUser);
        currentUser.setResetPasswordRequested(true);
        getUserDAO().update(currentUser);
    }

    @Override
    public byte[] getLogo() {
        try {
            User dbuser = getUserDAO().getUserById(1);
            byte[] bbs = dbuser.getPic();
            return bbs;
        } catch (Exception e) {
            logger.log(Level.SEVERE, e.getMessage());
        }
        return null;
    }

    @Override
    public void updateSettings(User user, String url, byte[] bbs, String filename) throws Exception {
//        User currentUser = getUserDAO().getUserByEmail(user.getEmail());
//        if (currentUser == null) {
//            throw new Exception("failure.userNotExists");
//        }
        if (user.isPasswordReset()) {
            String pw_hash = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            user.setPassword(pw_hash);
        }
        int i = url.indexOf("adserverbeans.com");
        if (i < 0) {
            getUserDAO().update(user);
        } else {
            getUserDAO().updateSettingsExceptPassword(user);
        }
        if (bbs != null && filename != null) {
            updateLogoInDB(user.getId(), bbs, filename);
        }
    }

    public User updateResetPasswordUser(String email, String password)
            throws Exception {
        User currentUser = getUserDAO().getUserByEmail(email);
        if (currentUser == null) {
            throw new Exception("failure.userNotExists");
        }
        if (currentUser.getResetCode() != null) {
            currentUser.setResetPasswordRequested(false);
            currentUser.setResetCode(null);
            String pw_hash = BCrypt.hashpw(password, BCrypt.gensalt());
            currentUser.setPassword(pw_hash);
        } else {
            throw new Exception("failure.resetCodeIsOutdated");
        }
        getUserDAO().update(currentUser);
        return currentUser;
    }

    public User verifyRemindPassword(String resetPassword, Integer id) throws Exception {

        User currentUser = getUserDAO().getUserById(id);
        if (currentUser == null) {
            throw new Exception("failure.userNotExists");
        }
        if (currentUser.getResetCode() == null) {
            throw new Exception("failure.resetCodeIsOutdated");
        }
        if (BCrypt.checkpw(resetPassword, currentUser.getResetCode())) {
            return currentUser;
        } else {
            throw new Exception("failure.resetCodeNotCorrect");
        }
    }

    public User updateRemindEmail(String firstName, String lastName) throws Exception {

        User currentUser = getUserDAO().getUserByNames(firstName, lastName);
        if (currentUser == null) {
            throw new Exception("failure.userNotExists");
        }
//        String emailContent = mailManagementService.getUsernameRemindEmailContent(sr, currentUser);
//        String emailAddress = currentUser.getEmail();
        return currentUser;

    }

}
