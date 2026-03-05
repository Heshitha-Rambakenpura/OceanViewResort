<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    if (!"ADMIN".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 { font-size: 20px; }
        .navbar a {
            color: white; text-decoration: none; margin-left: 20px;
        }
        .container { padding: 30px; }
        .welcome {
            background: white; padding: 20px 30px;
            border-radius: 10px; margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #cc0000;
        }
        .welcome h2 { color: #1F4E79; }
        .welcome p  { color: #666; margin-top: 5px; }
        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        .card {
            background: white; padding: 30px;
            border-radius: 10px; text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-decoration: none; color: #333;
            transition: transform 0.2s;
            border-top: 4px solid #cc0000;
        }
        .card:hover { transform: translateY(-5px); }
        .card .icon { font-size: 40px; margin-bottom: 15px; }
        .card h3 { color: #1F4E79; margin-bottom: 8px; }
        .card p  { color: #888; font-size: 13px; }
        .role-badge {
            display: inline-block;
            background: #cc0000; color: white;
            padding: 3px 10px; border-radius: 20px;
            font-size: 12px; margin-left: 10px;
        }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort
        <span class="role-badge">ADMIN</span>
    </h1>
    <div>
        <span>Welcome, ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/logout">
            Logout
        </a>
    </div>
</div>

<div class="container">
    <div class="welcome">
        <h2>Admin Dashboard</h2>
        <p>Manage user accounts and system maintenance</p>
    </div>

    <div class="cards">
        <a href="${pageContext.request.contextPath}/admin?action=manageUsers"
           class="card">
            <div class="icon">👥</div>
            <h3>Manage User Accounts</h3>
            <p>Create and manage staff accounts</p>
        </a>
        <a href="${pageContext.request.contextPath}/room?action=manageRooms"
           class="card">
            <div class="icon">🛏️</div>
            <h3>Manage Rooms</h3>
            <p>Add, edit and delete rooms</p>
        </a>
        <a href="${pageContext.request.contextPath}/room?action=manageRoomTypes"
           class="card">
            <div class="icon">📋</div>
            <h3>Manage Room Types</h3>
            <p>Add, edit and delete room types</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin?action=auditLogs"
           class="card">
            <div class="icon">📋</div>
            <h3>View Audit Logs</h3>
            <p>Monitor all system activities</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin?action=maintainSystem"
           class="card">
            <div class="icon">⚙️</div>
            <h3>Maintain System</h3>
            <p>System configuration and maintenance</p>
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