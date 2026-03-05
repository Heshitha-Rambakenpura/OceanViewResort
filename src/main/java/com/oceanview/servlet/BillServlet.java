package com.oceanview.servlet;

import com.oceanview.controller.ReservationController;
import com.oceanview.dao.BillDAO;
import com.oceanview.model.Bill;
import com.oceanview.model.Reservation;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

/**
 * BillServlet - Handles bill viewing
 * @version 1.0.0
 */
@WebServlet("/bill")
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
        // Check session
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

        // Get reservation with full details
        Reservation reservation = reservationController
                .getReservationById(
                        reservationId);

        // Get bill for this reservation
        Bill bill = billDAO.getBillByReservationId(reservationId);

        if (bill == null || reservation == null) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/reservation?action=list");
            return;
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