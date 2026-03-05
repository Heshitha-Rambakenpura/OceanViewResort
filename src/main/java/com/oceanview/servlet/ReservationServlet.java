package com.oceanview.servlet;

import com.oceanview.controller.ReservationController;
import com.oceanview.model.*;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * ReservationServlet - Handles reservation operations
 * @version 1.0.0
 */

public class ReservationServlet extends HttpServlet {

    private ReservationController reservationController;

    @Override
    public void init() {
        this.reservationController = new ReservationController();
    }

    // ─── GET - Show Reservation Page ───
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("list".equals(action)) {
            List<Reservation> reservations = reservationController
                    .getAllReservations();
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher(
                            "/jsp/reservation/reservation_list.jsp")
                    .forward(request, response);
        } else if ("view".equals(action)) {
            int reservationId = Integer.parseInt(
                    request.getParameter("id"));
            Reservation reservation = reservationController
                    .getReservationById(
                            reservationId);
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher(
                            "/jsp/reservation/view_reservation.jsp")
                    .forward(request, response);
        } else if ("cancel".equals(action)) {
            int reservationId = Integer.parseInt(
                    request.getParameter("id"));
            HttpSession session  = request.getSession();
            User user            = (User) session.getAttribute("user");
            String ipAddress     = request.getRemoteAddr();
            String result        = reservationController
                    .cancelReservation(
                            reservationId,
                            user.getUserId(),
                            ipAddress);
            response.sendRedirect(request.getContextPath()
                    + "/reservation?action=list");
        } else {
            // Show add reservation form
            List<Room> availableRooms = reservationController
                    .getAvailableRooms();
            request.setAttribute("rooms", availableRooms);
            request.getRequestDispatcher(
                            "/jsp/reservation/add_reservation.jsp")
                    .forward(request, response);
        }
    }

    // ─── POST - Add Reservation ───
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        int guestId       = Integer.parseInt(
                request.getParameter("guestId"));
        int roomId        = Integer.parseInt(
                request.getParameter("roomId"));
        String checkIn    = request.getParameter("checkInDate");
        String checkOut   = request.getParameter("checkOutDate");
        int numGuests     = Integer.parseInt(
                request.getParameter("numberOfGuests"));
        String special    = request.getParameter("specialRequests");
        String ipAddress  = request.getRemoteAddr();

        HttpSession session = request.getSession();
        User user           = (User) session.getAttribute("user");

        // Build reservation object
        Guest guest = new Guest();
        guest.setGuestId(guestId);

        Room room = new Room();
        room.setRoomId(roomId);

        Reservation reservation = new Reservation(
                guest, room,
                LocalDate.parse(checkIn),
                LocalDate.parse(checkOut),
                numGuests, special,
                user.getUserId()
        );

        String result = reservationController.addReservation(
                reservation,
                user.getUserId(),
                ipAddress);

        if ("SUCCESS".equals(result)) {
            request.setAttribute("success",
                    "Reservation added successfully!");
        } else if ("GUEST_NOT_FOUND".equals(result)) {
            request.setAttribute("error",
                    "Guest not found! Please register guest first.");
        } else if ("ROOM_NOT_AVAILABLE".equals(result)) {
            request.setAttribute("error",
                    "Room not available for selected dates!");
        } else {
            request.setAttribute("error",
                    "Error adding reservation. Please try again.");
        }

        List<Room> availableRooms = reservationController
                .getAvailableRooms();
        request.setAttribute("rooms", availableRooms);
        request.getRequestDispatcher(
                        "/jsp/reservation/add_reservation.jsp")
                .forward(request, response);
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }
}