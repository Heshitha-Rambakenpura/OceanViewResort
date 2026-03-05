package com.oceanview.servlet;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.model.AuditLog;
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

    @Override
    public void init() {
        this.auditLogDAO = new AuditLogDAO();
    }

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
            request.getRequestDispatcher(
                            "/jsp/admin/manage_users.jsp")
                    .forward(request, response);

        } else if ("auditLogs".equals(action)) {
            // Get all logs and pass to JSP
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

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && "ADMIN".equals(
                session.getAttribute("userRole"));
    }
}