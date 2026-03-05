<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
} %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Reservation</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
        }
        .navbar a { color: white; text-decoration: none; }
        .container { padding: 30px; max-width: 700px; margin: 0 auto; }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .detail-card {
            background: white; padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .detail-row {
            display: flex; padding: 12px 0;
            border-bottom: 1px solid #eee; font-size: 14px;
        }
        .detail-row:last-child { border-bottom: none; }
        .detail-label {
            font-weight: bold; color: #555;
            width: 180px; min-width: 180px;
        }
        .detail-value { color: #333; }
        .badge {
            padding: 4px 10px; border-radius: 20px; font-size: 12px;
        }
        .CONFIRMED { background: #e0ffe0; color: #006600; }
        .CANCELLED { background: #ffe0e0; color: #cc0000; }
        .btn {
            display: inline-block; margin-top: 20px;
            padding: 10px 25px; background: #1F4E79;
            color: white; text-decoration: none;
            border-radius: 6px; font-size: 14px;
            margin-right: 10px;
        }
        .btn-danger { background: #cc0000; }
        .section-title {
            color: #1F4E79; font-size: 16px;
            font-weight: bold; margin: 20px 0 10px;
            padding-bottom: 5px;
            border-bottom: 2px solid #EBF3FB;
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
        <a href="${pageContext.request.contextPath}/jsp/auth/receptionist_dashboard.jsp">
            ← Back to Dashboard
        </a>
    </div>

    <h2>Reservation Details</h2>

    <div class="detail-card">
        <p class="section-title">Reservation Information</p>
        <div class="detail-row">
            <span class="detail-label">Reservation ID:</span>
            <span class="detail-value">
                ${reservation.reservationId}
            </span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Status:</span>
            <span class="detail-value">
                <span class="badge ${reservation.status}">
                    ${reservation.status}
                </span>
            </span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Check In Date:</span>
            <span class="detail-value">${reservation.checkInDate}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Check Out Date:</span>
            <span class="detail-value">${reservation.checkOutDate}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Number of Nights:</span>
            <span class="detail-value">
                ${reservation.numberOfNights}
            </span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Number of Guests:</span>
            <span class="detail-value">
                ${reservation.numberOfGuests}
            </span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Special Requests:</span>
            <span class="detail-value">
                ${reservation.specialRequests}
            </span>
        </div>

        <p class="section-title">Guest Information</p>
        <div class="detail-row">
            <span class="detail-label">Guest Name:</span>
            <span class="detail-value">${reservation.guest.name}</span>
        </div>

        <p class="section-title">Room Information</p>
        <div class="detail-row">
            <span class="detail-label">Room Number:</span>
            <span class="detail-value">
                ${reservation.room.roomNumber}
            </span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Room Type:</span>
            <span class="detail-value">
                ${reservation.room.roomType.typeName}
            </span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Price Per Night:</span>
            <span class="detail-value">
                Rs. ${reservation.room.roomType.basePrice}
            </span>
        </div>

        <div>
            <a href="${pageContext.request.contextPath}/payment?reservationId=${reservation.reservationId}"
               class="btn">
                Make Payment
            </a>
            <a href="${pageContext.request.contextPath}/reservation?action=cancel&id=${reservation.reservationId}"
               class="btn btn-danger"
               onclick="return confirm('Cancel this reservation?')">
                Cancel Reservation
            </a>
        </div>
    </div>
</div>
</body>
</html>