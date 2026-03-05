<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Payment Summary</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
        }
        .navbar a {
            color: white; text-decoration: none;
            margin-left: 15px;
        }
        .container { padding: 30px; }
        h2 { color: #1F4E79; margin-bottom: 25px; }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px; margin-bottom: 30px;
        }
        .stat-card {
            background: white; padding: 20px;
            border-radius: 10px; text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            font-size: 12px; color: #888;
            margin-bottom: 10px; text-transform: uppercase;
        }
        .stat-card p {
            font-size: 26px; font-weight: bold;
        }
        .stat-card.income p  { color: #006600; }
        .stat-card.cash p    { color: #1F4E79; }
        .stat-card.card p    { color: #cc6600; }
        .stat-card.online p  { color: #6600cc; }
        .filter-bar {
            background: white; padding: 15px 20px;
            border-radius: 10px; margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex; gap: 10px; align-items: center;
        }
        .filter-bar label {
            font-weight: bold; font-size: 14px; color: #333;
        }
        .filter-btn {
            padding: 7px 16px; border: 2px solid #1F4E79;
            border-radius: 20px; cursor: pointer;
            font-size: 13px; background: white; color: #1F4E79;
        }
        .filter-btn.active,
        .filter-btn:hover {
            background: #1F4E79; color: white;
        }
        .search-bar {
            background: white; padding: 15px 20px;
            border-radius: 10px; margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .search-bar input {
            width: 100%; padding: 8px 12px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 14px;
        }
        .search-bar input:focus {
            outline: none; border-color: #2E75B6;
        }
        table {
            width: 100%; border-collapse: collapse;
            background: white; border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        th {
            background: #1F4E79; color: white;
            padding: 12px; text-align: left; font-size: 14px;
        }
        td {
            padding: 12px; border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        tr:hover td { background: #EBF3FB; }
        .status-badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
            background: #e0ffe0; color: #006600;
        }
        .method-badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
        }
        .CASH {
            background: #e8f4fd; color: #1F4E79;
        }
        .CARD {
            background: #fff3e0; color: #cc6600;
        }
        .ONLINE_TRANSFER {
            background: #f3e8ff; color: #6600cc;
        }
        .no-data {
            text-align: center; padding: 40px;
            color: #888; font-size: 16px;
        }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <div>
        <a href="${pageContext.request.contextPath}/report">
            Reports
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            Logout
        </a>
    </div>
</div>

<div class="container">
    <div class="back">
        <a href="${pageContext.request.contextPath}/jsp/auth/receptionist_dashboard.jsp">
            ← Back to Dashboard
        </a>
    </div>

    <h2>💰 Payment Summary</h2>

    <%-- ─── STATS ─── --%>
    <div class="stats">
        <div class="stat-card income">
            <h3>Total Income</h3>
            <p>Rs. <fmt:formatNumber value="${totalIncome}"
                    maxFractionDigits="2"/></p>
        </div>
        <div class="stat-card cash">
            <h3>Cash Payments</h3>
            <p>${cashCount}</p>
        </div>
        <div class="stat-card card">
            <h3>Card Payments</h3>
            <p>${cardCount}</p>
        </div>
        <div class="stat-card online">
            <h3>Online Transfers</h3>
            <p>${onlineCount}</p>
        </div>
    </div>

    <%-- ─── FILTER ─── --%>
    <div class="filter-bar">
        <label>Filter by Method:</label>
        <button class="filter-btn active"
                onclick="filterPayments('ALL', this)">
            All
        </button>
        <button class="filter-btn"
                onclick="filterPayments('CASH', this)">
            💵 Cash
        </button>
        <button class="filter-btn"
                onclick="filterPayments('CARD', this)">
            💳 Card
        </button>
        <button class="filter-btn"
                onclick="filterPayments('ONLINE_TRANSFER',
                                        this)">
            🏦 Online
        </button>
    </div>

    <%-- ─── SEARCH ─── --%>
    <div class="search-bar">
        <input type="text" id="searchInput"
               placeholder="🔍 Search by receipt number or guest name..."
               onkeyup="searchPayments()" />
    </div>

    <%-- ─── TABLE ─── --%>
    <table>
        <thead>
            <tr>
                <th>Receipt No</th>
                <th>Guest</th>
                <th>Room</th>
                <th>Reservation</th>
                <th>Amount</th>
                <th>Method</th>
                <th>Date</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody id="paymentsBody">
            <c:choose>
                <c:when test="${empty payments}">
                    <tr>
                        <td colspan="8" class="no-data">
                            No payments found
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="payment"
                               items="${payments}">
                        <%-- data-method uses paymentMethod
                             not paymentStatus --%>
                        <tr data-method="${payment.paymentMethod}">
                            <td>${payment.receiptNumber}</td>
                            <td>
                                ${payment.bill.reservation.guest.name}
                            </td>
                            <td>
                                ${payment.bill.reservation.room.roomNumber}
                            </td>
                            <td>
                                #${payment.bill.reservation.reservationId}
                            </td>
                            <td>Rs. ${payment.amount}</td>
                            <td>
                                <%-- Show paymentMethod
                                     not paymentStatus --%>
                                <span class="method-badge ${payment.paymentMethod}">
                                    ${payment.paymentMethod}
                                </span>
                            </td>
                            <td>${payment.paymentDate}</td>
                            <td>
                                <span class="status-badge">
                                    ${payment.paymentStatus}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script>
function filterPayments(method, btn) {
    document.querySelectorAll('.filter-btn')
            .forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    document.querySelectorAll('#paymentsBody tr')
            .forEach(row => {
        if (method === 'ALL') {
            row.style.display = '';
        } else {
            // ─── Compare data-method attribute ───
            var rowMethod = row.getAttribute('data-method');
            row.style.display =
                rowMethod === method ? '' : 'none';
        }
    });
}

function searchPayments() {
    var input = document.getElementById('searchInput')
                        .value.toLowerCase();
    document.querySelectorAll('#paymentsBody tr')
            .forEach(row => {
        row.style.display =
            row.textContent.toLowerCase()
               .includes(input) ? '' : 'none';
    });
}
</script>

</body>
</html>