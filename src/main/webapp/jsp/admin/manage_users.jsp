<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        .container { padding: 30px; }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .layout {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 25px;
            align-items: start;
        }
        .form-card {
            background: white; padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-top: 4px solid #cc0000;
        }
        .form-card h3 {
            color: #1F4E79; margin-bottom: 20px;
        }
        .form-group { margin-bottom: 15px; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; font-size: 14px; color: #333;
        }
        input, select {
            width: 100%; padding: 10px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 14px;
        }
        input:focus, select:focus {
            outline: none; border-color: #2E75B6;
        }
        button {
            width: 100%; background: #1F4E79; color: white;
            padding: 12px; border: none;
            border-radius: 6px; font-size: 15px; cursor: pointer;
        }
        button:hover { background: #2E75B6; }
        .error {
            background: #ffe0e0; color: #cc0000;
            padding: 12px; border-radius: 6px;
            margin-bottom: 15px; font-size: 14px;
        }
        .success {
            background: #e0ffe0; color: #006600;
            padding: 12px; border-radius: 6px;
            margin-bottom: 15px; font-size: 14px;
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
        .role-badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
        }
        .ADMIN        { background: #ffe0e0; color: #cc0000; }
        .RECEPTIONIST { background: #e0f0ff; color: #0066cc; }
        .FINANCE      { background: #e0ffe0; color: #006600; }
        .password-hint {
            font-size: 12px; color: #888; margin-top: 4px;
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

    <h2>👥 Manage User Accounts</h2>

    <div class="layout">

        <%-- ─── CREATE USER FORM ─── --%>
        <div class="form-card">
            <h3>Create New Account</h3>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error">${error}</div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="success">${success}</div>
            <% } %>

            <form method="post"
                  action="${pageContext.request.contextPath}/admin">
                <div class="form-group">
                    <label>Full Name *</label>
                    <input type="text" name="name"
                           placeholder="Enter full name"
                           required />
                </div>
                <div class="form-group">
                    <label>Username *</label>
                    <input type="text" name="username"
                           placeholder="Enter username"
                           required />
                </div>
                <div class="form-group">
                    <label>Password *</label>
                    <input type="password" name="password"
                           placeholder="Enter password"
                           required />
                    <p class="password-hint">
                        Minimum 6 characters
                    </p>
                </div>
                <div class="form-group">
                    <label>Confirm Password *</label>
                    <input type="password"
                           name="confirmPassword"
                           placeholder="Re-enter password"
                           required />
                </div>
                <div class="form-group">
                    <label>Role *</label>
                    <select name="role" required>
                        <option value="">-- Select Role --</option>
                        <option value="RECEPTIONIST">
                            Receptionist
                        </option>
                        <option value="ADMIN">Admin</option>
                        <option value="FINANCE">
                            Finance Department
                        </option>
                    </select>
                </div>
                <button type="submit">
                    Create Account
                </button>
            </form>
        </div>

        <%-- ─── USER LIST ─── --%>
        <div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Registered</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty users}">
                            <tr>
                                <td colspan="5"
                                    style="text-align:center;
                                           padding:30px;
                                           color:#888;">
                                    No users found
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>${u.userId}</td>
                                    <td>${u.name}</td>
                                    <td>${u.username}</td>
                                    <td>
                                        <span class="role-badge ${u.role}">
                                            ${u.role}
                                        </span>
                                    </td>
                                    <td>${u.registerDate}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>
</div>

</body>
</html>