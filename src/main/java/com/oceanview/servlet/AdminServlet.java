package com.oceanview.servlet;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;

/**
 * AdminServlet - Handles admin operations
 * @version 1.0.0
 */
public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        this.userDAO     = new UserDAO();
        this.auditLogDAO = new AuditLogDAO();
    }

    // ─── GET - Handle Admin Actions ───
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        // Check session
        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        // Check admin role
        if (!isAdmin(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("manageUsers".equals(action)) {
            // Show manage users page
            request.getRequestDispatcher(
                            "/jsp/admin/manage_users.jsp")
                    .forward(request, response);

        } else if ("auditLogs".equals(action)) {
            // Get audit logs
            HttpSession session  = request.getSession();
            User user            = (User) session.getAttribute("user");
            String ipAddress     = request.getRemoteAddr();
            auditLogDAO.logAction(user.getUserId(),
                    "AUDIT_LOGS_VIEWED", ipAddress);
            request.getRequestDispatcher(
                            "/jsp/admin/audit_logs.jsp")
                    .forward(request, response);

        } else if ("maintainSystem".equals(action)) {
            // Show system maintenance page
            request.getRequestDispatcher(
                            "/jsp/admin/maintain_system.jsp")
                    .forward(request, response);

        } else {
            // Default - go to dashboard
            response.sendRedirect(
                    request.getContextPath()
                            + "/jsp/auth/admin_dashboard.jsp");
        }
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