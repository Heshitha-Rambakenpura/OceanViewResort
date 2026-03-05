<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    com.oceanview.model.Bill bill =
        (com.oceanview.model.Bill) request.getAttribute("bill");
    if (bill == null) {
        response.sendRedirect(request.getContextPath()
            + "/reservation?action=list");
        return;
    }
    int resId = bill.getReservation() != null
                ? bill.getReservation().getReservationId()
                : 0;
    String guestName = (bill.getReservation() != null
                        && bill.getReservation().getGuest() != null)
                        ? bill.getReservation().getGuest().getName()
                        : "N/A";
    String roomNumber = (bill.getReservation() != null
                         && bill.getReservation().getRoom() != null)
                         ? bill.getReservation().getRoom().getRoomNumber()
                         : "N/A";
    String roomType = (bill.getReservation() != null
                       && bill.getReservation().getRoom() != null
                       && bill.getReservation().getRoom().getRoomType() != null)
                       ? bill.getReservation().getRoom().getRoomType().getTypeName()
                       : "N/A";
    String checkIn = bill.getReservation() != null
                     ? String.valueOf(bill.getReservation().getCheckInDate())
                     : "N/A";
    String checkOut = bill.getReservation() != null
                      ? String.valueOf(bill.getReservation().getCheckOutDate())
                      : "N/A";
    int nights = bill.getReservation() != null
                 ? bill.getReservation().getNumberOfNights()
                 : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Make Payment - Ocean View Resort</title>
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
            padding: 30px; max-width: 800px; margin: 0 auto;
        }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        h2 { color: #1F4E79; margin-bottom: 25px; }
        .bill-summary {
            background: white; padding: 20px 25px;
            border-radius: 10px; margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #1F4E79;
        }
        .bill-summary h3 {
            color: #1F4E79; margin-bottom: 15px;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }
        .summary-item p {
            font-size: 12px; color: #888;
            text-transform: uppercase; margin-bottom: 4px;
        }
        .summary-item strong { font-size: 15px; color: #333; }
        .net-amount {
            font-size: 22px !important;
            color: #1F4E79 !important;
        }
        .payment-card {
            background: white; padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-top: 4px solid #2E75B6;
        }
        .payment-card h3 {
            color: #1F4E79; margin-bottom: 20px;
        }
        .form-group { margin-bottom: 18px; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; font-size: 14px; color: #333;
        }
        input, select {
            width: 100%; padding: 10px 12px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 14px;
        }
        input:focus { outline: none; border-color: #2E75B6; }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr; gap: 15px;
        }
        .method-buttons {
            display: flex; gap: 15px; margin-bottom: 5px;
        }
        .method-btn {
            flex: 1; padding: 15px;
            border: 2px solid #ddd; border-radius: 8px;
            cursor: pointer; text-align: center;
            background: white; font-size: 14px;
            transition: all 0.2s;
        }
        .method-btn:hover {
            border-color: #2E75B6; background: #EBF3FB;
        }
        .method-btn.selected {
            border-color: #1F4E79;
            background: #1F4E79; color: white;
        }
        .method-btn .method-icon {
            font-size: 24px; margin-bottom: 5px;
        }
        .method-section {
            display: none;
            background: #f8f9fa; padding: 20px;
            border-radius: 8px; margin-top: 15px;
            border: 2px solid #eee;
        }
        .method-section.show { display: block; }
        .method-section h4 {
            color: #1F4E79; margin-bottom: 15px;
        }
        .btn-submit {
            width: 100%; padding: 14px;
            background: #1F4E79; color: white;
            border: none; border-radius: 8px;
            font-size: 16px; font-weight: bold;
            cursor: pointer; margin-top: 20px;
        }
        .btn-submit:hover { background: #2E75B6; }
        .error {
            background: #ffe0e0; color: #cc0000;
            padding: 12px; border-radius: 6px;
            margin-bottom: 20px; font-size: 14px;
        }
        .success {
            background: #e0ffe0; color: #006600;
            padding: 12px; border-radius: 6px;
            margin-bottom: 20px; font-size: 14px;
        }
        .change-info {
            background: #EBF3FB; padding: 10px;
            border-radius: 6px; margin-top: 10px;
            font-size: 14px; color: #1F4E79; display: none;
        }
        .readonly-input {
            background: #f5f5f5; cursor: not-allowed;
        }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <a href="${pageContext.request.contextPath}/logout">
        Logout
    </a>
</div>

<div class="container">
    <div class="back">
        <a href="${pageContext.request.contextPath}/bill?reservationId=<%= resId %>">
            ← Back to Bill
        </a>
    </div>

    <h2>💳 Make Payment</h2>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <div class="success">${success}</div>
    <% } %>

    <%-- ─── BILL SUMMARY ─── --%>
    <div class="bill-summary">
        <h3>📋 Bill Summary</h3>
        <div class="summary-grid">
            <div class="summary-item">
                <p>Guest Name</p>
                <strong><%= guestName %></strong>
            </div>
            <div class="summary-item">
                <p>Room</p>
                <strong>
                    <%= roomNumber %> - <%= roomType %>
                </strong>
            </div>
            <div class="summary-item">
                <p>Check In</p>
                <strong><%= checkIn %></strong>
            </div>
            <div class="summary-item">
                <p>Check Out</p>
                <strong><%= checkOut %></strong>
            </div>
            <div class="summary-item">
                <p>Nights</p>
                <strong><%= nights %></strong>
            </div>
            <div class="summary-item">
                <p>Net Amount</p>
                <strong class="net-amount">
                    Rs. <%= bill.getNetAmount() %>
                </strong>
            </div>
        </div>
    </div>

    <%-- ─── PAYMENT FORM ─── --%>
    <div class="payment-card">
        <h3>Select Payment Method</h3>

        <form method="post"
              action="${pageContext.request.contextPath}/payment"
              id="paymentForm"
              onsubmit="return validateForm()">

            <input type="hidden" name="billId"
                   value="<%= bill.getBillId() %>" />
            <input type="hidden" name="amount"
                   value="<%= bill.getNetAmount() %>" />
            <input type="hidden" name="reservationId"
                   value="<%= resId %>" />

            <%-- IMPORTANT - paymentMethod is a real
                 select not hidden input --%>
            <input type="hidden"
                   name="paymentMethod"
                   id="paymentMethodInput"
                   value="" />

            <%-- ─── METHOD BUTTONS ─── --%>
            <div class="method-buttons">
                <div class="method-btn"
                     id="btn_CASH"
                     onclick="selectMethod('CASH', this)">
                    <div class="method-icon">💵</div>
                    <div>Cash</div>
                </div>
                <div class="method-btn"
                     id="btn_CARD"
                     onclick="selectMethod('CARD', this)">
                    <div class="method-icon">💳</div>
                    <div>Card</div>
                </div>
                <div class="method-btn"
                     id="btn_ONLINE"
                     onclick="selectMethod(
                         'ONLINE_TRANSFER', this)">
                    <div class="method-icon">🏦</div>
                    <div>Online Transfer</div>
                </div>
            </div>

            <%-- ─── CASH SECTION ─── --%>
            <div class="method-section" id="CASH_section">
                <h4>💵 Cash Payment</h4>
                <div class="form-group">
                    <label>Net Amount</label>
                    <input type="text"
                           value="Rs. <%= bill.getNetAmount() %>"
                           class="readonly-input"
                           readonly />
                </div>
                <div class="form-group">
                    <label>Amount Tendered (Rs.) *</label>
                    <input type="number"
                           name="amountTendered"
                           id="amountTendered"
                           min="<%= bill.getNetAmount() %>"
                           step="0.01"
                           placeholder="Enter amount given"
                           oninput="calcChange()" />
                </div>
                <div class="change-info" id="changeInfo">
                    💰 Change to return: Rs.
                    <span id="changeAmount">0.00</span>
                </div>
            </div>

            <%-- ─── CARD SECTION ─── --%>
            <div class="method-section" id="CARD_section">
                <h4>💳 Card Payment</h4>
                <div class="form-group">
                    <label>Card Number *</label>
                    <input type="text"
                           name="cardNumber"
                           id="cardNumber"
                           placeholder="1234 5678 9012 3456"
                           maxlength="19"
                           oninput="formatCard(this)" />
                </div>
                <div class="form-group">
                    <label>Card Holder Name *</label>
                    <input type="text"
                           name="cardHolderName"
                           id="cardHolderName"
                           placeholder="Name on card" />
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Expiry Date *</label>
                        <input type="text"
                               name="expiryDate"
                               id="expiryDate"
                               placeholder="MM/YY"
                               maxlength="5" />
                    </div>
                    <div class="form-group">
                        <label>CVV *</label>
                        <input type="password"
                               name="cvv"
                               id="cvv"
                               placeholder="123"
                               maxlength="3" />
                    </div>
                </div>
            </div>

            <%-- ─── ONLINE TRANSFER SECTION ─── --%>
            <div class="method-section"
                 id="ONLINE_TRANSFER_section">
                <h4>🏦 Online Transfer</h4>
                <div class="form-group">
                    <label>Bank Name *</label>
                    <input type="text"
                           name="bankName"
                           id="bankName"
                           placeholder="e.g. Bank of Ceylon" />
                </div>
                <div class="form-group">
                    <label>Reference Number *</label>
                    <input type="text"
                           name="referenceNumber"
                           id="referenceNumber"
                           placeholder="Transaction reference" />
                </div>
                <div class="form-group">
                    <label>Transfer Date *</label>
                    <input type="date"
                           name="transferDate"
                           id="transferDate" />
                </div>
                <div class="form-group">
                    <label>Sender Name *</label>
                    <input type="text"
                           name="senderName"
                           id="senderName"
                           placeholder="Account holder name" />
                </div>
            </div>

            <button type="submit"
                    class="btn-submit"
                    id="submitBtn"
                    style="display:none;">
                ✅ Confirm Payment of
                Rs. <%= bill.getNetAmount() %>
            </button>

        </form>
    </div>
</div>

<script>
var selectedPaymentMethod = '';
var netAmount = <%= bill.getNetAmount() %>;

function selectMethod(method, btn) {
    selectedPaymentMethod = method;

    // ─── Set hidden input value ───
    document.getElementById('paymentMethodInput').value
        = method;

    // ─── Update button styles ───
    document.querySelectorAll('.method-btn')
            .forEach(b => b.classList.remove('selected'));
    btn.classList.add('selected');

    // ─── Hide all sections ───
    document.querySelectorAll('.method-section')
            .forEach(s => s.classList.remove('show'));

    // ─── Show selected section ───
    document.getElementById(method + '_section')
            .classList.add('show');

    // ─── Show submit button ───
    document.getElementById('submitBtn').style.display
        = 'block';
}

function calcChange() {
    var tendered = parseFloat(
        document.getElementById('amountTendered').value
    ) || 0;
    if (tendered >= netAmount) {
        var change = (tendered - netAmount).toFixed(2);
        document.getElementById('changeAmount')
                .textContent = change;
        document.getElementById('changeInfo')
                .style.display = 'block';
    } else {
        document.getElementById('changeInfo')
                .style.display = 'none';
    }
}

function formatCard(input) {
    var val = input.value.replace(/\s/g, '')
                         .replace(/\D/g, '');
    var formatted = val.match(/.{1,4}/g);
    input.value = formatted ? formatted.join(' ') : val;
}

function validateForm() {
    // ─── Verify method is selected ───
    var method = document.getElementById(
                     'paymentMethodInput').value;

    if (!method || method === '') {
        alert('Please select a payment method!');
        return false;
    }

    // ─── Validate CASH ───
    if (method === 'CASH') {
        var tendered = parseFloat(
            document.getElementById(
                'amountTendered').value) || 0;
        if (tendered < netAmount) {
            alert('Amount tendered must be at least Rs. '
                  + netAmount);
            return false;
        }
    }

    // ─── Validate CARD ───
    if (method === 'CARD') {
        if (!document.getElementById('cardNumber').value
            || !document.getElementById('cardHolderName').value
            || !document.getElementById('expiryDate').value
            || !document.getElementById('cvv').value) {
            alert('Please fill all card details!');
            return false;
        }
    }

    // ─── Validate ONLINE TRANSFER ───
    if (method === 'ONLINE_TRANSFER') {
        if (!document.getElementById('bankName').value
            || !document.getElementById(
                   'referenceNumber').value
            || !document.getElementById('transferDate').value
            || !document.getElementById('senderName').value) {
            alert('Please fill all transfer details!');
            return false;
        }
    }

    return true;
}
</script>

</body>
</html>