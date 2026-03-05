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
    <title>Print Bill - Ocean View Resort</title>
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
        h2 { color: #1F4E79; margin-bottom: 20px; }

        /* ─── SEARCH BOX ─── */
        .search-card {
            background: white; padding: 30px;
            border-radius: 10px; margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #1F4E79;
        }
        .search-card h3 {
            color: #1F4E79; margin-bottom: 20px;
        }
        .search-row {
            display: flex; gap: 15px; align-items: flex-end;
        }
        .form-group { flex: 1; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; font-size: 14px; color: #333;
        }
        input {
            width: 100%; padding: 10px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 14px;
        }
        input:focus {
            outline: none; border-color: #2E75B6;
        }
        .btn {
            padding: 10px 25px; border: none;
            border-radius: 6px; cursor: pointer;
            font-size: 14px; text-decoration: none;
            display: inline-block;
        }
        .btn-primary { background: #1F4E79; color: white; }
        .btn-print   { background: #2E75B6; color: white; }
        .btn:hover   { opacity: 0.85; }

        /* ─── BILL SECTION ─── */
        .bill-container {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            overflow: hidden; display: none;
        }
        .bill-header {
            background: #1F4E79; color: white;
            padding: 25px; text-align: center;
        }
        .bill-header h1 { font-size: 22px; margin-bottom: 5px; }
        .bill-header p  { font-size: 13px; opacity: 0.85; }
        .bill-body { padding: 25px; }
        .bill-info {
            display: flex; justify-content: space-between;
            margin-bottom: 20px;
        }
        .info-block p {
            margin-bottom: 8px; font-size: 14px; color: #555;
        }
        .info-block strong { color: #1F4E79; }
        .divider {
            border: none; border-top: 2px solid #eee;
            margin: 15px 0;
        }
        table {
            width: 100%; border-collapse: collapse;
            margin-bottom: 15px; font-size: 14px;
        }
        th {
            background: #EBF3FB; color: #1F4E79;
            padding: 10px; text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #eee; color: #333;
        }
        .totals {
            width: 250px; margin-left: auto;
        }
        .total-row {
            display: flex; justify-content: space-between;
            padding: 7px 0; font-size: 14px;
            border-bottom: 1px solid #eee; color: #555;
        }
        .total-row.final {
            font-size: 16px; font-weight: bold;
            color: #1F4E79; border-bottom: none;
            padding-top: 10px;
        }
        .status-box {
            text-align: center; padding: 10px;
            border-radius: 6px; font-weight: bold;
            font-size: 14px; margin: 15px 0;
        }
        .paid     { background: #e0ffe0; color: #006600; }
        .not-paid { background: #ffe0e0; color: #cc0000; }
        .btn-group {
            display: flex; gap: 10px;
            justify-content: center; margin: 15px 0;
        }
        .bill-footer {
            background: #f8f9fa; padding: 15px;
            text-align: center; font-size: 12px;
            color: #888; border-top: 2px solid #eee;
        }
        .error {
            background: #ffe0e0; color: #cc0000;
            padding: 12px; border-radius: 6px;
            margin-bottom: 20px; display: none;
        }

        @media print {
            .navbar, .back, .search-card, .btn-group {
                display: none !important;
            }
            body { background: white; }
            .bill-container {
                display: block !important;
                box-shadow: none;
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
        <a href="${pageContext.request.contextPath}/jsp/auth/receptionist_dashboard.jsp">
            ← Back to Dashboard
        </a>
    </div>

    <h2>🖨️ Print Bill</h2>

    <%-- ─── SEARCH BOX ─── --%>
    <div class="search-card">
        <h3>Search Bill by Reservation ID</h3>
        <div class="search-row">
            <div class="form-group">
                <label>Reservation ID</label>
                <input type="number"
                       id="reservationIdInput"
                       placeholder="Enter Reservation ID"
                       min="1" />
            </div>
            <button class="btn btn-primary"
                    onclick="searchBill()">
                🔍 Find Bill
            </button>
        </div>
    </div>

    <%-- ─── ERROR ─── --%>
    <div class="error" id="errorBox">
        ❌ Bill not found! Please check the Reservation ID.
    </div>

    <%-- ─── BILL DISPLAY ─── --%>
    <div class="bill-container" id="billContainer">

        <div class="bill-header">
            <h1>🏨 Ocean View Resort</h1>
            <p>Galle, Sri Lanka | Tel: +94 91 234 5678</p>
            <p>Email: info@oceanviewresort.lk</p>
            <p style="margin-top:12px; font-size:17px;
                      font-weight:bold; letter-spacing:2px;">
                INVOICE
            </p>
        </div>

        <div class="bill-body">

            <div class="bill-info">
                <div class="info-block">
                    <p><strong>Bill ID:</strong>
                        <span id="billId"></span></p>
                    <p><strong>Date:</strong>
                        <span id="billDate"></span></p>
                    <p><strong>Status:</strong>
                        <span id="billStatus"></span></p>
                </div>
                <div class="info-block" style="text-align:right;">
                    <p><strong>Reservation ID:</strong>
                        <span id="reservationId"></span></p>
                    <p><strong>Guest:</strong>
                        <span id="guestName"></span></p>
                    <p><strong>Room:</strong>
                        <span id="roomNumber"></span></p>
                </div>
            </div>

            <hr class="divider"/>

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
                        <td id="roomType"></td>
                        <td id="nights"></td>
                        <td id="ratePerNight"></td>
                        <td id="totalAmount"></td>
                    </tr>
                </tbody>
            </table>

            <div class="totals">
                <div class="total-row">
                    <span>Subtotal:</span>
                    <span id="subtotal"></span>
                </div>
                <div class="total-row">
                    <span>Tax (10%):</span>
                    <span id="tax"></span>
                </div>
                <div class="total-row">
                    <span>Discount:</span>
                    <span id="discount"></span>
                </div>
                <div class="total-row final">
                    <span>NET AMOUNT:</span>
                    <span id="netAmount"></span>
                </div>
            </div>

            <hr class="divider"/>

            <div class="status-box" id="paymentStatusBox"></div>

            <div class="btn-group">
                <button onclick="window.print()"
                        class="btn btn-print">
                    🖨️ Print Bill
                </button>
                <button onclick="resetBill()"
                        class="btn btn-primary">
                    🔍 Search Another
                </button>
            </div>

        </div>

        <div class="bill-footer">
            <p>Thank you for staying at Ocean View Resort!</p>
            <p>For queries contact: info@oceanviewresort.lk</p>
            <p style="margin-top:6px;">Computer generated invoice</p>
        </div>

    </div>
</div>

<script>
function searchBill() {
    var reservationId = document.getElementById(
                          'reservationIdInput').value;
    if (!reservationId) {
        alert('Please enter a Reservation ID!');
        return;
    }

    fetch('${pageContext.request.contextPath}/bill?reservationId='
          + reservationId + '&format=json')
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                showError();
            } else {
                populateBill(data);
            }
        })
        .catch(() => showError());
}

    // Fetch bill from server
    fetch('${pageContext.request.contextPath}/bill?reservationId='
          + reservationId)
        .then(response => response.text())
        .then(html => {
            // Parse the response
            var parser   = new DOMParser();
            var doc      = parser.parseFromString(html, 'text/html');
            var billData = doc.getElementById('billData');

            if (billData) {
                populateBill(JSON.parse(billData.textContent));
            } else {
                showError();
            }
        })
        .catch(() => showError());
}

function populateBill(data) {
    document.getElementById('errorBox')
            .style.display = 'none';
    document.getElementById('billContainer')
            .style.display = 'block';

    document.getElementById('billId').textContent
        = '#' + data.billId;
    document.getElementById('billDate').textContent
        = data.generatedDate;
    document.getElementById('reservationId').textContent
        = '#' + data.reservationId;
    document.getElementById('guestName').textContent
        = data.guestName;
    document.getElementById('roomNumber').textContent
        = data.roomNumber;
    document.getElementById('roomType').textContent
        = data.roomType;
    document.getElementById('nights').textContent
        = data.nights;
    document.getElementById('ratePerNight').textContent
        = 'Rs. ' + data.basePrice;
    document.getElementById('totalAmount').textContent
        = 'Rs. ' + data.totalAmount;
    document.getElementById('subtotal').textContent
        = 'Rs. ' + data.totalAmount;
    document.getElementById('tax').textContent
        = 'Rs. ' + data.taxAmount;
    document.getElementById('discount').textContent
        = 'Rs. ' + data.discount;
    document.getElementById('netAmount').textContent
        = 'Rs. ' + data.netAmount;

    var statusBox = document.getElementById('paymentStatusBox');
    if (data.isPaid) {
        statusBox.className = 'status-box paid';
        statusBox.textContent = '✅ PAYMENT RECEIVED - THANK YOU!';
        document.getElementById('billStatus').innerHTML
            = '<span style="color:#006600; font-weight:bold;">'
            + 'PAID ✅</span>';
    } else {
        statusBox.className = 'status-box not-paid';
        statusBox.textContent = '⚠️ PAYMENT PENDING';
        document.getElementById('billStatus').innerHTML
            = '<span style="color:#cc0000; font-weight:bold;">'
            + 'UNPAID ❌</span>';
    }
}

function showError() {
    document.getElementById('errorBox').style.display  = 'block';
    document.getElementById('billContainer').style.display = 'none';
}

function resetBill() {
    document.getElementById('reservationIdInput').value = '';
    document.getElementById('billContainer').style.display  = 'none';
    document.getElementById('errorBox').style.display = 'none';
}
</script>

</body>
</html>