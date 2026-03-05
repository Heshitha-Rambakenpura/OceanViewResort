package com.oceanview.servlet;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.Room;
import com.oceanview.model.RoomType;
import com.oceanview.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * RoomServlet - Handles room and room type management
 * @version 1.0.0
 */
public class RoomServlet extends HttpServlet {

    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        this.roomDAO     = new RoomDAO();
        this.roomTypeDAO = new RoomTypeDAO();
        this.auditLogDAO = new AuditLogDAO();
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
        String role      = (String) session
                .getAttribute("userRole");

        // ─── DELETE ROOM ───
        if ("deleteRoom".equals(action)) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(
                        request.getContextPath() + "/login");
                return;
            }
            int roomId = Integer.parseInt(
                    request.getParameter("roomId"));
            boolean deleted = roomDAO.deleteRoom(roomId);
            if (deleted) {
                auditLogDAO.logAction(user.getUserId(),
                        "ROOM_DELETED - ID:" + roomId,
                        ipAddress);
            }
            response.sendRedirect(
                    request.getContextPath()
                            + "/room?action=manageRooms");

            // ─── DELETE ROOM TYPE ───
        } else if ("deleteRoomType".equals(action)) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(
                        request.getContextPath() + "/login");
                return;
            }
            int roomTypeId = Integer.parseInt(
                    request.getParameter(
                            "roomTypeId"));
            boolean deleted = roomTypeDAO.deleteRoomType(
                    roomTypeId);
            if (deleted) {
                auditLogDAO.logAction(user.getUserId(),
                        "ROOM_TYPE_DELETED - ID:" + roomTypeId,
                        ipAddress);
            }
            response.sendRedirect(
                    request.getContextPath()
                            + "/room?action=manageRoomTypes");

            // ─── MANAGE ROOMS PAGE ───
        } else if ("manageRooms".equals(action)) {
            List<Room> rooms         = roomDAO.getAllRooms();
            List<RoomType> roomTypes = roomTypeDAO
                    .getAllRoomTypes();
            request.setAttribute("rooms", rooms);
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("totalCount", rooms.size());
            request.setAttribute("availableCount",
                    roomDAO.getAvailableRooms().size());
            request.setAttribute("occupiedCount",
                    rooms.size()
                            - roomDAO.getAvailableRooms().size());
            request.getRequestDispatcher(
                            "/jsp/room/manage_rooms.jsp")
                    .forward(request, response);

            // ─── MANAGE ROOM TYPES PAGE ───
        } else if ("manageRoomTypes".equals(action)) {
            List<RoomType> roomTypes = roomTypeDAO
                    .getAllRoomTypes();
            request.setAttribute("roomTypes", roomTypes);
            request.getRequestDispatcher(
                            "/jsp/room/manage_room_types.jsp")
                    .forward(request, response);

            // ─── DEFAULT - ROOM LIST (RECEPTIONIST VIEW) ───
        } else {
            List<Room> rooms         = roomDAO.getAllRooms();
            List<RoomType> roomTypes = roomTypeDAO
                    .getAllRoomTypes();
            request.setAttribute("allRooms", rooms);
            request.setAttribute("availableCount",
                    roomDAO.getAvailableRooms().size());
            request.setAttribute("totalCount", rooms.size());
            request.setAttribute("occupiedCount",
                    rooms.size()
                            - roomDAO.getAvailableRooms().size());
            request.getRequestDispatcher(
                            "/jsp/room/room_list.jsp")
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
        if (!isAdmin(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String formAction = request.getParameter("formAction");
        String ipAddress  = request.getRemoteAddr();
        HttpSession session = request.getSession();
        User user         = (User) session.getAttribute("user");

        // ─── SAVE ROOM TYPE ───
        if ("saveRoomType".equals(formAction)) {
            String typeName    = request.getParameter(
                    "typeName");
            String description = request.getParameter(
                    "description");
            double basePrice   = Double.parseDouble(
                    request.getParameter(
                            "basePrice"));
            String amenities   = request.getParameter(
                    "amenities");

            RoomType roomType  = new RoomType();
            roomType.setTypeName(typeName);
            roomType.setDescription(description);
            roomType.setBasePrice(basePrice);
            roomType.setAmenities(amenities);

            boolean saved = roomTypeDAO.saveRoomType(roomType);
            if (saved) {
                auditLogDAO.logAction(user.getUserId(),
                        "ROOM_TYPE_ADDED - " + typeName,
                        ipAddress);
                request.setAttribute("success",
                        "Room type added successfully!");
            } else {
                request.setAttribute("error",
                        "Failed to add room type!");
            }

            request.setAttribute("roomTypes",
                    roomTypeDAO.getAllRoomTypes());
            request.getRequestDispatcher(
                            "/jsp/room/manage_room_types.jsp")
                    .forward(request, response);

            // ─── UPDATE ROOM TYPE ───
        } else if ("updateRoomType".equals(formAction)) {
            int roomTypeId     = Integer.parseInt(
                    request.getParameter(
                            "roomTypeId"));
            String typeName    = request.getParameter(
                    "typeName");
            String description = request.getParameter(
                    "description");
            double basePrice   = Double.parseDouble(
                    request.getParameter(
                            "basePrice"));
            String amenities   = request.getParameter(
                    "amenities");

            RoomType roomType  = new RoomType();
            roomType.setRoomTypeId(roomTypeId);
            roomType.setTypeName(typeName);
            roomType.setDescription(description);
            roomType.setBasePrice(basePrice);
            roomType.setAmenities(amenities);

            boolean updated = roomTypeDAO.updateRoomType(
                    roomType);
            if (updated) {
                auditLogDAO.logAction(user.getUserId(),
                        "ROOM_TYPE_UPDATED - ID:" + roomTypeId,
                        ipAddress);
                request.setAttribute("success",
                        "Room type updated successfully!");
            } else {
                request.setAttribute("error",
                        "Failed to update room type!");
            }

            request.setAttribute("roomTypes",
                    roomTypeDAO.getAllRoomTypes());
            request.getRequestDispatcher(
                            "/jsp/room/manage_room_types.jsp")
                    .forward(request, response);

            // ─── SAVE ROOM ───
        } else if ("saveRoom".equals(formAction)) {
            String roomNumber  = request.getParameter(
                    "roomNumber");
            int roomTypeId     = Integer.parseInt(
                    request.getParameter(
                            "roomTypeId"));
            int floorNumber    = Integer.parseInt(
                    request.getParameter(
                            "floorNumber"));
            int maxOccupancy   = Integer.parseInt(
                    request.getParameter(
                            "maxOccupancy"));
            String description = request.getParameter(
                    "description");

            RoomType roomType  = new RoomType();
            roomType.setRoomTypeId(roomTypeId);

            Room room          = new Room();
            room.setRoomNumber(roomNumber);
            room.setRoomType(roomType);
            room.setFloorNumber(floorNumber);
            room.setMaxOccupancy(maxOccupancy);
            room.setDescription(description);
            room.setAvailable(true);

            boolean saved = roomDAO.saveRoom(room);
            if (saved) {
                auditLogDAO.logAction(user.getUserId(),
                        "ROOM_ADDED - " + roomNumber,
                        ipAddress);
                request.setAttribute("success",
                        "Room added successfully!");
            } else {
                request.setAttribute("error",
                        "Failed to add room!");
            }

            List<Room> rooms         = roomDAO.getAllRooms();
            List<RoomType> roomTypes = roomTypeDAO
                    .getAllRoomTypes();
            request.setAttribute("rooms", rooms);
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("totalCount", rooms.size());
            request.setAttribute("availableCount",
                    roomDAO.getAvailableRooms().size());
            request.setAttribute("occupiedCount",
                    rooms.size()
                            - roomDAO.getAvailableRooms().size());
            request.getRequestDispatcher(
                            "/jsp/room/manage_rooms.jsp")
                    .forward(request, response);

            // ─── UPDATE ROOM ───
        } else if ("updateRoom".equals(formAction)) {
            int roomId         = Integer.parseInt(
                    request.getParameter(
                            "roomId"));
            String roomNumber  = request.getParameter(
                    "roomNumber");
            int roomTypeId     = Integer.parseInt(
                    request.getParameter(
                            "roomTypeId"));
            int floorNumber    = Integer.parseInt(
                    request.getParameter(
                            "floorNumber"));
            int maxOccupancy   = Integer.parseInt(
                    request.getParameter(
                            "maxOccupancy"));
            String description = request.getParameter(
                    "description");

            RoomType roomType  = new RoomType();
            roomType.setRoomTypeId(roomTypeId);

            Room room          = new Room();
            room.setRoomId(roomId);
            room.setRoomNumber(roomNumber);
            room.setRoomType(roomType);
            room.setFloorNumber(floorNumber);
            room.setMaxOccupancy(maxOccupancy);
            room.setDescription(description);

            boolean updated = roomDAO.updateRoom(room);
            if (updated) {
                auditLogDAO.logAction(user.getUserId(),
                        "ROOM_UPDATED - ID:" + roomId,
                        ipAddress);
                request.setAttribute("success",
                        "Room updated successfully!");
            } else {
                request.setAttribute("error",
                        "Failed to update room!");
            }

            List<Room> rooms         = roomDAO.getAllRooms();
            List<RoomType> roomTypes = roomTypeDAO
                    .getAllRoomTypes();
            request.setAttribute("rooms", rooms);
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("totalCount", rooms.size());
            request.setAttribute("availableCount",
                    roomDAO.getAvailableRooms().size());
            request.setAttribute("occupiedCount",
                    rooms.size()
                            - roomDAO.getAvailableRooms().size());
            request.getRequestDispatcher(
                            "/jsp/room/manage_rooms.jsp")
                    .forward(request, response);
        }
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }

    // ─── CHECK ADMIN ───
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && "ADMIN".equals(
                session.getAttribute("userRole"));
    }
}