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
    <title>Help Section</title>
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
        h2 { color: #1F4E79; margin-bottom: 25px; }
        .section {
            background: white; padding: 25px;
            border-radius: 10px; margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #2E75B6;
        }
        .section h3 { color: #1F4E79; margin-bottom: 15px; font-size: 18px; }
        .section p { color: #555; line-height: 1.7; margin-bottom: 10px; }
        .step {
            background: #EBF3FB; padding: 10px 15px;
            border-radius: 6px; margin-bottom: 8px;
            font-size: 14px; color: #333;
        }
        .step strong { color: #1F4E79; }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<div class="container">
    <h2>❓ Help Section</h2>

    <div class="section">
        <h3>🔐 How to Login</h3>
        <div class="step"><strong>Step 1:</strong> Enter your username provided by Admin</div>
        <div class="step"><strong>Step 2:</strong> Enter your password</div>
        <div class="step"><strong>Step 3:</strong> Click Login button</div>
        <div class="step"><strong>Step 4:</strong> You will be redirected to your dashboard</div>
    </div>

    <div class="section">
        <h3>👤 How to Register a Guest</h3>
        <div class="step"><strong>Step 1:</strong> Click Register Guest on dashboard</div>
        <div class="step"><strong>Step 2:</strong> Enter guest NIC, name, nationality, address, contact and email</div>
        <div class="step"><strong>Step 3:</strong> Click Register Guest button</div>
        <div class="step"><strong>Step 4:</strong> Note the Guest ID for making reservations</div>
    </div>

    <div class="section">
        <h3>🛏️ How to Add a Reservation</h3>
        <div class="step"><strong>Step 1:</strong> Click Add Reservation on dashboard</div>
        <div class="step"><strong>Step 2:</strong> Enter the Guest ID</div>
        <div class="step"><strong>Step 3:</strong> Select available room</div>
        <div class="step"><strong>Step 4:</strong> Select check-in and check-out dates</div>
        <div class="step"><strong>Step 5:</strong> Click Add Reservation</div>
    </div>

    <div class="section">
        <h3>💳 How to Process Payment</h3>
        <div class="step"><strong>Step 1:</strong> Click Make Payment on dashboard</div>
        <div class="step"><strong>Step 2:</strong> Enter Reservation ID</div>
        <div class="step"><strong>Step 3:</strong> Review bill summary</div>
        <div class="step"><strong>Step 4:</strong> Select payment method (Cash/Card/Online Transfer)</div>
        <div class="step"><strong>Step 5:</strong> Enter payment details and click Process Payment</div>
    </div>

    <div class="section">
        <h3>📊 How to Generate Reports</h3>
        <div class="step"><strong>Step 1:</strong> Click View Reports on dashboard</div>
        <div class="step"><strong>Step 2:</strong> Select start and end dates</div>
        <div class="step"><strong>Step 3:</strong> Click View Report to display</div>
        <div class="step"><strong>Step 4:</strong> Click Export Report to download</div>
    </div>

</div>

</body>
</html>