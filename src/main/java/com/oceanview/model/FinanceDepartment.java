package com.oceanview.model;

/**
 * FinanceDepartment - Extends User
 * Financial oversight staff
 * @version 1.0.0
 */
public class FinanceDepartment extends User {

    private String departmentId;

    // ─── CONSTRUCTORS ───
    public FinanceDepartment() {}

    public FinanceDepartment(int userId, String username, String password,
                             String name, String departmentId) {
        super(userId, username, password, name, "FINANCE");
        this.departmentId = departmentId;
    }

    // ─── GETTERS AND SETTERS ───
    public String getDepartmentId()             { return departmentId; }
    public void setDepartmentId(String id)      { this.departmentId = id; }

    // ─── OVERRIDE ───
    @Override
    public String getDashboardURL() {
        return "/jsp/auth/finance_dashboard.jsp";
    }
}