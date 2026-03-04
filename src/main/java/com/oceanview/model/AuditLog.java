package com.oceanview.model;

import java.time.LocalDateTime;

/**
 * AuditLog - Entity class
 * Tracks all system activities
 * @version 1.0.0
 */
public class AuditLog {

    private int logId;
    private int userId;
    private String action;
    private LocalDateTime timestamp;
    private String ipAddress;

    // ─── CONSTRUCTORS ───
    public AuditLog() {}

    public AuditLog(int userId, String action, String ipAddress) {
        this.userId    = userId;
        this.action    = action;
        this.ipAddress = ipAddress;
        this.timestamp = LocalDateTime.now();
    }

    // ─── GETTERS ───
    public int getLogId()               { return logId; }
    public int getUserId()              { return userId; }
    public String getAction()           { return action; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public String getIpAddress()        { return ipAddress; }

    // ─── SETTERS ───
    public void setLogId(int id)                { this.logId = id; }
    public void setUserId(int userId)           { this.userId = userId; }
    public void setAction(String action)        { this.action = action; }
    public void setTimestamp(LocalDateTime t)   { this.timestamp = t; }
    public void setIpAddress(String ip)         { this.ipAddress = ip; }
}