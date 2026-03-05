package com.oceanview.servlet;

import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * RoomServlet - Handles room management
 * @version 1.0.0
 */
public class RoomServlet extends HttpServlet {

    private RoomDAO roomDAO;

    @Override
    public void init() {
        this.roomDAO = new RoomDAO();
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

        // Get all rooms with full details
        List<Room> allRooms    = roomDAO.getAllRooms();
        List<Room> availRooms  = roomDAO.getAvailableRooms();

        request.setAttribute("allRooms", allRooms);
        request.setAttribute("availableCount", availRooms.size());
        request.setAttribute("totalCount", allRooms.size());
        request.setAttribute("occupiedCount",
                allRooms.size() - availRooms.size());

        request.getRequestDispatcher("/jsp/room/room_list.jsp")
                .forward(request, response);
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }
}