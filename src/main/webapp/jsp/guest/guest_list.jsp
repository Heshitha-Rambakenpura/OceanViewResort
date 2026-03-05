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
    <title>Guest List</title>
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
        }
        .btn-primary { background: #1F4E79; color: white; }
        .btn-primary:hover { background: #2E75B6; }
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
        <a href="${pageContext.request.contextPath}/guest">
            Register Guest
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
    <h2>Guest List</h2>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/guest"
           class="btn btn-primary">
            + Register New Guest
        </a>
    </div>

    <table>
        <thead>
            <tr>
                <th>Guest ID</th>
                <th>Name</th>
                <th>NIC or Passport No</th>
                <th>Nationality</th>
                <th>Address</th>
                <th>Contact</th>
                <th>Email</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty guests}">
                    <tr>
                        <td colspan="6" class="no-data">
                            No guests registered yet
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="guest" items="${guests}">
                        <tr>
                            <td>${guest.guestId}</td>
                            <td>${guest.name}</td>
                            <td>${guest.nic}</td>
                            <td>${guest.nationality}</td>
                            <td>${guest.address}</td>
                            <td>${guest.contactNumber}</td>
                            <td>${guest.email}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>