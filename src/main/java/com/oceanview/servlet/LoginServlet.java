package com.oceanview.servlet;

import com.oceanview.controller.UserController;
import com.oceanview.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

/**
 * LoginServlet - Handles login requests
 * @version 1.0.0
 */
@WebServlet("/login")
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
        if (session != null && session.getAttribute("user") != null) {
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
        String username  = request.getParameter("username");
        String password  = request.getParameter("password");
        String ipAddress = request.getRemoteAddr();

        // Validate not empty
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error",
                    "Username and password are required!");
            request.getRequestDispatcher("/jsp/auth/login.jsp")
                    .forward(request, response);
            return;
        }

        // Verify login through controller
        User user = userController.verifyLogin(
                username.trim(), password.trim(), ipAddress);

        if (user != null) {
            // Login successful - create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 mins

            // Redirect to correct dashboard based on role
            response.sendRedirect(request.getContextPath()
                    + user.getDashboardURL());
        } else {
            // Login failed
            request.setAttribute("error", "Invalid credentials!");
            request.getRequestDispatcher("/jsp/auth/login.jsp")
                    .forward(request, response);
        }
    }
}