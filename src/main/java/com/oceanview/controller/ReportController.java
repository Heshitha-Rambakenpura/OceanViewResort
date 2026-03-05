package com.oceanview.controller;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.dao.PaymentDAO;
import com.oceanview.model.Payment;
import java.util.ArrayList;
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
                .getPaymentsByDateRange(startDate, endDate);
        auditLogDAO.logAction(userId,
                "REPORT_VIEWED", ipAddress);
        if (payments == null) {
            return new ArrayList<>();
        }
        return payments;
    }

    // ─── EXPORT REPORT ───
    public List<Payment> exportReport(String startDate,
                                      String endDate,
                                      int userId,
                                      String ipAddress) {
        List<Payment> payments = paymentDAO
                .getPaymentsByDateRange(startDate, endDate);
        auditLogDAO.logAction(userId,
                "REPORT_EXPORTED", ipAddress);
        if (payments == null) {
            return new ArrayList<>();
        }
        return payments;
    }

    // ─── GET TOTAL INCOME BY DATE RANGE ───
    public double getTotalIncomeByDateRange(String startDate,
                                            String endDate) {
        return paymentDAO.getTotalIncomeByDateRange(
                startDate, endDate);
    }
}