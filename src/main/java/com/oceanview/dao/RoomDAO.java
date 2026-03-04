package com.oceanview.dao;

import com.oceanview.model.Room;
import com.oceanview.model.RoomType;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * RoomDAO - DAO Pattern (Structural Pattern)
 * Handles all database operations for Room
 * @version 1.0.0
 */
public class RoomDAO {

    private Connection connection;

    public RoomDAO() {
        this.connection = DatabaseConnection.getInstance().getConnection();
    }

    // ─── CHECK AVAILABILITY ───
    public boolean checkAvailability(int roomId,
                                     String checkIn,
                                     String checkOut) {
        String sql = "SELECT r.is_available FROM rooms r " +
                "WHERE r.room_id = ? AND r.is_available = TRUE " +
                "AND r.room_id NOT IN ( " +
                "SELECT room_id FROM reservations " +
                "WHERE status != 'CANCELLED' " +
                "AND check_in_date < ? " +
                "AND check_out_date > ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roomId);
            ps.setString(2, checkOut);
            ps.setString(3, checkIn);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("Check availability error: " + e.getMessage());
        }
        return false;
    }

    // ─── GET ALL AVAILABLE ROOMS ───
    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, rt.base_price, " +
                "rt.amenities FROM rooms r " +
                "JOIN room_types rt " +
                "ON r.room_type_id = rt.room_type_id " +
                "WHERE r.is_available = TRUE";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get available rooms error: " + e.getMessage());
        }
        return rooms;
    }

    // ─── GET ALL ROOMS ───
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, rt.base_price, " +
                "rt.amenities FROM rooms r " +
                "JOIN room_types rt " +
                "ON r.room_type_id = rt.room_type_id";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get all rooms error: " + e.getMessage());
        }
        return rooms;
    }

    // ─── UPDATE AVAILABILITY ───
    public boolean updateAvailability(int roomId, boolean isAvailable) {
        String sql = "UPDATE rooms SET is_available = ? " +
                "WHERE room_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, isAvailable);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update availability error: " + e.getMessage());
        }
        return false;
    }

    // ─── MAP RESULT SET ───
    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        RoomType roomType = new RoomType();
        roomType.setTypeName(rs.getString("type_name"));
        roomType.setBasePrice(rs.getDouble("base_price"));
        roomType.setAmenities(rs.getString("amenities"));

        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setFloorNumber(rs.getInt("floor_number"));
        room.setMaxOccupancy(rs.getInt("max_occupancy"));
        room.setAvailable(rs.getBoolean("is_available"));
        room.setRoomType(roomType);
        return room;
    }
}