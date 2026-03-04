package com.oceanview.controller;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.dao.PaymentDAO;
import com.oceanview.model.Payment;
import java.util.List;

/**
 * ReportController - Business Logic for Report operations
 * @version 1.0.0
 */
public class ReportController {

    private PaymentDAO paymentDAO;
    private AuditLogDAO auditLogDAO;

    public ReportController() {
        this.paymentDAO  = new PaymentDAO();
        this.auditLogDAO = new AuditLogDAO();
    }

    // ─── GENERATE REPORT ───
    public List<Payment> generateReport(String startDate,
                                        String endDate,
                                        int userId,
                                        String ipAddress) {
        List<Payment> payments = paymentDAO
                .getPaymentsByDateRange(
                        startDate, endDate);
        if (payments.isEmpty()) {
            return null;
        }
        // Log report viewed
        auditLogDAO.logAction(userId,
                "REPORT_VIEWED", ipAddress);
        return payments;
    }

    // ─── EXPORT REPORT ───
    public List<Payment> exportReport(String startDate,
                                      String endDate,
                                      int userId,
                                      String ipAddress) {
        List<Payment> payments = paymentDAO
                .getPaymentsByDateRange(
                        startDate, endDate);
        // Log report exported
        auditLogDAO.logAction(userId,
                "REPORT_EXPORTED", ipAddress);
        return payments;
    }
}