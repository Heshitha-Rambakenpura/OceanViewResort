package com.oceanview.servlet;

import com.oceanview.controller.UserController;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

/**
 * LogoutServlet - Handles logout requests
 * @version 1.0.0
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private UserController userController;

    @Override
    public void init() {
        this.userController = new UserController();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            int userId       = (int) session.getAttribute("userId");
            String ipAddress = request.getRemoteAddr();
            // Log logout action
            userController.logout(userId, ipAddress);
            // Invalidate session
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}