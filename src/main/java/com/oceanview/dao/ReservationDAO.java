package com.oceanview.dao;

import com.oceanview.model.*;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ReservationDAO - DAO Pattern (Structural Pattern)
 * Handles all database operations for Reservation
 * @version 1.0.0
 */
public class ReservationDAO {

    private Connection connection;

    public ReservationDAO() {
        this.connection = DatabaseConnection.getInstance().getConnection();
    }

    // ─── SAVE RESERVATION ───
    public boolean saveReservation(Reservation reservation) {
        String sql = "INSERT INTO reservations (guest_id, room_id, " +
                "check_in_date, check_out_date, status, " +
                "number_of_nights, number_of_guests, " +
                "special_requests, created_by) " +
                "VALUES (?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement ps = connection.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, reservation.getGuest().getGuestId());
            ps.setInt(2, reservation.getRoom().getRoomId());
            ps.setDate(3, Date.valueOf(reservation.getCheckInDate()));
            ps.setDate(4, Date.valueOf(reservation.getCheckOutDate()));
            ps.setString(5, reservation.getStatus());
            ps.setInt(6, reservation.getNumberOfNights());
            ps.setInt(7, reservation.getNumberOfGuests());
            ps.setString(8, reservation.getSpecialRequests());
            ps.setInt(9, reservation.getCreatedBy());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    reservation.setReservationId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Save reservation error: " + e.getMessage());
        }
        return false;
    }

    // ─── GET RESERVATION BY ID ───
    public Reservation getReservationById(int reservationId) {
        String sql = "SELECT r.*, g.name as guest_name, g.nic, " +
                "g.email, g.contact_number, " +
                "ro.room_number, rt.type_name, rt.base_price " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms ro ON r.room_id = ro.room_id " +
                "JOIN room_types rt ON ro.room_type_id = rt.room_type_id " +
                "WHERE r.reservation_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get reservation error: " + e.getMessage());
        }
        return null;
    }

    // ─── GET ALL RESERVATIONS ───
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, g.name as guest_name, " +
                "ro.room_number, rt.type_name, rt.base_price " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms ro ON r.room_id = ro.room_id " +
                "JOIN room_types rt ON ro.room_type_id = rt.room_type_id " +
                "ORDER BY r.created_date DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get all reservations error: " + e.getMessage());
        }
        return list;
    }

    // ─── UPDATE STATUS ───
    public boolean updateStatus(int reservationId, String status) {
        String sql = "UPDATE reservations SET status = ? " +
                "WHERE reservation_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update status error: " + e.getMessage());
        }
        return false;
    }

    // ─── MAP RESULT SET ───
    private Reservation mapResultSetToReservation(ResultSet rs)
            throws SQLException {
        Reservation res = new Reservation();
        res.setReservationId(rs.getInt("reservation_id"));
        res.setStatus(rs.getString("status"));
        res.setNumberOfNights(rs.getInt("number_of_nights"));
        res.setNumberOfGuests(rs.getInt("number_of_guests"));
        res.setSpecialRequests(rs.getString("special_requests"));
        res.setCreatedBy(rs.getInt("created_by"));
        res.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        res.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());

        Guest guest = new Guest();
        guest.setGuestId(rs.getInt("guest_id"));
        guest.setName(rs.getString("guest_name"));
        res.setGuest(guest);

        RoomType roomType = new RoomType();
        roomType.setTypeName(rs.getString("type_name"));
        roomType.setBasePrice(rs.getDouble("base_price"));

        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(roomType);
        res.setRoom(room);

        return res;
    }
}