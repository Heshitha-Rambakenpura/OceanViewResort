package com.oceanview.dao;

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
 * RoomTypeDAO - Handles all database operations for RoomType
 * @version 1.0.0
 */
public class RoomTypeDAO {

    private Connection connection;

    public RoomTypeDAO() {
        this.connection = DatabaseConnection
                .getInstance().getConnection();
    }

    // ─── GET ALL ROOM TYPES ───
    public List<RoomType> getAllRoomTypes() {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_types " +
                "ORDER BY room_type_id";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                roomTypes.add(mapResultSetToRoomType(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get all room types error: "
                    + e.getMessage());
        }
        return roomTypes;
    }

    // ─── GET ROOM TYPE BY ID ───
    public RoomType getRoomTypeById(int roomTypeId) {
        String sql = "SELECT * FROM room_types " +
                "WHERE room_type_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToRoomType(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get room type error: "
                    + e.getMessage());
        }
        return null;
    }

    // ─── SAVE ROOM TYPE ───
    public boolean saveRoomType(RoomType roomType) {
        String sql = "INSERT INTO room_types " +
                "(type_name, description, " +
                "base_price, amenities) " +
                "VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(
                    sql,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, roomType.getTypeName());
            ps.setString(2, roomType.getDescription());
            ps.setDouble(3, roomType.getBasePrice());
            ps.setString(4, roomType.getAmenities());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    roomType.setRoomTypeId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Save room type error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── UPDATE ROOM TYPE ───
    public boolean updateRoomType(RoomType roomType) {
        String sql = "UPDATE room_types SET " +
                "type_name = ?, description = ?, " +
                "base_price = ?, amenities = ? " +
                "WHERE room_type_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, roomType.getTypeName());
            ps.setString(2, roomType.getDescription());
            ps.setDouble(3, roomType.getBasePrice());
            ps.setString(4, roomType.getAmenities());
            ps.setInt(5, roomType.getRoomTypeId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update room type error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── DELETE ROOM TYPE ───
    public boolean deleteRoomType(int roomTypeId) {
        String sql = "DELETE FROM room_types " +
                "WHERE room_type_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roomTypeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Delete room type error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── MAP RESULT SET TO ROOM TYPE ───
    private RoomType mapResultSetToRoomType(ResultSet rs)
            throws SQLException {
        RoomType roomType = new RoomType();
        roomType.setRoomTypeId(rs.getInt("room_type_id"));
        roomType.setTypeName(rs.getString("type_name"));
        roomType.setDescription(rs.getString("description"));
        roomType.setBasePrice(rs.getDouble("base_price"));
        roomType.setAmenities(rs.getString("amenities"));
        return roomType;
    }
}