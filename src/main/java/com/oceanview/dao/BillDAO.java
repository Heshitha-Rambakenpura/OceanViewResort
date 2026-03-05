package com.oceanview.dao;

import com.oceanview.model.Bill;
import com.oceanview.model.Guest;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.RoomType;
import com.oceanview.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * BillDAO - Handles all database operations for Bill
 * @version 1.0.0
 */
public class BillDAO {

    private Connection connection;

    public BillDAO() {
        this.connection = DatabaseConnection
                .getInstance().getConnection();
    }

    // ─── SAVE BILL ───
    public boolean saveBill(Bill bill) {
        String sql = "INSERT INTO bills " +
                "(reservation_id, total_amount, " +
                "tax_amount, discount, net_amount, " +
                "is_paid, generated_date) " +
                "VALUES (?, ?, ?, ?, ?, FALSE, NOW())";
        try {
            PreparedStatement ps = connection.prepareStatement(
                    sql,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, bill.getReservation()
                    .getReservationId());
            ps.setDouble(2, bill.getTotalAmount());
            ps.setDouble(3, bill.getTaxAmount());
            ps.setDouble(4, bill.getDiscount());
            ps.setDouble(5, bill.getNetAmount());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    bill.setBillId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Save bill error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── GET BILL BY RESERVATION ID ───
    public Bill getBillByReservationId(int reservationId) {
        String sql = "SELECT b.*, " +
                "r.reservation_id, r.check_in_date, " +
                "r.check_out_date, r.number_of_nights, " +
                "r.number_of_guests, r.status, " +
                "g.guest_id, g.name as guest_name, " +
                "g.nic, g.email, g.phone, " +
                "ro.room_id, ro.room_number, " +
                "ro.floor_number, ro.max_occupancy, " +
                "ro.is_available, " +
                "ro.description as room_description, " +
                "rt.room_type_id, rt.type_name, " +
                "rt.base_price, rt.amenities, " +
                "rt.description as type_description " +
                "FROM bills b " +
                "JOIN reservations r " +
                "ON b.reservation_id = r.reservation_id " +
                "JOIN guests g " +
                "ON r.guest_id = g.guest_id " +
                "JOIN rooms ro " +
                "ON r.room_id = ro.room_id " +
                "JOIN room_types rt " +
                "ON ro.room_type_id = rt.room_type_id " +
                "WHERE b.reservation_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToBill(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get bill error: "
                    + e.getMessage());
        }
        return null;
    }

    // ─── GET BILL BY BILL ID ───
    public Bill getBillById(int billId) {
        String sql = "SELECT b.*, " +
                "r.reservation_id, r.check_in_date, " +
                "r.check_out_date, r.number_of_nights, " +
                "r.number_of_guests, r.status, " +
                "g.guest_id, g.name as guest_name, " +
                "g.nic, g.email, g.phone, " +
                "ro.room_id, ro.room_number, " +
                "ro.floor_number, ro.max_occupancy, " +
                "ro.is_available, " +
                "ro.description as room_description, " +
                "rt.room_type_id, rt.type_name, " +
                "rt.base_price, rt.amenities, " +
                "rt.description as type_description " +
                "FROM bills b " +
                "JOIN reservations r " +
                "ON b.reservation_id = r.reservation_id " +
                "JOIN guests g " +
                "ON r.guest_id = g.guest_id " +
                "JOIN rooms ro " +
                "ON r.room_id = ro.room_id " +
                "JOIN room_types rt " +
                "ON ro.room_type_id = rt.room_type_id " +
                "WHERE b.bill_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, billId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToBill(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get bill by id error: "
                    + e.getMessage());
        }
        return null;
    }

    // ─── UPDATE BILL STATUS ───
    public boolean updateBillStatus(int billId,
                                    boolean isPaid) {
        String sql = "UPDATE bills SET is_paid = ? " +
                "WHERE bill_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, isPaid);
            ps.setInt(2, billId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update bill status error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── MAP RESULT SET TO BILL ───
    private Bill mapResultSetToBill(ResultSet rs)
            throws SQLException {

        // ─── Room Type ───
        RoomType roomType = new RoomType();
        roomType.setRoomTypeId(rs.getInt("room_type_id"));
        roomType.setTypeName(rs.getString("type_name"));
        roomType.setBasePrice(rs.getDouble("base_price"));
        roomType.setAmenities(rs.getString("amenities"));
        roomType.setDescription(
                rs.getString("type_description"));

        // ─── Room ───
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setFloorNumber(rs.getInt("floor_number"));
        room.setMaxOccupancy(rs.getInt("max_occupancy"));
        room.setAvailable(rs.getBoolean("is_available"));
        room.setDescription(rs.getString("room_description"));
        room.setRoomType(roomType);

        // ─── Guest ───
        Guest guest = new Guest();
        guest.setGuestId(rs.getInt("guest_id"));
        guest.setName(rs.getString("guest_name"));
        guest.setNic(rs.getString("nic"));
        guest.setEmail(rs.getString("email"));
        guest.setContactNumber(rs.getString("contact_number"));

        // ─── Reservation ───
        Reservation reservation = new Reservation();
        reservation.setReservationId(
                rs.getInt("reservation_id"));
        reservation.setCheckInDate(
                rs.getDate("check_in_date").toLocalDate());
        reservation.setCheckOutDate(
                rs.getDate("check_out_date").toLocalDate());
        reservation.setNumberOfNights(
                rs.getInt("number_of_nights"));
        reservation.setNumberOfGuests(
                rs.getInt("number_of_guests"));
        reservation.setStatus(rs.getString("status"));
        reservation.setGuest(guest);
        reservation.setRoom(room);

        // ─── Bill ───
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setTotalAmount(rs.getDouble("total_amount"));
        bill.setTaxAmount(rs.getDouble("tax_amount"));
        bill.setDiscount(rs.getDouble("discount"));
        bill.setNetAmount(rs.getDouble("net_amount"));
        bill.setGeneratedDate(
                rs.getTimestamp("generated_date")
                        .toLocalDateTime());
        bill.setPaid(rs.getBoolean("is_paid"));
        bill.setReservation(reservation);

        return bill;
    }
}