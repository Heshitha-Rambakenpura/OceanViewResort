<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role = (String) session.getAttribute("userRole");
%>
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
        h2 { color: #1F4E79; margin-bottom: 10px; }
        .role-badge {
            display: inline-block;
            padding: 4px 12px; border-radius: 20px;
            font-size: 13px; margin-bottom: 25px;
            font-weight: bold;
        }
        .RECEPTIONIST { background: #e0f0ff; color: #0066cc; }
        .ADMIN        { background: #ffe0e0; color: #cc0000; }
        .FINANCE      { background: #e0ffe0; color: #006600; }
        .section {
            background: white; padding: 25px;
            border-radius: 10px; margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .RECEPTIONIST-border { border-left: 5px solid #0066cc; }
        .ADMIN-border        { border-left: 5px solid #cc0000; }
        .FINANCE-border      { border-left: 5px solid #006600; }
        .section h3 {
            color: #1F4E79; margin-bottom: 15px; font-size: 17px;
        }
        .step {
            background: #f8f9fa; padding: 10px 15px;
            border-radius: 6px; margin-bottom: 8px;
            font-size: 14px; color: #333;
        }
        .step strong { color: #1F4E79; }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .tip {
            background: #fffbe0; border-left: 4px solid #ffcc00;
            padding: 12px 15px; border-radius: 6px;
            margin-top: 10px; font-size: 13px; color: #555;
        }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<div class="container">
    <div class="back">
        <%
            if ("RECEPTIONIST".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/jsp/auth/receptionist_dashboard.jsp">
                    ← Back to Dashboard
                </a>
        <%  } else if ("ADMIN".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/jsp/auth/admin_dashboard.jsp">
                    ← Back to Dashboard
                </a>
        <%  } else if ("FINANCE".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/jsp/auth/finance_dashboard.jsp">
                    ← Back to Dashboard
                </a>
        <%  } %>
    </div>

    <h2>❓ Help Section</h2>
    <div class="role-badge <%= role %>">
        <%= role %> Guide
    </div>

    <%-- ═══ RECEPTIONIST HELP ═══ --%>
    <% if ("RECEPTIONIST".equals(role)) { %>

        <div class="section RECEPTIONIST-border">
            <h3>🔐 How to Login and Logout</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Enter your username and password on the login page
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Click Login - you will be redirected to your dashboard
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Click Logout in top right corner when finished
            </div>
            <div class="tip">
                💡 Session expires after 30 minutes of inactivity
            </div>
        </div>

        <div class="section RECEPTIONIST-border">
            <h3>👤 How to Register a Guest</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click Register Guest on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Enter NIC number - system checks for duplicates automatically
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Fill in name, nationality, address, contact and email
            </div>
            <div class="step">
                <strong>Step 4:</strong>
                Click Register Guest button
            </div>
            <div class="step">
                <strong>Step 5:</strong>
                Note the Guest ID shown in success message for reservations
            </div>
            <div class="tip">
                💡 NIC is required for all guests as per Sri Lankan hotel regulations
            </div>
        </div>

        <div class="section RECEPTIONIST-border">
            <h3>🛏️ How to Add a Reservation</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click Add Reservation on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Enter the Guest ID of registered guest
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Select an available room from dropdown
            </div>
            <div class="step">
                <strong>Step 4:</strong>
                Select check-in and check-out dates
            </div>
            <div class="step">
                <strong>Step 5:</strong>
                Enter number of guests and any special requests
            </div>
            <div class="step">
                <strong>Step 6:</strong>
                Click Add Reservation - bill is generated automatically
            </div>
            <div class="tip">
                💡 Room availability is updated automatically when reservation is added
            </div>
        </div>

        <div class="section RECEPTIONIST-border">
            <h3>💳 How to Process Payment</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click View Reservations on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Find the reservation and click Pay button
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Review the bill summary including tax
            </div>
            <div class="step">
                <strong>Step 4:</strong>
                Select payment method - Cash, Card or Online Transfer
            </div>
            <div class="step">
                <strong>Step 5:</strong>
                Enter payment details and click Process Payment
            </div>
            <div class="step">
                <strong>Step 6:</strong>
                Note the receipt number for records
            </div>
            <div class="tip">
                💡 For cash payments system calculates change automatically
            </div>
        </div>

        <div class="section RECEPTIONIST-border">
            <h3>❌ How to Cancel a Reservation</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click View Reservations on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Find the reservation and click Cancel button
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Confirm cancellation in popup
            </div>
            <div class="tip">
                💡 Room becomes available again automatically after cancellation
            </div>
        </div>

    <%-- ═══ ADMIN HELP ═══ --%>
    <% } else if ("ADMIN".equals(role)) { %>

        <div class="section ADMIN-border">
            <h3>🔐 How to Login and Logout</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Enter admin username and password on login page
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Click Login - you will be redirected to Admin Dashboard
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Click Logout in top right corner when finished
            </div>
            <div class="tip">
                💡 Admin accounts have highest system privileges - keep credentials secure
            </div>
        </div>

        <div class="section ADMIN-border">
            <h3>👥 How to Manage User Accounts</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click Manage Users on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Fill in full name, username and password
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Select role - Receptionist, Admin or Finance Department
            </div>
            <div class="step">
                <strong>Step 4:</strong>
                Click Create Account
            </div>
            <div class="tip">
                💡 Only Admin can create new staff accounts in the system
            </div>
        </div>

        <div class="section ADMIN-border">
            <h3>📋 How to View Audit Logs</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click View Audit Logs on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                View all system activities including logins, registrations and payments
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Each log shows user, action, timestamp and IP address
            </div>
            <div class="tip">
                💡 All system actions are logged automatically for security monitoring
            </div>
        </div>

        <div class="section ADMIN-border">
            <h3>⚙️ How to Maintain System</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click Maintain System on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Check database connection status
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Clear old audit logs if needed
            </div>
            <div class="step">
                <strong>Step 4:</strong>
                View system statistics and version information
            </div>
            <div class="tip">
                💡 Regular maintenance ensures system performance and security
            </div>
        </div>

    <%-- ═══ FINANCE HELP ═══ --%>
    <% } else if ("FINANCE".equals(role)) { %>

        <div class="section FINANCE-border">
            <h3>🔐 How to Login and Logout</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Enter your finance department username and password
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Click Login - you will be redirected to Finance Dashboard
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Click Logout in top right corner when finished
            </div>
            <div class="tip">
                💡 Finance accounts can only view reports - no operational access
            </div>
        </div>

        <div class="section FINANCE-border">
            <h3>📊 How to Generate Income Report</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click Income Reports on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Select start date and end date for report period
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Click View Report to display on screen
            </div>
            <div class="step">
                <strong>Step 4:</strong>
                Report shows all payments with receipt numbers,
                amounts and payment methods
            </div>
            <div class="tip">
                💡 Reports are logged automatically for audit purposes
            </div>
        </div>

        <div class="section FINANCE-border">
            <h3>💾 How to Export Report</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click Income Reports on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Select start date and end date
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                Click Export Report button instead of View Report
            </div>
            <div class="step">
                <strong>Step 4:</strong>
                Report data will be available for download
            </div>
            <div class="tip">
                💡 Exported reports are logged as REPORT_EXPORTED in audit trail
            </div>
        </div>

        <div class="section FINANCE-border">
            <h3>💰 How to View Payment Summary</h3>
            <div class="step">
                <strong>Step 1:</strong>
                Click Payment Summary on dashboard
            </div>
            <div class="step">
                <strong>Step 2:</strong>
                Select date range for summary
            </div>
            <div class="step">
                <strong>Step 3:</strong>
                View all transactions including Cash, Card and Online Transfer
            </div>
            <div class="tip">
                💡 Payment summary shows status of each transaction
            </div>
        </div>

    <% } %>

</div>
</body>
</html>