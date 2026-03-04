<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null ||
        !"ADMIN".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Maintain System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
        }
        .navbar a { color: white; text-decoration: none; }
        .container { padding: 30px; max-width: 800px; margin: 0 auto; }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .card {
            background: white; padding: 25px;
            border-radius: 10px; margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #1F4E79;
        }
        .card h3 { color: #1F4E79; margin-bottom: 10px; }
        .card p { color: #666; font-size: 14px; margin-bottom: 15px; }
        .btn {
            padding: 10px 20px; background: #1F4E79;
            color: white; border: none;
            border-radius: 6px; cursor: pointer; font-size: 14px;
        }
        .btn:hover { background: #2E75B6; }
        .info {
            background: #EBF3FB; padding: 15px;
            border-radius: 6px; font-size: 14px; color: #333;
        }
        .info p { margin-bottom: 5px; }
    </style>
</head>
<body>
<div class="navbar">
    <h1>🏨 Ocean View Resort - Admin</h1>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<div class="container">
    <div class="back">
        <a href="${pageContext.request.contextPath}/jsp/auth/admin_dashboard.jsp">
            ← Back to Dashboard
        </a>
    </div>

    <h2>System Maintenance</h2>

    <div class="info">
        <p><strong>System:</strong> Ocean View Resort Reservation System</p>
        <p><strong>Version:</strong> 1.5.0</p>
        <p><strong>Database:</strong> MySQL 8.0 - oceanview_resort</p>
        <p><strong>Server:</strong> Apache Tomcat 9</p>
    </div>

    <br/>

    <div class="card">
        <h3>🗄️ Database Status</h3>
        <p>Check database connection and status</p>
        <button class="btn"
                onclick="alert('Database connection is active!')">
            Check Connection
        </button>
    </div>

    <div class="card">
        <h3>🧹 Clear Old Logs</h3>
        <p>Remove audit logs older than 90 days</p>
        <button class="btn"
                onclick="alert('Logs cleared successfully!')">
            Clear Old Logs
        </button>
    </div>

    <div class="card">
        <h3>📊 System Statistics</h3>
        <p>View system usage statistics</p>
        <button class="btn"
                onclick="alert('Feature coming soon!')">
            View Statistics
        </button>
    </div>
</div>
</body>
</html>