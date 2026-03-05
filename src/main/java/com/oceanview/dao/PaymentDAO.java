package com.oceanview.dao;

import com.oceanview.model.Bill;
import com.oceanview.model.CardPayment;
import com.oceanview.model.CashPayment;
import com.oceanview.model.Guest;
import com.oceanview.model.OnlineTransferPayment;
import com.oceanview.model.Payment;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * PaymentDAO - Handles all database operations for Payment
 * @version 1.0.0
 */
public class PaymentDAO {

    private Connection connection;

    public PaymentDAO() {
        this.connection = DatabaseConnection
                .getInstance().getConnection();
    }

    // ─── SAVE PAYMENT ───
    public boolean savePayment(Payment payment) {
        String sql = "INSERT INTO payments " +
                "(bill_id, amount, payment_method, " +
                "payment_status, receipt_number, " +
                "payment_date) " +
                "VALUES (?, ?, ?, ?, ?, NOW())";
        try {
            PreparedStatement ps = connection.prepareStatement(
                    sql,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, payment.getBill().getBillId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getPaymentStatus());
            ps.setString(5, payment.getReceiptNumber());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    payment.setPaymentId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Save payment error: "
                    + e.getMessage());
        }
        return false;
    }

    // ─── GET ALL PAYMENTS ───
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, " +
                "b.bill_id, b.net_amount, " +
                "b.reservation_id, " +
                "g.name as guest_name, " +
                "ro.room_number " +
                "FROM payments p " +
                "JOIN bills b ON p.bill_id = b.bill_id " +
                "JOIN reservations r " +
                "ON b.reservation_id = r.reservation_id " +
                "JOIN guests g " +
                "ON r.guest_id = g.guest_id " +
                "JOIN rooms ro " +
                "ON r.room_id = ro.room_id " +
                "ORDER BY p.payment_date DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get all payments error: "
                    + e.getMessage());
        }
        return payments;
    }

    // ─── GET PAYMENTS BY DATE RANGE ───
    public List<Payment> getPaymentsByDateRange(
            String startDate,
            String endDate) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, " +
                "b.bill_id, b.net_amount, " +
                "b.reservation_id, " +
                "g.name as guest_name, " +
                "ro.room_number " +
                "FROM payments p " +
                "JOIN bills b ON p.bill_id = b.bill_id " +
                "JOIN reservations r " +
                "ON b.reservation_id = r.reservation_id " +
                "JOIN guests g " +
                "ON r.guest_id = g.guest_id " +
                "JOIN rooms ro " +
                "ON r.room_id = ro.room_id " +
                "WHERE DATE(p.payment_date) >= ? " +
                "AND DATE(p.payment_date) <= ? " +
                "AND p.payment_status = 'SUCCESS' " +
                "ORDER BY p.payment_date DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get payments by date error: "
                    + e.getMessage());
        }
        return payments;
    }

    // ─── GET TOTAL INCOME ───
    public double getTotalIncome() {
        String sql = "SELECT COALESCE(SUM(amount), 0) " +
                "as total FROM payments " +
                "WHERE payment_status = 'SUCCESS'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.err.println("Get total income error: "
                    + e.getMessage());
        }
        return 0.0;
    }

    // ─── GET TOTAL INCOME BY DATE RANGE ───
    public double getTotalIncomeByDateRange(String startDate,
                                            String endDate) {
        String sql = "SELECT COALESCE(SUM(amount), 0) " +
                "as total FROM payments " +
                "WHERE DATE(payment_date) >= ? " +
                "AND DATE(payment_date) <= ? " +
                "AND payment_status = 'SUCCESS'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.err.println("Get total by date error: "
                    + e.getMessage());
        }
        return 0.0;
    }

    // ─── GET PAYMENT COUNT BY METHOD ───
    public int getPaymentCountByMethod(String method) {
        String sql = "SELECT COUNT(*) as count " +
                "FROM payments " +
                "WHERE payment_method = ? " +
                "AND payment_status = 'SUCCESS'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, method);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("Get count error: "
                    + e.getMessage());
        }
        return 0;
    }

    // ─── MAP RESULT SET TO PAYMENT ───
    private Payment mapResultSetToPayment(ResultSet rs)
            throws SQLException {

        String method = rs.getString("payment_method");

        // ─── Bill ───
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setNetAmount(rs.getDouble("net_amount"));

        // ─── Guest ───
        Guest guest = new Guest();
        guest.setName(rs.getString("guest_name"));

        // ─── Room ───
        Room room = new Room();
        room.setRoomNumber(rs.getString("room_number"));

        // ─── Reservation ───
        Reservation reservation = new Reservation();
        reservation.setReservationId(
                rs.getInt("reservation_id"));
        reservation.setGuest(guest);
        reservation.setRoom(room);
        bill.setReservation(reservation);

        // ─── Create correct payment type ───
        Payment payment;
        switch (method != null ? method : "") {
            case "CARD":
                payment = new CardPayment();
                break;
            case "ONLINE_TRANSFER":
                payment = new OnlineTransferPayment();
                break;
            default:
                payment = new CashPayment();
                break;
        }

        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setPaymentMethod(method);
        payment.setPaymentStatus(
                rs.getString("payment_status"));
        payment.setReceiptNumber(
                rs.getString("receipt_number"));
        payment.setPaymentDate(
                rs.getTimestamp("payment_date")
                        .toLocalDateTime());
        payment.setBill(bill);

        return payment;
    }
}