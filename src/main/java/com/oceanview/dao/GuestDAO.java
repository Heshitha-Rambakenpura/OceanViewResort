package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * GuestDAO - DAO Pattern (Structural Pattern)
 * Handles all database operations for Guest
 * @version 1.0.0
 */
public class GuestDAO {

    private Connection connection;

    public GuestDAO() {
        this.connection = DatabaseConnection.getInstance().getConnection();
    }

    // ─── CHECK NIC EXISTS ───
    public boolean checkNICExists(String nic) {
        String sql = "SELECT guest_id FROM guests WHERE nic = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, nic);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("Check NIC error: " + e.getMessage());
        }
        return false;
    }

    // ─── SAVE GUEST ───
    public boolean saveGuest(Guest guest) {
        String sql = "INSERT INTO guests (name, nic, nationality, " +
                "address, contact_number, email) VALUES (?,?,?,?,?,?)";
        try {
            PreparedStatement ps = connection.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, guest.getName());
            ps.setString(2, guest.getNic());
            ps.setString(3, guest.getNationality());
            ps.setString(4, guest.getAddress());
            ps.setString(5, guest.getContactNumber());
            ps.setString(6, guest.getEmail());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    guest.setGuestId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Save guest error: " + e.getMessage());
        }
        return false;
    }

    // ─── GET GUEST BY ID ───
    public Guest getGuestById(int guestId) {
        String sql = "SELECT * FROM guests WHERE guest_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, guestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToGuest(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get guest error: " + e.getMessage());
        }
        return null;
    }

    // ─── GET GUEST BY NIC ───
    public Guest getGuestByNIC(String nic) {
        String sql = "SELECT * FROM guests WHERE nic = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, nic);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToGuest(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get guest by NIC error: " + e.getMessage());
        }
        return null;
    }

    // ─── GET ALL GUESTS ───
    public List<Guest> getAllGuests() {
        List<Guest> guests = new ArrayList<>();
        String sql = "SELECT * FROM guests ORDER BY name";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                guests.add(mapResultSetToGuest(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get all guests error: " + e.getMessage());
        }
        return guests;
    }

    // ─── MAP RESULT SET TO GUEST ───
    private Guest mapResultSetToGuest(ResultSet rs) throws SQLException {
        Guest guest = new Guest();
        guest.setGuestId(rs.getInt("guest_id"));
        guest.setName(rs.getString("name"));
        guest.setNic(rs.getString("nic"));
        guest.setNationality(rs.getString("nationality"));
        guest.setAddress(rs.getString("address"));
        guest.setContactNumber(rs.getString("contact_number"));
        guest.setEmail(rs.getString("email"));
        return guest;
    }
}