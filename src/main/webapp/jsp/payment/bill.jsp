<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill - Ocean View Resort</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
        }
        .navbar a { color: white; text-decoration: none; }
        .container {
            padding: 30px; max-width: 700px; margin: 0 auto;
        }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .bill-container {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .bill-header {
            background: #1F4E79; color: white;
            padding: 30px; text-align: center;
        }
        .bill-header h1 { font-size: 26px; margin-bottom: 5px; }
        .bill-header p  { font-size: 13px; opacity: 0.85; }
        .bill-body { padding: 30px; }
        .bill-info {
            display: flex; justify-content: space-between;
            margin-bottom: 25px; font-size: 14px;
        }
        .bill-info-left p, .bill-info-right p {
            margin-bottom: 6px; color: #555;
        }
        .bill-info-left strong,
        .bill-info-right strong { color: #1F4E79; }
        .divider {
            border: none; border-top: 2px solid #eee;
            margin: 20px 0;
        }
        table {
            width: 100%; border-collapse: collapse;
            margin-bottom: 20px;
        }
        th {
            background: #EBF3FB; color: #1F4E79;
            padding: 10px 12px; text-align: left;
            font-size: 14px;
        }
        td {
            padding: 10px 12px;
            border-bottom: 1px solid #eee;
            font-size: 14px; color: #333;
        }
        .totals {
            width: 300px; margin-left: auto;
        }
        .total-row {
            display: flex; justify-content: space-between;
            padding: 8px 0; font-size: 14px; color: #555;
            border-bottom: 1px solid #eee;
        }
        .total-row.final {
            font-size: 18px; font-weight: bold;
            color: #1F4E79; border-bottom: none;
            margin-top: 5px;
        }
        .status-paid {
            text-align: center; margin: 20px 0;
            padding: 10px; border-radius: 6px;
            font-weight: bold; font-size: 16px;
        }
        .paid     { background: #e0ffe0; color: #006600; }
        .not-paid { background: #ffe0e0; color: #cc0000; }
        .bill-footer {
            background: #f8f9fa; padding: 20px 30px;
            text-align: center; font-size: 12px; color: #888;
            border-top: 2px solid #eee;
        }
        .btn-group {
            display: flex; gap: 10px;
            justify-content: center; margin: 20px 0;
        }
        .btn {
            padding: 10px 25px; border: none;
            border-radius: 6px; cursor: pointer;
            font-size: 14px; text-decoration: none;
        }
        .btn-primary { background: #1F4E79; color: white; }
        .btn-print   { background: #2E75B6; color: white; }
        .btn:hover   { opacity: 0.85; }

        @media print {
            .navbar, .back, .btn-group { display: none; }
            body { background: white; }
            .bill-container {
                box-shadow: none; border: 1px solid #ddd;
            }
        }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<div class="container">
    <div class="back">
        <a href="${pageContext.request.contextPath}/reservation?action=list">
            ← Back to Reservations
        </a>
    </div>

    <div class="bill-container">

        <%-- ─── BILL HEADER ─── --%>
        <div class="bill-header">
            <h1>🏨 Ocean View Resort</h1>
            <p>Galle, Sri Lanka | Tel: +94 91 234 5678</p>
            <p>Email: info@oceanviewresort.lk</p>
            <p style="margin-top:15px; font-size:20px;
                      font-weight:bold; letter-spacing:2px;">
                INVOICE
            </p>
        </div>

        <%-- ─── BILL BODY ─── --%>
        <div class="bill-body">

            <%-- Bill Info --%>
            <div class="bill-info">
                <div class="bill-info-left">
                    <p><strong>Bill ID:</strong>
                        #${bill.billId}</p>
                    <p><strong>Generated Date:</strong>
                        ${bill.generatedDate}</p>
                    <p><strong>Status:</strong>
                        <% if (request.getAttribute("bill") != null &&
                               ((com.oceanview.model.Bill)
                                request.getAttribute("bill")).isPaid()) { %>
                            <span style="color:#006600;
                                         font-weight:bold;">PAID</span>
                        <% } else { %>
                            <span style="color:#cc0000;
                                         font-weight:bold;">UNPAID</span>
                        <% } %>
                    </p>
                </div>
                <div class="bill-info-right">
                    <p><strong>Reservation ID:</strong>
                        #${bill.reservation.reservationId}</p>
                    <p><strong>Guest Name:</strong>
                        ${bill.reservation.guest.name}</p>
                    <p><strong>Room Number:</strong>
                        ${bill.reservation.room.roomNumber}</p>
                </div>
            </div>

            <hr class="divider"/>

            <%-- Reservation Details Table --%>
            <table>
                <thead>
                    <tr>
                        <th>Description</th>
                        <th>Room Type</th>
                        <th>Nights</th>
                        <th>Rate/Night</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Room Charge</td>
                        <td>${bill.reservation.room.roomType.typeName}</td>
                        <td>${bill.reservation.numberOfNights}</td>
                        <td>Rs. ${bill.reservation.room.roomType.basePrice}</td>
                        <td>Rs. ${bill.totalAmount}</td>
                    </tr>
                </tbody>
            </table>

            <%-- Totals --%>
            <div class="totals">
                <div class="total-row">
                    <span>Subtotal:</span>
                    <span>Rs. ${bill.totalAmount}</span>
                </div>
                <div class="total-row">
                    <span>Tax (10%):</span>
                    <span>Rs. ${bill.taxAmount}</span>
                </div>
                <div class="total-row">
                    <span>Discount:</span>
                    <span>Rs. ${bill.discount}</span>
                </div>
                <div class="total-row final">
                    <span>NET AMOUNT:</span>
                    <span>Rs. ${bill.netAmount}</span>
                </div>
            </div>

            <hr class="divider"/>

            <%-- Payment Status --%>
            <% if (request.getAttribute("bill") != null &&
                   ((com.oceanview.model.Bill)
                    request.getAttribute("bill")).isPaid()) { %>
                <div class="status-paid paid">
                    ✅ PAYMENT RECEIVED - THANK YOU!
                </div>
            <% } else { %>
                <div class="status-paid not-paid">
                    ⚠️ PAYMENT PENDING
                </div>
            <% } %>

            <%-- Action Buttons --%>
            <div class="btn-group">
                <% if (request.getAttribute("bill") != null &&
                       !((com.oceanview.model.Bill)
                         request.getAttribute("bill")).isPaid()) { %>
                    <a href="${pageContext.request.contextPath}/payment?reservationId=${bill.reservation.reservationId}"
                       class="btn btn-primary">
                        💳 Make Payment
                    </a>
                <% } %>
                <button onclick="window.print()"
                        class="btn btn-print">
                    🖨️ Print Bill
                </button>
            </div>

        </div>

        <%-- ─── BILL FOOTER ─── --%>
        <div class="bill-footer">
            <p>Thank you for staying at Ocean View Resort!</p>
            <p>For any queries please contact us at
               info@oceanviewresort.lk</p>
            <p style="margin-top:8px;">
                This is a computer generated invoice
            </p>
        </div>

    </div>
</div>

</body>
</html>