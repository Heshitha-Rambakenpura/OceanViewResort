<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Check session --%>
<% if (session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
} %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Receptionist Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 { font-size: 20px; }
        .navbar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-size: 14px;
        }
        .navbar a:hover { text-decoration: underline; }
        .container { padding: 30px; }
        .welcome {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .welcome h2 { color: #1F4E79; }
        .welcome p { color: #666; margin-top: 5px; }
        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-decoration: none;
            color: #333;
            transition: transform 0.2s;
            border-top: 4px solid #2E75B6;
        }
        .card:hover { transform: translateY(-5px); }
        .card .icon { font-size: 40px; margin-bottom: 15px; }
        .card h3 { color: #1F4E79; margin-bottom: 8px; }
        .card p { color: #888; font-size: 13px; }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <div>
        <span>Welcome, ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="welcome">
        <h2>Receptionist Dashboard</h2>
        <p>Manage guests, reservations and payments</p>
    </div>

    <div class="cards">
        <a href="${pageContext.request.contextPath}/guest"
           class="card">
            <div class="icon">👤</div>
            <h3>Register Guest</h3>
            <p>Add new guest to system</p>
        </a>
        <a href="${pageContext.request.contextPath}/guest?action=list"
           class="card">
            <div class="icon">📋</div>
            <h3>Guest List</h3>
            <p>View all registered guests</p>
        </a>
        <a href="${pageContext.request.contextPath}/reservation"
           class="card">
            <div class="icon">🛏️</div>
            <h3>Add Reservation</h3>
            <p>Create new room reservation</p>
        </a>
        <a href="${pageContext.request.contextPath}/reservation?action=list"
           class="card">
            <div class="icon">📅</div>
            <h3>View Reservations</h3>
            <p>Manage all reservations</p>
        </a>
        <a href="${pageContext.request.contextPath}/payment"
           class="card">
            <div class="icon">💳</div>
            <h3>Make Payment</h3>
            <p>Process guest payments</p>
        </a>
        <a href="${pageContext.request.contextPath}/report"
           class="card">
            <div class="icon">📊</div>
            <h3>View Reports</h3>
            <p>View payment summaries</p>
        </a>
        <a href="${pageContext.request.contextPath}/jsp/auth/help.jsp"
           class="card">
            <div class="icon">❓</div>
            <h3>Help Section</h3>
            <p>System usage guidelines</p>
        </a>
    </div>
</div>

</body>
</html>