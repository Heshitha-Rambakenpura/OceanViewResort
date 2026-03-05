package com.oceanview.controller;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

/**
 * UserController - Business Logic for User operations
 * @version 1.0.0
 */
public class UserController {

    private UserDAO userDAO;
    private AuditLogDAO auditLogDAO;

    public UserController() {
        this.userDAO     = new UserDAO();
        this.auditLogDAO = new AuditLogDAO();
    }

    // ─── VERIFY LOGIN ───
    public User verifyLogin(String username, String password,
                            int i, String ipAddress) {
        User user = userDAO.verifyLogin(username, password);
        if (user != null) {
            // Login successful
            userDAO.updateLoginStatus(user.getUserId(), true);
            auditLogDAO.logAction(user.getUserId(),
                    "LOGIN_SUCCESS", ipAddress);
            return user;
        }
        // Login failed - log with userId 0 (unknown user)
        auditLogDAO.logAction(0, "LOGIN_FAILED", ipAddress);
        return null;
    }

    // ─── LOGOUT ───
    public boolean logout(int userId, String ipAddress) {
        auditLogDAO.logAction(userId, "LOGOUT", ipAddress);
        return userDAO.updateLoginStatus(userId, false);
    }

    // ─── GET USER BY ID ───
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }
}