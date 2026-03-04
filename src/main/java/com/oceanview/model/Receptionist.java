package com.oceanview.model;

/**
 * Receptionist - Extends User
 * Primary operational staff
 * @version 1.0.0
 */
public class Receptionist extends User {

    private String employeeId;
    private String shift;

    // ─── CONSTRUCTORS ───
    public Receptionist() {}

    public Receptionist(int userId, String username, String password,
                        String name, String employeeId, String shift) {
        super(userId, username, password, name, "RECEPTIONIST");
        this.employeeId = employeeId;
        this.shift      = shift;
    }

    // ─── GETTERS AND SETTERS ───
    public String getEmployeeId()           { return employeeId; }
    public String getShift()                { return shift; }
    public void setEmployeeId(String id)    { this.employeeId = id; }
    public void setShift(String shift)      { this.shift = shift; }

    // ─── OVERRIDE ───
    @Override
    public String getDashboardURL() {
        return "/jsp/auth/receptionist_dashboard.jsp";
    }
}