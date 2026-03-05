package com.oceanview.dao;

import com.oceanview.model.AuditLog;
import com.oceanview.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * AuditLogDAO - Handles all audit log operations
 * @version 1.0.0
 */
public class AuditLogDAO {

    private Connection connection;

    public AuditLogDAO() {
        this.connection = DatabaseConnection
                .getInstance().getConnection();
    }

    // ─── LOG ACTION ───
    public boolean logAction(int userId, String action,
                             String ipAddress) {
        String sql = "INSERT INTO audit_logs " +
                "(user_id, action, ip_address, timestamp) " +
                "VALUES (?, ?, ?, NOW())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, action);
            ps.setString(3, ipAddress);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Log action error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── GET ALL LOGS ───
    public List<AuditLog> getAllLogs() {
        List<AuditLog> logs = new ArrayList<>();
        String sql = "SELECT al.*, u.username " +
                "FROM audit_logs al " +
                "JOIN users u ON al.user_id = u.user_id " +
                "ORDER BY al.timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setAction(rs.getString("action"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setTimestamp(rs.getTimestamp("timestamp")
                        .toLocalDateTime());
                logs.add(log);
            }
        } catch (SQLException e) {
            System.err.println("Get all logs error: "
                    + e.getMessage());
        }
        return logs;
    }

    // ─── GET LOGS BY USER ───
    public List<AuditLog> getLogsByUser(int userId) {
        List<AuditLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM audit_logs " +
                "WHERE user_id = ? " +
                "ORDER BY timestamp DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setAction(rs.getString("action"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setTimestamp(rs.getTimestamp("timestamp")
                        .toLocalDateTime());
                logs.add(log);
            }
        } catch (SQLException e) {
            System.err.println("Get logs by user error: "
                    + e.getMessage());
        }
        return logs;
    }
}