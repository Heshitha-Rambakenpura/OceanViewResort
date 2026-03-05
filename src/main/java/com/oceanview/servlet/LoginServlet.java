package com.oceanview.servlet;

import com.oceanview.controller.UserController;
import com.oceanview.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet - Handles login requests
 * @version 1.0.0
 */
public class LoginServlet extends HttpServlet {

    private UserController userController;

    @Override
    public void init() {
        this.userController = new UserController();
    }

    // ─── GET - Show Login Page ───
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in redirect to dashboard
        HttpSession session = request.getSession(false);
        if (session != null
                && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            response.sendRedirect(request.getContextPath()
                    + user.getDashboardURL());
            return;
        }
        request.getRequestDispatcher("/jsp/auth/login.jsp")
                .forward(request, response);
    }

    // ─── POST - Process Login ───
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate not empty
        if (username == null || username.isEmpty()
                || password == null || password.isEmpty()) {
            request.setAttribute("error",
                    "Username and password are required!");
            request.getRequestDispatcher("/jsp/auth/login.jsp")
                    .forward(request, response);
            return;
        }

        String ipAddress = request.getRemoteAddr();
        User user        = userController.verifyLogin(
                username, password,
                0, ipAddress);

        if (user == null) {
            request.setAttribute("error",
                    "Invalid username or password!");
            request.getRequestDispatcher("/jsp/auth/login.jsp")
                    .forward(request, response);
            return;
        }

        // ─── Create Session ───
        HttpSession newSession = request.getSession();
        newSession.setAttribute("user", user);
        newSession.setAttribute("userId", user.getUserId());
        newSession.setAttribute("userName", user.getName());
        newSession.setAttribute("userRole", user.getRole());
        newSession.setMaxInactiveInterval(30 * 60);

        // ─── Debug - print role to console ───
        System.out.println("Login: " + username
                + " Role: " + user.getRole());

        // ─── Redirect Based on Role ───
        String role = user.getRole();

        if ("ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath()
                    + "/jsp/auth/admin_dashboard.jsp");

        } else if ("FINANCE".equals(role)) {
            response.sendRedirect(request.getContextPath()
                    + "/jsp/auth/finance_dashboard.jsp");

        } else {
            // RECEPTIONIST
            response.sendRedirect(request.getContextPath()
                    + "/jsp/auth/receptionist_dashboard.jsp");
        }
    }
}