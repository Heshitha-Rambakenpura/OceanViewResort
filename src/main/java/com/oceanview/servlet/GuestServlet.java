package com.oceanview.servlet;

import com.oceanview.controller.GuestController;
import com.oceanview.model.Guest;
import com.oceanview.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * GuestServlet - Handles guest operations
 * @version 1.0.0
 */
public class GuestServlet extends HttpServlet {

    private GuestController guestController;

    @Override
    public void init() {
        this.guestController = new GuestController();
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

        String action = request.getParameter("action");

        if ("list".equals(action)) {
            List<Guest> guests = guestController.getAllGuests();
            request.setAttribute("guests", guests);
            request.getRequestDispatcher(
                            "/jsp/guest/guest_list.jsp")
                    .forward(request, response);
        } else {
            request.getRequestDispatcher(
                            "/jsp/guest/register_guest.jsp")
                    .forward(request, response);
        }
    }

    // ─── POST ───
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String name          = request.getParameter("name");
        String idType        = request.getParameter("idType");
        String nic           = request.getParameter("nic");
        String nationality   = request.getParameter("nationality");
        String address       = request.getParameter("address");
        String contactNumber = request.getParameter(
                "contactNumber");
        String email         = request.getParameter("email");
        String ipAddress     = request.getRemoteAddr();

        HttpSession session  = request.getSession();
        User user            = (User) session.getAttribute("user");

        // ─── BACKEND VALIDATION ───
        String validationError = validateGuest(
                name, idType, nic, nationality,
                contactNumber, email);

        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.setAttribute("idType", idType);
            request.getRequestDispatcher(
                            "/jsp/guest/register_guest.jsp")
                    .forward(request, response);
            return;
        }

        Guest guest = new Guest(name, nic, nationality,
                address, contactNumber, email);

        String result = guestController.registerGuest(
                guest, user.getUserId(), ipAddress);

        if ("SUCCESS".equals(result)) {
            request.setAttribute("success",
                    "Guest registered successfully! Guest ID: "
                            + guest.getGuestId());
        } else if ("DUPLICATE_NIC".equals(result)) {
            request.setAttribute("error",
                    "Guest with this NIC/Passport already exists!");
            request.setAttribute("idType", idType);
        } else {
            request.setAttribute("error",
                    "Failed to register guest! Please try again.");
            request.setAttribute("idType", idType);
        }

        request.getRequestDispatcher(
                        "/jsp/guest/register_guest.jsp")
                .forward(request, response);
    }

    // ─── VALIDATE GUEST ───
    private String validateGuest(String name,
                                 String idType,
                                 String nic,
                                 String nationality,
                                 String contactNumber,
                                 String email) {

        // ─── Name - letters and spaces only ───
        if (name == null || name.trim().isEmpty()) {
            return "Name is required!";
        }
        if (!name.matches("[a-zA-Z ]+")) {
            return "Name must contain letters only!";
        }

        // ─── NIC or Passport ───
        if (nic == null || nic.trim().isEmpty()) {
            return "NIC or Passport is required!";
        }

        if ("NIC".equals(idType)) {
            // Old NIC: 9 digits + V or X
            // New NIC: 12 digits
            if (!nic.matches("[0-9]{9}[VvXx]")
                    && !nic.matches("[0-9]{12}")) {
                return "Invalid NIC! Use 9 digits + V/X "
                        + "(e.g. 123456789V) or "
                        + "12 digits (e.g. 200012345678)";
            }
        } else if ("PASSPORT".equals(idType)) {
            // Passport: 1-2 letters + 6-7 digits
            if (!nic.matches("[a-zA-Z]{1,2}[0-9]{6,7}")) {
                return "Invalid Passport! Use 1-2 letters + "
                        + "6-7 digits (e.g. N1234567)";
            }
        } else {
            return "Please select NIC or Passport!";
        }

        // ─── Nationality - letters only ───
        if (nationality == null
                || nationality.trim().isEmpty()) {
            return "Nationality is required!";
        }
        if (!nationality.matches("[a-zA-Z ]+")) {
            return "Nationality must contain letters only!";
        }

        // ─── Contact - 10 digits ───
        if (contactNumber == null
                || contactNumber.trim().isEmpty()) {
            return "Contact number is required!";
        }
        if (!contactNumber.matches("[0-9]{10}")) {
            return "Contact number must be 10 digits only!";
        }

        // ─── Email ───
        if (email == null || email.trim().isEmpty()) {
            return "Email is required!";
        }
        if (!email.matches(
                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")) {
            return "Invalid email address!";
        }

        return null;
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }
}