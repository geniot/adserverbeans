package com.adserversoft.flexfuse.server.dao;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import com.adserversoft.flexfuse.server.api.User;
import com.adserversoft.flexfuse.server.api.dao.IUserDAO;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedMap;
import java.util.logging.Level;
import java.util.logging.Logger;


public class UserDAO extends AbstractDAO implements IUserDAO {
    static Logger logger = Logger.getLogger(BannerDAO.class.getName());

    @Override
    public User getUserById(final Integer id) throws Exception {
        try {
            SortedMap<String, Object> m = new User().getFieldsMapExcept(new String[]{});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from t_user where id = ?";
            return (User) this.getJdbcTemplate().queryForObject(
                    sql,
                    new Object[]{id},
                    new RowMapper() {
                        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                            User user = new User();
                            try {
                                user.mergePropertiesFromResultSet(rs);
                            } catch (Exception e) {
                                logger.log(Level.SEVERE, e.getMessage(), e);
                            }
                            return user;
                        }
                    });
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public User getUserByEmail(final String email) throws Exception {
        try {
            SortedMap<String, Object> m = new User().getFieldsMapExcept(new String[]{});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from t_user where email = ?";
            return (User) this.getJdbcTemplate().queryForObject(
                    sql,
                    new Object[]{email},
                    new RowMapper() {
                        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                            User user = new User();
                            try {
                                user.mergePropertiesFromResultSet(rs);
                            } catch (Exception e) {
                                logger.log(Level.SEVERE, e.getMessage(), e);
                            }
                            return user;
                        }
                    });
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public User getUserByNames(final String firstName, final String lastName) throws Exception {
        try {
            SortedMap<String, Object> m = new User().getFieldsMapExcept(new String[]{});
            String sql = "select " + ApplicationConstants.getColumnNames(m) + "  from t_user where last_name=? and first_name=?";
            return (User) this.getJdbcTemplate().queryForObject(
                    sql,
                    new Object[]{lastName, firstName},
                    new RowMapper() {
                        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                            User user = new User();
                            try {
                                user.mergePropertiesFromResultSet(rs);
                            } catch (Exception e) {
                                logger.log(Level.SEVERE, e.getMessage(), e);
                            }
                            return user;
                        }
                    });
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public List<User> getList() {
        return null;         //TODO
    }


    @Override
    public void updateLogo(User user) {
        this.getJdbcTemplate().update(
                "update t_user set pic=?, filename=? where id=?",
                new Object[]{user.getPic(), user.getFilename(), user.getId()}
        );
    }

    @Override
    public void update(User user) throws Exception {
        SortedMap<String, Object> m = user.getFieldsMapExcept(new String[]{"id", "pic"});
        List parameters = new ArrayList();
        parameters.addAll(m.values());
        parameters.add(user.getId());
        String sql = "update t_user set " + ApplicationConstants.generateParametrizedColumnNames(m) + " where id=?";
        this.getJdbcTemplate().update(sql, parameters.toArray());

    }

    @Override
    public void updateSettingsExceptPassword(User user) throws Exception {
        SortedMap<String, Object> m = user.getFieldsMapExcept(new String[]{"id", "pic", "password", "email"});
        List parameters = new ArrayList();
        parameters.addAll(m.values());
        parameters.add(user.getEmail());
        String sql = "update t_user set " + ApplicationConstants.generateParametrizedColumnNames(m) + " where email=?";
        this.getJdbcTemplate().update(sql, parameters.toArray());
    }

    @Override
    public void create(User u) throws Exception {
        SortedMap<String, Object> m = u.getFieldsMapExcept(new String[]{"id"});

        List parameters = new ArrayList();
        parameters.addAll(m.values());
        parameters.addAll(m.values());

        String sql = "INSERT INTO t_user (" + ApplicationConstants.getColumnNames(m) + ") " +
                "VALUES (" + ApplicationConstants.generatePlaceHolders(m) + ") " +
                "ON DUPLICATE KEY UPDATE " + ApplicationConstants.generateParametrizedColumnNames(m) + ";";

        this.getJdbcTemplate().update(sql, parameters.toArray());
    }
}
