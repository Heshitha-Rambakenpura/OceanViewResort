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
    <title>Audit Logs</title>
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
        .search-bar {
            background: white; padding: 15px 20px;
            border-radius: 10px; margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex; gap: 10px;
        }
        .search-bar input {
            flex: 1; padding: 8px 12px;
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
        .badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
        }
        .LOGIN_SUCCESS  { background: #e0ffe0; color: #006600; }
        .LOGIN_FAILED   { background: #ffe0e0; color: #cc0000; }
        .PAYMENT_MADE   { background: #e0f0ff; color: #0066cc; }
        .REPORT_VIEWED  { background: #fff3e0; color: #cc6600; }
        .GUEST_REGISTERED { background: #f3e8ff; color: #6600cc; }
        .no-data {
            text-align: center; padding: 40px;
            color: #888; font-size: 16px;
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

    <h2>📋 Audit Logs</h2>

    <div class="search-bar">
        <input type="text" id="searchInput"
               placeholder="🔍 Search by action or IP address..."
               onkeyup="searchLogs()" />
    </div>

    <table>
        <thead>
            <tr>
                <th>Log ID</th>
                <th>User ID</th>
                <th>Action</th>
                <th>Timestamp</th>
                <th>IP Address</th>
            </tr>
        </thead>
        <tbody id="logsBody">
            <c:choose>
                <c:when test="${empty logs}">
                    <tr>
                        <td colspan="5" class="no-data">
                            No audit logs found
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="log" items="${logs}">
                        <tr>
                            <td>${log.logId}</td>
                            <td>${log.userId}</td>
                            <td>
                                <span class="badge ${log.action}">
                                    ${log.action}
                                </span>
                            </td>
                            <td>${log.timestamp}</td>
                            <td>${log.ipAddress}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script>
function searchLogs() {
    var input = document.getElementById('searchInput')
                        .value.toLowerCase();
    document.querySelectorAll('#logsBody tr')
            .forEach(row => {
        row.style.display =
            row.textContent.toLowerCase().includes(input)
            ? '' : 'none';
    });
}
</script>

</body>
</html>