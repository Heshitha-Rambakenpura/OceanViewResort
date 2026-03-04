package com.oceanview.servlet;

import com.oceanview.controller.GuestController;
import com.oceanview.model.Guest;
import com.oceanview.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

/**
 * GuestServlet - Handles guest operations
 * @version 1.0.0
 */
@WebServlet("/guest")
public class GuestServlet extends HttpServlet {

    private GuestController guestController;

    @Override
    public void init() {
        this.guestController = new GuestController();
    }

    // ─── GET - Show Guest Page ───
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

        String action = request.getParameter("action");

        if ("list".equals(action)) {
            // Get all guests
            List<Guest> guests = guestController.getAllGuests();
            request.setAttribute("guests", guests);
            request.getRequestDispatcher("/jsp/guest/guest_list.jsp")
                    .forward(request, response);
        } else {
            // Show register form
            request.getRequestDispatcher(
                            "/jsp/guest/register_guest.jsp")
                    .forward(request, response);
        }
    }

    // ─── POST - Register Guest ───
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        // Check session
        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        // Get form data
        String name          = request.getParameter("name");
        String nic           = request.getParameter("nic");
        String nationality   = request.getParameter("nationality");
        String address       = request.getParameter("address");
        String contactNumber = request.getParameter("contactNumber");
        String email         = request.getParameter("email");
        String ipAddress     = request.getRemoteAddr();

        // Get logged in user
        HttpSession session = request.getSession();
        User user           = (User) session.getAttribute("user");

        // Create guest object
        Guest guest = new Guest(name, nic, nationality,
                address, contactNumber, email);

        // Register through controller
        String result = guestController.registerGuest(
                guest, user.getUserId(), ipAddress);

        if ("SUCCESS".equals(result)) {
            request.setAttribute("success",
                    "Guest registered successfully! Guest ID: "
                            + guest.getGuestId());
            request.getRequestDispatcher(
                            "/jsp/guest/register_guest.jsp")
                    .forward(request, response);
        } else if ("DUPLICATE_NIC".equals(result)) {
            request.setAttribute("error",
                    "Guest with this NIC already exists!");
            request.getRequestDispatcher(
                            "/jsp/guest/register_guest.jsp")
                    .forward(request, response);
        } else {
            request.setAttribute("error",
                    "Invalid details! Please check all fields.");
            request.getRequestDispatcher(
                            "/jsp/guest/register_guest.jsp")
                    .forward(request, response);
        }
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }
}