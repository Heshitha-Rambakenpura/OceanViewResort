package com.oceanview.servlet;

import com.oceanview.controller.ReportController;
import com.oceanview.model.Payment;
import com.oceanview.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
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

        String action    = request.getParameter("action");
        HttpSession session  = request.getSession();
        User user        = (User) session.getAttribute("user");
        String ipAddress = request.getRemoteAddr();

        // ─── EXPORT CSV ───
        if ("export".equals(action)) {
            String startDate = request.getParameter(
                                   "startDate");
            String endDate   = request.getParameter(
                                   "endDate");

            if (startDate == null || startDate.isEmpty()) {
                startDate = LocalDate.now()
                                .withDayOfMonth(1)
                                .toString();
            }
            if (endDate == null || endDate.isEmpty()) {
                endDate = LocalDate.now().toString();
            }

            List<Payment> payments = reportController
                                       .exportReport(
                                           startDate,
                                           endDate,
                                           user.getUserId(),
                                           ipAddress);

            double total = reportController
                             .getTotalIncomeByDateRange(
                                 startDate, endDate);

            // ─── Set CSV response headers ───
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition",
                "attachment; filename=\"OceanViewReport_"
                + startDate + "_to_"
                + endDate + ".csv\"");

            PrintWriter writer = response.getWriter();

            // ─── CSV Header ───
            writer.println(
                "Receipt No,Guest,Room," +
                "Reservation ID,Amount," +
                "Method,Date,Status");

            // ─── CSV Rows ───
            for (Payment p : payments) {
                String guestName = "";
                String roomNum   = "";
                int resId        = 0;

                if (p.getBill() != null
                        && p.getBill().getReservation()
                           != null) {
                    if (p.getBill().getReservation()
                           .getGuest() != null) {
                        guestName = p.getBill()
                                     .getReservation()
                                     .getGuest().getName();
                    }
                    if (p.getBill().getReservation()
                           .getRoom() != null) {
                        roomNum = p.getBill()
                                   .getReservation()
                                   .getRoom().getRoomNumber();
                    }
                    resId = p.getBill()
                              .getReservation()
                              .getReservationId();
                }

                writer.println(
                    p.getReceiptNumber() + "," +
                    guestName + "," +
                    roomNum + "," +
                    resId + "," +
                    p.getAmount() + "," +
                    p.getPaymentMethod() + "," +
                    p.getPaymentDate() + "," +
                    p.getPaymentStatus()
                );
            }

            // ─── CSV Total ───
            writer.println("");
            writer.println(",,,, Total Income: Rs."
                           + total + ",,,");
            writer.flush();
            return;
        }

        // ─── VIEW REPORT ───
        String startDate = request.getParameter("startDate");
        String endDate   = request.getParameter("endDate");

        // Default to current month
        if (startDate == null || startDate.isEmpty()) {
            startDate = LocalDate.now()
                            .withDayOfMonth(1)
                            .toString();
        }
        if (endDate == null || endDate.isEmpty()) {
            endDate = LocalDate.now().toString();
        }

        List<Payment> payments = reportController
                                   .generateReport(
                                       startDate, endDate,
                                       user.getUserId(),
                                       ipAddress);

        double totalIncome = reportController
                               .getTotalIncomeByDateRange(
                                   startDate, endDate);

        request.setAttribute("payments", payments);
        request.setAttribute("totalIncome", totalIncome);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.getRequestDispatcher(
            "/jsp/report/report.jsp")
               .forward(request, response);
    }

    // ─── POST ───
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        // Forward all POST to GET handler
        doGet(request, response);
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
               && session.getAttribute("user") != null;
    }
}