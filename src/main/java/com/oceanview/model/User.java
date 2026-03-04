package com.oceanview.model;

import java.time.LocalDateTime;

/**
 * User - Abstract class (Template Method Pattern)
 * Parent class for all staff roles
 * @version 1.0.0
 */
public abstract class User {

    // ─── ATTRIBUTES ───
    private int userId;
    private String username;
    private String password;
    private String name;
    private String role;
    private boolean loginStatus;
    private LocalDateTime registerDate;

    // ─── CONSTRUCTORS ───
    public User() {}

    public User(int userId, String username, String password,
                String name, String role) {
        this.userId      = userId;
        this.username    = username;
        this.password    = password;
        this.name        = name;
        this.role        = role;
        this.loginStatus = false;
        this.registerDate = LocalDateTime.now();
    }

    // ─── GETTERS ───
    public int getUserId()              { return userId; }
    public String getUsername()         { return username; }
    public String getPassword()         { return password; }
    public String getName()             { return name; }
    public String getRole()             { return role; }
    public boolean isLoginStatus()      { return loginStatus; }
    public LocalDateTime getRegisterDate() { return registerDate; }

    // ─── SETTERS ───
    public void setUserId(int userId)           { this.userId = userId; }
    public void setUsername(String username)     { this.username = username; }
    public void setPassword(String password)     { this.password = password; }
    public void setName(String name)             { this.name = name; }
    public void setRole(String role)             { this.role = role; }
    public void setLoginStatus(boolean status)   { this.loginStatus = status; }
    public void setRegisterDate(LocalDateTime d) { this.registerDate = d; }

    // ─── ABSTRACT METHODS ───
    // Each subclass must implement these
    public abstract String getDashboardURL();
}