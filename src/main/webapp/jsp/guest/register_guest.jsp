<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Check session --%>
<% if (session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
} %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register Guest</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
        }
        .navbar a { color: white; text-decoration: none; }
        .container { padding: 30px; max-width: 700px; margin: 0 auto; }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .form-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group { margin-bottom: 20px; }
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #333;
            font-size: 14px;
        }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #2E75B6;
        }
        button {
            background: #1F4E79;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
        }
        button:hover { background: #2E75B6; }
        .error {
            background: #ffe0e0;
            color: #cc0000;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .success {
            background: #e0ffe0;
            color: #006600;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<div class="container">
    <div class="back">
        <a href="${pageContext.request.contextPath}/jsp/auth/receptionist_dashboard.jsp">
            ← Back to Dashboard
        </a>
    </div>

    <h2>Register New Guest</h2>

    <div class="form-card">
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">${error}</div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success">${success}</div>
        <% } %>

        <form method="post"
              action="${pageContext.request.contextPath}/guest">
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="name"
                       placeholder="Enter full name" required />
            </div>
            <div class="form-group">
                <label>NIC Number / Passport Number *</label>
                <input type="text" name="nic"
                       placeholder="Enter NIC number or Passport Number" required />
            </div>
            <div class="form-group">
                <label>Nationality *</label>
                <input type="text" name="nationality"
                       placeholder="Enter nationality" required />
            </div>
            <div class="form-group">
                <label>Address *</label>
                <textarea name="address" rows="3"
                          placeholder="Enter address"
                          required></textarea>
            </div>
            <div class="form-group">
                <label>Contact Number *</label>
                <input type="text" name="contactNumber"
                       placeholder="Enter contact number" required />
            </div>
            <div class="form-group">
                <label>Email Address *</label>
                <input type="email" name="email"
                       placeholder="Enter email address" required />
            </div>
            <button type="submit">Register Guest</button>
        </form>
    </div>
</div>

</body>
</html>