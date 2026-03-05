package com.oceanview.dao;

import com.oceanview.model.*;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PaymentDAO - DAO Pattern (Structural Pattern)
 * Handles all database operations for Payment
 * @version 1.0.0
 */
public class PaymentDAO {

    private Connection connection;

    public PaymentDAO() {
        this.connection = DatabaseConnection.getInstance().getConnection();
    }

    // ─── SAVE PAYMENT ───
    public boolean savePayment(Payment payment) {
        String sql = "INSERT INTO payments (bill_id, amount, " +
                "payment_method, payment_status, receipt_number) " +
                "VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, payment.getBill().getBillId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, getPaymentMethod(payment));
            ps.setString(4, payment.getPaymentStatus());
            ps.setString(5, payment.getReceiptNumber());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    payment.setPaymentId(keys.getInt(1));
                }
                // Save payment type specific details
                savePaymentDetails(payment);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Save payment error: " + e.getMessage());
        }
        return false;
    }

    // ─── SAVE PAYMENT DETAILS ───
    private void savePaymentDetails(Payment payment) throws SQLException {
        if (payment instanceof CashPayment) {
            saveCashPayment((CashPayment) payment);
        } else if (payment instanceof CardPayment) {
            saveCardPayment((CardPayment) payment);
        } else if (payment instanceof OnlineTransferPayment) {
            saveOnlinePayment((OnlineTransferPayment) payment);
        }
    }

    // ─── SAVE CASH PAYMENT ───
    private void saveCashPayment(CashPayment payment) throws SQLException {
        String sql = "INSERT INTO cash_payments " +
                "(payment_id, amount_tendered, change_amount) " +
                "VALUES (?, ?, ?)";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, payment.getPaymentId());
        ps.setDouble(2, payment.getAmountTendered());
        ps.setDouble(3, payment.getChangeAmount());
        ps.executeUpdate();
    }

    // ─── SAVE CARD PAYMENT ───
    private void saveCardPayment(CardPayment payment) throws SQLException {
        String sql = "INSERT INTO card_payments " +
                "(payment_id, card_number, card_holder_name, expiry_date) " +
                "VALUES (?, ?, ?, ?)";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, payment.getPaymentId());
        ps.setString(2, payment.getCardNumber());
        ps.setString(3, payment.getCardHolderName());
        ps.setString(4, payment.getExpiryDate());
        ps.executeUpdate();
    }

    // ─── SAVE ONLINE PAYMENT ───
    private void saveOnlinePayment(OnlineTransferPayment payment)
            throws SQLException {
        String sql = "INSERT INTO online_transfer_payments " +
                "(payment_id, bank_name, reference_number, " +
                "transfer_date, sender_name) " +
                "VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, payment.getPaymentId());
        ps.setString(2, payment.getBankName());
        ps.setString(3, payment.getReferenceNumber());
        ps.setDate(4, Date.valueOf(payment.getTransferDate()));
        ps.setString(5, payment.getSenderName());
        ps.executeUpdate();
    }

    // ─── GET PAYMENT METHOD ───
    private String getPaymentMethod(Payment payment) {
        if (payment instanceof CashPayment) return "CASH";
        if (payment instanceof CardPayment) return "CARD";
        return "ONLINE_TRANSFER";
    }

    // ─── GET PAYMENTS BY DATE RANGE ───
    public List<Payment> getPaymentsByDateRange(String startDate,
                                                String endDate) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments " +
                "WHERE DATE(payment_date) BETWEEN ? AND ? " +
                "ORDER BY payment_date DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CashPayment p = new CashPayment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setReceiptNumber(rs.getString("receipt_number"));
                payments.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Get payments error: " + e.getMessage());
        }
        return payments;
    }
    // ─── GET ALL PAYMENTS ───
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, b.reservation_id, b.net_amount, " +
                "g.name as guest_name, " +
                "r.room_id, ro.room_number " +
                "FROM payments p " +
                "JOIN bills b ON p.bill_id = b.bill_id " +
                "JOIN reservations r " +
                "ON b.reservation_id = r.reservation_id " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms ro ON r.room_id = ro.room_id " +
                "ORDER BY p.payment_date DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CashPayment p = new CashPayment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setReceiptNumber(rs.getString("receipt_number"));
                p.setPaymentDate(rs.getTimestamp("payment_date")
                        .toLocalDateTime());

                // Set bill with guest info
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setNetAmount(rs.getDouble("net_amount"));

                Reservation res = new Reservation();
                res.setReservationId(rs.getInt("reservation_id"));

                Guest guest = new Guest();
                guest.setName(rs.getString("guest_name"));
                res.setGuest(guest);

                Room room = new Room();
                room.setRoomNumber(rs.getString("room_number"));
                res.setRoom(room);

                bill.setReservation(res);
                p.setBill(bill);

                payments.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Get all payments error: "
                    + e.getMessage());
        }
        return payments;
    }

    // ─── GET TOTAL INCOME ───
    public double getTotalIncome() {
        String sql = "SELECT SUM(amount) as total " +
                "FROM payments " +
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

    // ─── GET PAYMENTS BY METHOD ───
    public int getPaymentCountByMethod(String method) {
        String sql = "SELECT COUNT(*) as count FROM payments " +
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
            System.err.println("Get count error: " + e.getMessage());
        }
        return 0;
    }
}