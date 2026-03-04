package com.oceanview.dao;

import com.oceanview.util.DatabaseConnection;
import java.sql.*;

/**
 * AuditLogDAO - DAO Pattern (Structural Pattern)
 * Handles all database operations for AuditLog
 * @version 1.0.0
 */
public class AuditLogDAO {

    private Connection connection;

    public AuditLogDAO() {
        this.connection = DatabaseConnection.getInstance().getConnection();
    }

    // ─── LOG ACTION ───
    public boolean logAction(int userId, String action, String ipAddress) {
        String sql = "INSERT INTO audit_logs (user_id, action, ip_address) " +
                "VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, action);
            ps.setString(3, ipAddress);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Log action error: " + e.getMessage());
        }
        return false;
    }

    // ─── GET ALL LOGS ───
    public ResultSet getAllLogs() {
        String sql = "SELECT al.*, u.username, u.name " +
                "FROM audit_logs al " +
                "JOIN users u ON al.user_id = u.user_id " +
                "ORDER BY al.timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            return ps.executeQuery();
        } catch (SQLException e) {
            System.err.println("Get logs error: " + e.getMessage());
        }
        return null;
    }

    // ─── GET LOGS BY USER ───
    public ResultSet getLogsByUser(int userId) {
        String sql = "SELECT * FROM audit_logs " +
                "WHERE user_id = ? " +
                "ORDER BY timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeQuery();
        } catch (SQLException e) {
            System.err.println("Get logs by user error: " + e.getMessage());
        }
        return null;
    }
}