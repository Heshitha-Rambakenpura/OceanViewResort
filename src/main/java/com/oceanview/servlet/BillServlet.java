package com.oceanview.servlet;

import com.oceanview.controller.ReservationController;
import com.oceanview.dao.BillDAO;
import com.oceanview.model.Bill;
import com.oceanview.model.Reservation;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;

/**
 * BillServlet - Handles bill viewing
 * @version 1.0.0
 */

public class BillServlet extends HttpServlet {

    private BillDAO billDAO;
    private ReservationController reservationController;

    @Override
    public void init() {
        this.billDAO                = new BillDAO();
        this.reservationController  = new ReservationController();
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

        String reservationIdParam =
                request.getParameter("reservationId");

        if (reservationIdParam == null
                || reservationIdParam.isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/reservation?action=list");
            return;
        }

        int reservationId = Integer.parseInt(reservationIdParam);

        // Check if JSON requested (from print bill page)
        String format = request.getParameter("format");

        Reservation reservation = reservationController
                .getReservationById(reservationId);
        Bill bill = billDAO.getBillByReservationId(reservationId);

        if (bill == null || reservation == null) {
            if ("json".equals(format)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"not found\"}");
            } else {
                response.sendRedirect(
                        request.getContextPath()
                                + "/reservation?action=list");
            }
            return;
        }

        bill.setReservation(reservation);

        if ("json".equals(format)) {
            // Return JSON for print bill page
            response.setContentType("application/json");
            String json = "{"
                    + "\"billId\":" + bill.getBillId() + ","
                    + "\"generatedDate\":\"" + bill.getGeneratedDate() + "\","
                    + "\"reservationId\":" + reservation.getReservationId() + ","
                    + "\"guestName\":\"" + reservation.getGuest().getName() + "\","
                    + "\"roomNumber\":\"" + reservation.getRoom().getRoomNumber() + "\","
                    + "\"roomType\":\"" + reservation.getRoom().getRoomType().getTypeName() + "\","
                    + "\"nights\":" + reservation.getNumberOfNights() + ","
                    + "\"basePrice\":" + reservation.getRoom().getRoomType().getBasePrice() + ","
                    + "\"totalAmount\":" + bill.getTotalAmount() + ","
                    + "\"taxAmount\":" + bill.getTaxAmount() + ","
                    + "\"discount\":" + bill.getDiscount() + ","
                    + "\"netAmount\":" + bill.getNetAmount() + ","
                    + "\"isPaid\":" + bill.isPaid()
                    + "}";
            response.getWriter().write(json);
        } else {
            request.setAttribute("bill", bill);
            request.getRequestDispatcher("/jsp/payment/bill.jsp")
                    .forward(request, response);
        }


        // Set reservation in bill for JSP
        bill.setReservation(reservation);

        request.setAttribute("bill", bill);
        request.getRequestDispatcher("/jsp/payment/bill.jsp")
                .forward(request, response);
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }
}