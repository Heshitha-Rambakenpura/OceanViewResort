package com.oceanview.dao;

import com.oceanview.model.User;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;

/**
 * UserDAO - DAO Pattern (Structural Pattern)
 * Handles all database operations for User
 * @version 1.0.0
 */
public class UserDAO {

    private Connection connection;

    public UserDAO() {
        this.connection = DatabaseConnection.getInstance().getConnection();
    }

    // ─── VERIFY LOGIN ───
    public User verifyLogin(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return null;
    }

    // ─── GET USER BY ID ───
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get user error: " + e.getMessage());
        }
        return null;
    }

    // ─── UPDATE LOGIN STATUS ───
    public boolean updateLoginStatus(int userId, boolean status) {
        String sql = "UPDATE users SET login_status = ? WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update login status error: " + e.getMessage());
        }
        return false;
    }

    // ─── MAP RESULT SET TO USER ───
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        String role = rs.getString("role");
        // Return basic user info - controller will cast to correct type
        com.oceanview.model.Receptionist user = new com.oceanview.model.Receptionist();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setName(rs.getString("name"));
        user.setRole(rs.getString("role"));
        user.setLoginStatus(rs.getBoolean("login_status"));
        return user;
    }
}