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
    <title>Manage Users</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
        }
        .navbar a { color: white; text-decoration: none; }
        .container { padding: 30px; max-width: 900px; margin: 0 auto; }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .form-card {
            background: white; padding: 30px;
            border-radius: 10px; margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-card h3 { color: #1F4E79; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; font-size: 14px;
        }
        input, select {
            width: 100%; padding: 10px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 14px;
        }
        button {
            background: #1F4E79; color: white;
            padding: 10px 25px; border: none;
            border-radius: 6px; cursor: pointer; font-size: 14px;
        }
        button:hover { background: #2E75B6; }
        .error {
            background: #ffe0e0; color: #cc0000;
            padding: 12px; border-radius: 6px; margin-bottom: 20px;
        }
        .success {
            background: #e0ffe0; color: #006600;
            padding: 12px; border-radius: 6px; margin-bottom: 20px;
        }
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

    <h2>Manage User Accounts</h2>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <div class="success">${success}</div>
    <% } %>

    <div class="form-card">
        <h3>Create New User Account</h3>
        <form method="post"
              action="${pageContext.request.contextPath}/admin">
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="name"
                       placeholder="Enter full name" required />
            </div>
            <div class="form-group">
                <label>Username *</label>
                <input type="text" name="username"
                       placeholder="Enter username" required />
            </div>
            <div class="form-group">
                <label>Password *</label>
                <input type="password" name="password"
                       placeholder="Enter password" required />
            </div>
            <div class="form-group">
                <label>Role *</label>
                <select name="role" required>
                    <option value="">-- Select Role --</option>
                    <option value="RECEPTIONIST">Receptionist</option>
                    <option value="ADMIN">Admin</option>
                    <option value="FINANCE">Finance Department</option>
                </select>
            </div>
            <button type="submit">Create Account</button>
        </form>
    </div>
</div>

</body>
</html>