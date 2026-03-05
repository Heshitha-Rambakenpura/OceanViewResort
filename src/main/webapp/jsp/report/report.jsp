<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userRole = (String) session.getAttribute("userRole");
    String dashboardUrl;
    if ("ADMIN".equals(userRole)) {
        dashboardUrl = request.getContextPath()
                       + "/jsp/auth/admin_dashboard.jsp";
    } else if ("FINANCE".equals(userRole)) {
        dashboardUrl = request.getContextPath()
                       + "/jsp/auth/finance_dashboard.jsp";
    } else {
        dashboardUrl = request.getContextPath()
                       + "/jsp/auth/receptionist_dashboard.jsp";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Income Report - Ocean View Resort</title>
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

        /* ─── FILTER CARD ─── */
        .filter-card {
            background: white; padding: 25px;
            border-radius: 10px; margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #2E75B6;
        }
        .filter-card h3 {
            color: #1F4E79; margin-bottom: 15px;
        }
        .filter-row {
            display: flex; gap: 15px; align-items: flex-end;
        }
        .form-group { flex: 1; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; font-size: 14px; color: #333;
        }
        input[type="date"] {
            width: 100%; padding: 9px 10px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 14px;
        }
        input:focus { outline: none; border-color: #2E75B6; }
        .btn {
            padding: 10px 20px; border: none;
            border-radius: 6px; cursor: pointer;
            font-size: 14px; font-weight: bold;
            text-decoration: none; display: inline-block;
        }
        .btn-primary { background: #1F4E79; color: white; }
        .btn:hover   { opacity: 0.85; }

        /* ─── TOTAL CARD ─── */
        .total-card {
            background: white; padding: 20px 25px;
            border-radius: 10px; margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex; justify-content: space-between;
            align-items: center;
            border-left: 5px solid #006600;
        }
        .total-card h3 {
            color: #555; font-size: 14px;
            margin-bottom: 8px;
        }
        .total-card p {
            font-size: 32px; font-weight: bold;
            color: #006600;
        }
        .export-btn {
            padding: 12px 25px; background: #006600;
            color: white; border: none; border-radius: 8px;
            font-size: 15px; font-weight: bold;
            cursor: pointer; text-decoration: none;
            display: inline-block;
        }
        .export-btn:hover { opacity: 0.85; }

        /* ─── ERROR / INFO ─── */
        .error {
            background: #ffe0e0; color: #cc0000;
            padding: 12px; border-radius: 6px;
            margin-bottom: 20px; font-size: 14px;
        }
        .info {
            background: #EBF3FB; color: #1F4E79;
            padding: 12px; border-radius: 6px;
            margin-bottom: 20px; font-size: 14px;
        }

        /* ─── TABLE ─── */
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
        .method-badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
        }
        .CASH             { background: #e8f4fd; color: #1F4E79; }
        .CARD             { background: #fff3e0; color: #cc6600; }
        .ONLINE_TRANSFER  { background: #f3e8ff; color: #6600cc; }
        .status-badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
            background: #e0ffe0; color: #006600;
        }
        .no-data {
            text-align: center; padding: 40px;
            color: #888; font-size: 16px;
        }

        @media print {
            .navbar, .back, .filter-card,
            .export-btn { display: none; }
            body { background: white; }
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

    <%-- ─── BACK TO DASHBOARD ─── --%>
    <div class="back">
        <a href="<%= dashboardUrl %>">
            ← Back to Dashboard
        </a>
    </div>

    <h2>📊 Income Report</h2>

    <%-- ─── DATE FILTER ─── --%>
    <div class="filter-card">
        <h3>🗓️ Select Date Range</h3>
        <form method="get"
              action="${pageContext.request.contextPath}/report">
            <div class="filter-row">
                <div class="form-group">
                    <label>Start Date</label>
                    <input type="date" name="startDate"
                           value="${startDate}" required />
                </div>
                <div class="form-group">
                    <label>End Date</label>
                    <input type="date" name="endDate"
                           value="${endDate}" required />
                </div>
                <button type="submit" class="btn btn-primary">
                    🔍 View Report
                </button>
            </div>
        </form>
    </div>

    <%-- ─── TOTAL + EXPORT ─── --%>
    <div class="total-card">
        <div>
            <h3>TOTAL INCOME
                (${startDate} to ${endDate})</h3>
            <p>Rs.
                <fmt:formatNumber value="${totalIncome}"
                    maxFractionDigits="2"/>
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/report?action=export&startDate=${startDate}&endDate=${endDate}"
           class="export-btn">
            📥 Export CSV
        </a>
    </div>

    <%-- ─── ERROR ─── --%>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>

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
        <tbody>
            <c:choose>
                <c:when test="${empty payments}">
                    <tr>
                        <td colspan="8" class="no-data">
                            No payments found for
                            selected date range
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="payment"
                               items="${payments}">
                        <tr>
                            <td>${payment.receiptNumber}</td>
                            <td>
                                ${payment.bill.reservation
                                          .guest.name}
                            </td>
                            <td>
                                ${payment.bill.reservation
                                          .room.roomNumber}
                            </td>
                            <td>
                                #${payment.bill.reservation
                                           .reservationId}
                            </td>
                            <td>Rs. ${payment.amount}</td>
                            <td>
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

</body>
</html>