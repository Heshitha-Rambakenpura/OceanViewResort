package com.oceanview.dao;

import com.oceanview.model.Room;
import com.oceanview.model.RoomType;
import com.oceanview.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * RoomDAO - Handles all database operations for Room
 * @version 1.0.0
 */
public class RoomDAO {

    private Connection connection;

    public RoomDAO() {
        this.connection = DatabaseConnection
                .getInstance().getConnection();
    }

    // ─── GET ALL ROOMS ───
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, " +
                "rt.base_price, rt.amenities, " +
                "rt.description as type_description " +
                "FROM rooms r " +
                "JOIN room_types rt " +
                "ON r.room_type_id = rt.room_type_id " +
                "ORDER BY r.room_id";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get all rooms error: "
                    + e.getMessage());
        }
        return rooms;
    }

    // ─── GET ROOM BY ID ───
    public Room getRoomById(int roomId) {
        String sql = "SELECT r.*, rt.type_name, " +
                "rt.base_price, rt.amenities, " +
                "rt.description as type_description " +
                "FROM rooms r " +
                "JOIN room_types rt " +
                "ON r.room_type_id = rt.room_type_id " +
                "WHERE r.room_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToRoom(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get room by ID error: "
                    + e.getMessage());
        }
        return null;
    }

    // ─── GET AVAILABLE ROOMS ───
    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, " +
                "rt.base_price, rt.amenities, " +
                "rt.description as type_description " +
                "FROM rooms r " +
                "JOIN room_types rt " +
                "ON r.room_type_id = rt.room_type_id " +
                "WHERE r.is_available = TRUE " +
                "ORDER BY r.room_id";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get available rooms error: "
                    + e.getMessage());
        }
        return rooms;
    }

    // ─── GET AVAILABLE ROOMS BY DATE ───
    public List<Room> getAvailableRoomsByDate(String checkIn,
                                              String checkOut) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, " +
                "rt.base_price, rt.amenities, " +
                "rt.description as type_description " +
                "FROM rooms r " +
                "JOIN room_types rt " +
                "ON r.room_type_id = rt.room_type_id " +
                "WHERE r.is_available = TRUE " +
                "AND r.room_id NOT IN ( " +
                "    SELECT res.room_id " +
                "    FROM reservations res " +
                "    WHERE res.status != 'CANCELLED' " +
                "    AND NOT ( " +
                "        res.check_out_date <= ? " +
                "        OR res.check_in_date >= ? " +
                "    ) " +
                ")";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, checkIn);
            ps.setString(2, checkOut);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get available rooms by date: "
                    + e.getMessage());
        }
        return rooms;
    }

    // ─── CHECK AVAILABILITY ───
    public boolean checkAvailability(int roomId,
                                     String checkIn,
                                     String checkOut) {
        String sql = "SELECT r.room_id FROM rooms r " +
                "WHERE r.room_id = ? " +
                "AND r.is_available = TRUE " +
                "AND r.room_id NOT IN ( " +
                "    SELECT res.room_id " +
                "    FROM reservations res " +
                "    WHERE res.room_id = ? " +
                "    AND res.status != 'CANCELLED' " +
                "    AND NOT ( " +
                "        res.check_out_date <= ? " +
                "        OR res.check_in_date >= ? " +
                "    ) " +
                ")";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roomId);
            ps.setInt(2, roomId);
            ps.setString(3, checkIn);
            ps.setString(4, checkOut);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("Check availability error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── SAVE ROOM ───
    public boolean saveRoom(Room room) {
        String sql = "INSERT INTO rooms " +
                "(room_number, room_type_id, " +
                "floor_number, max_occupancy, " +
                "is_available, description) " +
                "VALUES (?, ?, ?, ?, TRUE, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(
                    sql,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomType().getRoomTypeId());
            ps.setInt(3, room.getFloorNumber());
            ps.setInt(4, room.getMaxOccupancy());
            ps.setString(5, room.getDescription());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    room.setRoomId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Save room error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── UPDATE ROOM ───
    public boolean updateRoom(Room room) {
        String sql = "UPDATE rooms SET " +
                "room_number = ?, room_type_id = ?, " +
                "floor_number = ?, max_occupancy = ?, " +
                "description = ? " +
                "WHERE room_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomType().getRoomTypeId());
            ps.setInt(3, room.getFloorNumber());
            ps.setInt(4, room.getMaxOccupancy());
            ps.setString(5, room.getDescription());
            ps.setInt(6, room.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update room error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── DELETE ROOM ───
    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Delete room error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── UPDATE AVAILABILITY ───
    public boolean updateAvailability(int roomId,
                                      boolean isAvailable) {
        String sql = "UPDATE rooms SET is_available = ? " +
                "WHERE room_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, isAvailable);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update availability error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── MAP RESULT SET TO ROOM ───
    public Room mapResultSetToRoom(ResultSet rs)
            throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setFloorNumber(rs.getInt("floor_number"));
        room.setMaxOccupancy(rs.getInt("max_occupancy"));
        room.setAvailable(rs.getBoolean("is_available"));
        room.setDescription(rs.getString("description"));

        RoomType roomType = new RoomType();
        roomType.setRoomTypeId(rs.getInt("room_type_id"));
        roomType.setTypeName(rs.getString("type_name"));
        roomType.setBasePrice(rs.getDouble("base_price"));
        roomType.setAmenities(rs.getString("amenities"));
        roomType.setDescription(rs.getString(
                "type_description"));
        room.setRoomType(roomType);
        return room;
    }
}