package com.oceanview.model;

/**
 * Admin - Extends User
 * System administrator
 * @version 1.0.0
 */
public class Admin extends User {

    private int adminLevel;

    // ─── CONSTRUCTORS ───
    public Admin() {}

    public Admin(int userId, String username, String password,
                 String name, int adminLevel) {
        super(userId, username, password, name, "ADMIN");
        this.adminLevel = adminLevel;
    }

    // ─── GETTERS AND SETTERS ───
    public int getAdminLevel()              { return adminLevel; }
    public void setAdminLevel(int level)    { this.adminLevel = level; }

    // ─── OVERRIDE ───
    @Override
    public String getDashboardURL() {
        return "/jsp/auth/admin_dashboard.jsp";
    }
}