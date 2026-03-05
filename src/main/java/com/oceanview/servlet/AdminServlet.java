package com.oceanview.servlet;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.dao.UserDAO;
import com.oceanview.model.Admin;
import com.oceanview.model.AuditLog;
import com.oceanview.model.FinanceDepartment;
import com.oceanview.model.Receptionist;
import com.oceanview.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * AdminServlet - Handles admin operations
 * @version 1.0.0
 */
public class AdminServlet extends HttpServlet {

    private AuditLogDAO auditLogDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        this.auditLogDAO = new AuditLogDAO();
        this.userDAO     = new UserDAO();
    }

    // ─── GET ───
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }
        if (!isAdmin(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String action    = request.getParameter("action");
        HttpSession session  = request.getSession();
        User user            = (User) session.getAttribute("user");
        String ipAddress     = request.getRemoteAddr();

        if ("manageUsers".equals(action)) {
            // Get all users to display
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher(
                            "/jsp/admin/manage_users.jsp")
                    .forward(request, response);

        } else if ("auditLogs".equals(action)) {
            List<AuditLog> logs = auditLogDAO.getAllLogs();
            auditLogDAO.logAction(user.getUserId(),
                    "AUDIT_LOGS_VIEWED",
                    ipAddress);
            request.setAttribute("logs", logs);
            request.getRequestDispatcher(
                            "/jsp/admin/audit_logs.jsp")
                    .forward(request, response);

        } else if ("maintainSystem".equals(action)) {
            request.getRequestDispatcher(
                            "/jsp/admin/maintain_system.jsp")
                    .forward(request, response);

        } else {
            response.sendRedirect(
                    request.getContextPath()
                            + "/jsp/auth/admin_dashboard.jsp");
        }
    }

    // ─── POST - Create New User ───
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }
        if (!isAdmin(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String name            = request.getParameter("name");
        String username        = request.getParameter("username");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter(
                "confirmPassword");
        String role            = request.getParameter("role");
        String ipAddress       = request.getRemoteAddr();

        HttpSession session = request.getSession();
        User adminUser      = (User) session.getAttribute("user");

        // ─── Validate Fields ───
        if (name == null || name.isEmpty()
                || username == null || username.isEmpty()
                || password == null || password.isEmpty()
                || role == null || role.isEmpty()) {
            request.setAttribute("error",
                    "All fields are required!");
            request.setAttribute("users",
                    userDAO.getAllUsers());
            request.getRequestDispatcher(
                            "/jsp/admin/manage_users.jsp")
                    .forward(request, response);
            return;
        }

        // ─── Validate Password Match ───
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error",
                    "Passwords do not match!");
            request.setAttribute("users",
                    userDAO.getAllUsers());
            request.getRequestDispatcher(
                            "/jsp/admin/manage_users.jsp")
                    .forward(request, response);
            return;
        }

        // ─── Validate Password Length ───
        if (password.length() < 6) {
            request.setAttribute("error",
                    "Password must be at least 6 characters!");
            request.setAttribute("users",
                    userDAO.getAllUsers());
            request.getRequestDispatcher(
                            "/jsp/admin/manage_users.jsp")
                    .forward(request, response);
            return;
        }

        // ─── Check Username Exists ───
        if (userDAO.checkUsernameExists(username)) {
            request.setAttribute("error",
                    "Username already exists!");
            request.setAttribute("users",
                    userDAO.getAllUsers());
            request.getRequestDispatcher(
                            "/jsp/admin/manage_users.jsp")
                    .forward(request, response);
            return;
        }

        // ─── Create Correct User Type ───
        User newUser;
        switch (role) {
            case "ADMIN":
                newUser = new Admin();
                break;
            case "FINANCE":
                newUser = new FinanceDepartment();
                break;
            default:
                newUser = new Receptionist();
                break;
        }
        newUser.setName(name);
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setRole(role);

        // ─── Save User ───
        boolean saved = userDAO.saveUser(newUser);

        if (saved) {
            auditLogDAO.logAction(adminUser.getUserId(),
                    "USER_CREATED - " + username, ipAddress);
            request.setAttribute("success",
                    "User account created successfully!");
        } else {
            request.setAttribute("error",
                    "Failed to create user! Please try again.");
        }

        request.setAttribute("users", userDAO.getAllUsers());
        request.getRequestDispatcher(
                        "/jsp/admin/manage_users.jsp")
                .forward(request, response);
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }

    // ─── CHECK ADMIN ROLE ───
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && "ADMIN".equals(
                session.getAttribute("userRole"));
    }
}