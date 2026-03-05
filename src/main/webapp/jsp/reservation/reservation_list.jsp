<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% if (session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
} %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reservation List</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
        }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .container { padding: 30px; }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .actions { margin-bottom: 20px; }
        .btn {
            padding: 10px 20px; border: none;
            border-radius: 6px; cursor: pointer;
            text-decoration: none; font-size: 14px;
            margin-right: 10px;
        }
        .btn-primary { background: #1F4E79; color: white; }
        .btn-danger  { background: #cc0000; color: white; }
        .btn-info    { background: #2E75B6; color: white; }
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
        .badge {
            padding: 4px 10px; border-radius: 20px; font-size: 12px;
        }
        .CONFIRMED   { background: #e0ffe0; color: #006600; }
        .CANCELLED   { background: #ffe0e0; color: #cc0000; }
        .CHECKED_IN  { background: #e0f0ff; color: #0066cc; }
        .CHECKED_OUT { background: #f0f0f0; color: #666666; }
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
        <a href="${pageContext.request.contextPath}/reservation">
            Add Reservation
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
    <h2>Reservation List</h2>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/reservation"
           class="btn btn-primary">
            + Add New Reservation
        </a>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Guest</th>
                <th>Room</th>
                <th>Check In</th>
                <th>Check Out</th>
                <th>Nights</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty reservations}">
                    <tr>
                        <td colspan="8" class="no-data">
                            No reservations found
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="res" items="${reservations}">
                        <tr>
                            <td>${res.reservationId}</td>
                            <td>${res.guest.name}</td>
                            <td>${res.room.roomNumber}</td>
                            <td>${res.checkInDate}</td>
                            <td>${res.checkOutDate}</td>
                            <td>${res.numberOfNights}</td>
                            <td>
                                <span class="badge ${res.status}">
                                    ${res.status}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/bill?reservationId=${res.reservationId}"
                                   class="btn btn-info">Bill</a>
                                <a href="${pageContext.request.contextPath}/payment?reservationId=${res.reservationId}"
                                   class="btn btn-primary">Pay</a>
                                <c:if test="${res.status == 'CONFIRMED'}">
                                    <a href="${pageContext.request.contextPath}/reservation?action=cancel&id=${res.reservationId}"
                                       class="btn btn-danger"
                                       onclick="return confirm('Cancel this reservation?')">
                                       Cancel
                                    </a>
                                </c:if>
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