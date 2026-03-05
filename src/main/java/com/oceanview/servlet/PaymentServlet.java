package com.oceanview.servlet;

import com.oceanview.controller.PaymentController;
import com.oceanview.model.Bill;
import com.oceanview.model.CardPayment;
import com.oceanview.model.CashPayment;
import com.oceanview.model.OnlineTransferPayment;
import com.oceanview.model.Payment;
import com.oceanview.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * PaymentServlet - Handles payment operations
 * @version 1.0.0
 */
public class PaymentServlet extends HttpServlet {

    private PaymentController paymentController;

    @Override
    public void init() {
        this.paymentController = new PaymentController();
    }

    // ─── GET ───
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        // ─── PAYMENT SUMMARY ───
        if ("summary".equals(action)) {
            List<Payment> payments = paymentController
                    .getAllPayments();
            double totalIncome     = paymentController
                    .getTotalIncome();
            int cashCount          = paymentController
                    .getPaymentCountByMethod(
                            "CASH");
            int cardCount          = paymentController
                    .getPaymentCountByMethod(
                            "CARD");
            int onlineCount        = paymentController
                    .getPaymentCountByMethod(
                            "ONLINE_TRANSFER");

            request.setAttribute("payments", payments);
            request.setAttribute("totalIncome", totalIncome);
            request.setAttribute("cashCount", cashCount);
            request.setAttribute("cardCount", cardCount);
            request.setAttribute("onlineCount", onlineCount);

            request.getRequestDispatcher(
                            "/jsp/payment/payment_summary.jsp")
                    .forward(request, response);

        } else {
            // ─── MAKE PAYMENT PAGE ───
            String reservationIdParam =
                    request.getParameter("reservationId");

            if (reservationIdParam == null
                    || reservationIdParam.isEmpty()) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/reservation?action=list");
                return;
            }

            int reservationId = Integer.parseInt(
                    reservationIdParam);
            Bill bill = paymentController
                    .getBillByReservation(reservationId);

            if (bill == null) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/reservation?action=list");
                return;
            }

            // If already paid redirect to bill
            if (bill.isPaid()) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/bill?reservationId=" + reservationId);
                return;
            }

            request.setAttribute("bill", bill);
            request.setAttribute("reservationId",
                    reservationId);
            request.getRequestDispatcher(
                            "/jsp/payment/make_payment.jsp")
                    .forward(request, response);
        }
    }

    // ─── POST ───
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String paymentMethod = request.getParameter(
                "paymentMethod");
        int billId           = Integer.parseInt(
                request.getParameter(
                        "billId"));
        double amount        = Double.parseDouble(
                request.getParameter(
                        "amount"));
        String ipAddress     = request.getRemoteAddr();

        HttpSession session  = request.getSession();
        User user            = (User) session
                .getAttribute("user");

        // Create bill object
        Bill bill = new Bill();
        bill.setBillId(billId);

        // Strategy Pattern - create correct payment type
        Payment payment = createPayment(
                paymentMethod, bill,
                amount, request);

        String result = paymentController.processPayment(
                payment, user.getUserId(),
                ipAddress);

        if ("SUCCESS".equals(result)) {
            // Get full bill to show on success
            int reservationId = Integer.parseInt(
                    request.getParameter("reservationId"));
            Bill fullBill = paymentController
                    .getBillByReservation(
                            reservationId);
            request.setAttribute("bill", fullBill);
            request.setAttribute("success",
                    "✅ Payment successful! Receipt: "
                            + payment.getReceiptNumber());
        } else {
            // Reload bill for error display
            int reservationId = Integer.parseInt(
                    request.getParameter("reservationId"));
            Bill fullBill = paymentController
                    .getBillByReservation(
                            reservationId);
            request.setAttribute("bill", fullBill);
            request.setAttribute("error",
                    "❌ Payment failed! Please try again.");
        }

        request.getRequestDispatcher(
                        "/jsp/payment/make_payment.jsp")
                .forward(request, response);
    }

    // ─── CREATE PAYMENT - Strategy Pattern ───
    private Payment createPayment(String method, Bill bill,
                                  double amount,
                                  HttpServletRequest request) {
        switch (method) {
            case "CASH":
                double tendered = Double.parseDouble(
                        request.getParameter("amountTendered"));
                return new CashPayment(bill, amount, tendered);

            case "CARD":
                return new CardPayment(
                        bill, amount,
                        request.getParameter("cardNumber"),
                        request.getParameter("cardHolderName"),
                        request.getParameter("expiryDate"),
                        request.getParameter("cvv"));

            case "ONLINE_TRANSFER":
                return new OnlineTransferPayment(
                        bill, amount,
                        request.getParameter("bankName"),
                        request.getParameter("referenceNumber"),
                        LocalDate.parse(
                                request.getParameter("transferDate")),
                        request.getParameter("senderName"));

            default:
                return new CashPayment(bill, amount, amount);
        }
    }

    // ─── CHECK SESSION ───
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null
                && session.getAttribute("user") != null;
    }
}