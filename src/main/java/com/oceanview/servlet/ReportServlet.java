package com.oceanview.servlet;

import com.oceanview.controller.ReportController;
import com.oceanview.model.Payment;
import com.oceanview.model.User;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * ReportServlet - Handles report operations
 * @version 1.0.0
 */

public class ReportServlet extends HttpServlet {

    private ReportController reportController;

    @Override
    public void init() {
        this.reportController = new ReportController();
    }

    // ─── GET - Show Report Page ───
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/jsp/report/report.jsp")
                .forward(request, response);
    }

    // ─── POST - Generate Report ───
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String startDate = request.getParameter("startDate");
        String endDate   = request.getParameter("endDate");
        String action    = request.getParameter("action");
        String ipAddress = request.getRemoteAddr();

        HttpSession session = request.getSession();
        User user           = (User) session.getAttribute("user");

        List<Payment> payments;

        if ("export".equals(action)) {
            payments = reportController.exportReport(
                    startDate, endDate,
                    user.getUserId(), ipAddress);
        } else {
            payments = reportController.generateReport(
                    startDate, endDate,
                    user.getUserId(), ipAddress);
        }

        if (payments == null || payments.isEmpty()) {
            request.setAttribute("error",
                    "No data found for selected date range!");
        } else {
            request.setAttribute("payments", payments);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
        }

        request.getRequestDispatcher("/jsp/report/report.jsp")
                .forward(request, response);
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }
}