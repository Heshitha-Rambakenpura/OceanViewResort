package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.model.*;

/**
 * PaymentController - Business Logic for Payment operations
 * @version 1.0.0
 */
public class PaymentController {

    private PaymentDAO paymentDAO;
    private BillDAO billDAO;
    private AuditLogDAO auditLogDAO;

    public PaymentController() {
        this.paymentDAO  = new PaymentDAO();
        this.billDAO     = new BillDAO();
        this.auditLogDAO = new AuditLogDAO();
    }

    // ─── PROCESS PAYMENT ───
    public String processPayment(Payment payment,
                                 int userId, String ipAddress) {
        // Step 1 - Process payment (Strategy Pattern)
        boolean success = payment.processPayment();
        if (!success) {
            auditLogDAO.logAction(userId,
                    "PAYMENT_FAILED", ipAddress);
            return "PAYMENT_FAILED";
        }

        // Step 2 - Save payment
        boolean saved = paymentDAO.savePayment(payment);
        if (!saved) {
            return "ERROR";
        }

        // Step 3 - Update bill status
        billDAO.updateBillStatus(
                payment.getBill().getBillId(), true);

        // Step 4 - Log action
        auditLogDAO.logAction(userId,
                "PAYMENT_MADE", ipAddress);
        return "SUCCESS";
    }

    // ─── GET ALL PAYMENTS ───
    public List<Payment> getAllPayments() {
        return paymentDAO.getAllPayments();
    }

    // ─── GET TOTAL INCOME ───
    public double getTotalIncome() {
        return paymentDAO.getTotalIncome();
    }

    // ─── GET PAYMENT COUNT BY METHOD ───
    public int getPaymentCountByMethod(String method) {
        return paymentDAO.getPaymentCountByMethod(method);
    }

    // ─── GET BILL BY RESERVATION ───
    public Bill getBillByReservation(int reservationId) {
        return billDAO.getBillByReservationId(reservationId);
    }
}