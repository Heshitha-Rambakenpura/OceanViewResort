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
    <title>Generate Report</title>
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
        .form-card {
            background: white; padding: 25px;
            border-radius: 10px; margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex; gap: 20px; align-items: flex-end;
        }
        .form-group { flex: 1; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; font-size: 14px;
        }
        input {
            width: 100%; padding: 10px;
            border: 2px solid #ddd; border-radius: 6px; font-size: 14px;
        }
        .btn-group { display: flex; gap: 10px; }
        button {
            padding: 10px 20px; border: none;
            border-radius: 6px; font-size: 14px; cursor: pointer;
        }
        .btn-view { background: #1F4E79; color: white; }
        .btn-export { background: #2E75B6; color: white; }
        button:hover { opacity: 0.85; }
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
        td { padding: 12px; border-bottom: 1px solid #eee; font-size: 14px; }
        tr:hover td { background: #EBF3FB; }
        .error {
            background: #ffe0e0; color: #cc0000;
            padding: 12px; border-radius: 6px; margin-bottom: 20px;
        }
        .badge {
            padding: 4px 10px; border-radius: 20px; font-size: 12px;
        }
        .SUCCESS { background: #e0ffe0; color: #006600; }
        .FAILED  { background: #ffe0e0; color: #cc0000; }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<div class="container">
    <h2>Generate Report</h2>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>

    <div class="form-card">
        <form method="post"
              action="${pageContext.request.contextPath}/report"
              style="display:flex; gap:20px; width:100%; align-items:flex-end;">
            <div class="form-group">
                <label>Start Date</label>
                <input type="date" name="startDate" required />
            </div>
            <div class="form-group">
                <label>End Date</label>
                <input type="date" name="endDate" required />
            </div>
            <div class="btn-group">
                <button type="submit" name="action"
                        value="view" class="btn-view">
                    View Report
                </button>
                <button type="submit" name="action"
                        value="export" class="btn-export">
                    Export Report
                </button>
            </div>
        </form>
    </div>

    <%-- Report Table --%>
    <c:if test="${not empty payments}">
        <h3 style="color:#1F4E79; margin-bottom:15px;">
            Report: ${startDate} to ${endDate}
        </h3>
        <table>
            <thead>
                <tr>
                    <th>Receipt No</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="payment" items="${payments}">
                    <tr>
                        <td>${payment.receiptNumber}</td>
                        <td>Rs. ${payment.amount}</td>
                        <td>${payment.paymentStatus}</td>
                        <td>${payment.paymentDate}</td>
                        <td>
                            <span class="badge ${payment.paymentStatus}">
                                ${payment.paymentStatus}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

</body>
</html>