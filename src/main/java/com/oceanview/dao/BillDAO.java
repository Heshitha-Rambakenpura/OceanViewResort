package com.oceanview.dao;

import com.oceanview.model.Bill;
import com.oceanview.util.DatabaseConnection;
import java.sql.*;

/**
 * BillDAO - DAO Pattern (Structural Pattern)
 * Handles all database operations for Bill
 * @version 1.0.0
 */
public class BillDAO {

    private Connection connection;

    public BillDAO() {
        this.connection = DatabaseConnection.getInstance().getConnection();
    }

    // ─── SAVE BILL ───
    public boolean saveBill(Bill bill) {
        String sql = "INSERT INTO bills (reservation_id, total_amount, " +
                "tax_amount, discount, net_amount) " +
                "VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, bill.getReservation().getReservationId());
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
            System.err.println("Save bill error: " + e.getMessage());
        }
        return false;
    }

    // ─── GET BILL BY RESERVATION ID ───
    public Bill getBillByReservationId(int reservationId) {
        String sql = "SELECT * FROM bills WHERE reservation_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToBill(rs);
            }
        } catch (SQLException e) {
            System.err.println("Get bill error: " + e.getMessage());
        }
        return null;
    }

    // ─── UPDATE BILL STATUS ───
    public boolean updateBillStatus(int billId, boolean isPaid) {
        String sql = "UPDATE bills SET is_paid = ? WHERE bill_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, isPaid);
            ps.setInt(2, billId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update bill status error: " + e.getMessage());
        }
        return false;
    }

    // ─── MAP RESULT SET ───
    private Bill mapResultSetToBill(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setTotalAmount(rs.getDouble("total_amount"));
        bill.setTaxAmount(rs.getDouble("tax_amount"));
        bill.setDiscount(rs.getDouble("discount"));
        bill.setNetAmount(rs.getDouble("net_amount"));
        bill.setPaid(rs.getBoolean("is_paid"));
        return bill;
    }
}