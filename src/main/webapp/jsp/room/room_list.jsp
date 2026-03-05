<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Room Management</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
        }
        .navbar a {
            color: white; text-decoration: none; margin-left: 15px;
        }
        .container { padding: 30px; }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }

        /* ─── STATS CARDS ─── */
        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px; margin-bottom: 30px;
        }
        .stat-card {
            background: white; padding: 20px;
            border-radius: 10px; text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            font-size: 13px; color: #888;
            margin-bottom: 10px; text-transform: uppercase;
        }
        .stat-card p {
            font-size: 36px; font-weight: bold;
        }
        .total    p { color: #1F4E79; }
        .available p { color: #006600; }
        .occupied  p { color: #cc0000; }

        /* ─── ROOM CARDS ─── */
        .rooms-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        .room-card {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.2s;
        }
        .room-card:hover { transform: translateY(-3px); }
        .room-card-header {
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .available-header { background: #e0ffe0; }
        .occupied-header  { background: #ffe0e0; }
        .room-number {
            font-size: 22px; font-weight: bold; color: #1F4E79;
        }
        .status-badge {
            padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: bold;
        }
        .available-badge {
            background: #006600; color: white;
        }
        .occupied-badge {
            background: #cc0000; color: white;
        }
        .room-card-body { padding: 20px; }
        .room-detail {
            display: flex; justify-content: space-between;
            padding: 8px 0; border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        .room-detail:last-child { border-bottom: none; }
        .room-detail-label { color: #888; }
        .room-detail-value { color: #333; font-weight: bold; }
        .amenities {
            margin-top: 12px; padding: 10px;
            background: #f8f9fa; border-radius: 6px;
            font-size: 13px; color: #555;
        }
        .amenities strong { color: #1F4E79; }

        /* ─── FILTER ─── */
        .filter-bar {
            background: white; padding: 15px 20px;
            border-radius: 10px; margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex; gap: 15px; align-items: center;
        }
        .filter-bar label {
            font-weight: bold; color: #333; font-size: 14px;
        }
        .filter-btn {
            padding: 8px 18px; border: 2px solid #1F4E79;
            border-radius: 20px; cursor: pointer;
            font-size: 13px; background: white; color: #1F4E79;
            transition: all 0.2s;
        }
        .filter-btn.active,
        .filter-btn:hover {
            background: #1F4E79; color: white;
        }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <div>
        <a href="${pageContext.request.contextPath}/reservation">
            Add Reservation
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            Logout
        </a>
    </div>
</div>

<div class="container">
    <div class="back">
        <a href="${pageContext.request.contextPath}/jsp/auth/receptionist_dashboard.jsp">
            ← Back to Dashboard
        </a>
    </div>

    <h2>🛏️ Room Management</h2>

    <%-- ─── STATS ─── --%>
    <div class="stats">
        <div class="stat-card total">
            <h3>Total Rooms</h3>
            <p>${totalCount}</p>
        </div>
        <div class="stat-card available">
            <h3>Available</h3>
            <p>${availableCount}</p>
        </div>
        <div class="stat-card occupied">
            <h3>Occupied</h3>
            <p>${occupiedCount}</p>
        </div>
    </div>

    <%-- ─── FILTER BAR ─── --%>
    <div class="filter-bar">
        <label>Filter:</label>
        <button class="filter-btn active"
                onclick="filterRooms('all', this)">
            All Rooms
        </button>
        <button class="filter-btn"
                onclick="filterRooms('available', this)">
            Available Only
        </button>
        <button class="filter-btn"
                onclick="filterRooms('occupied', this)">
            Occupied Only
        </button>
    </div>

    <%-- ─── ROOM CARDS ─── --%>
    <div class="rooms-grid" id="roomsGrid">
        <c:forEach var="room" items="${allRooms}">
            <div class="room-card"
                 data-status="${room.available ? 'available' : 'occupied'}">

                <div class="room-card-header
                     ${room.available ?
                       'available-header' : 'occupied-header'}">
                    <span class="room-number">
                        Room ${room.roomNumber}
                    </span>
                    <span class="status-badge
                         ${room.available ?
                           'available-badge' : 'occupied-badge'}">
                        ${room.available ? '✅ Available' : '🔴 Occupied'}
                    </span>
                </div>

                <div class="room-card-body">
                    <div class="room-detail">
                        <span class="room-detail-label">Room Type</span>
                        <span class="room-detail-value">
                            ${room.roomType.typeName}
                        </span>
                    </div>
                    <div class="room-detail">
                        <span class="room-detail-label">Floor</span>
                        <span class="room-detail-value">
                            Floor ${room.floorNumber}
                        </span>
                    </div>
                    <div class="room-detail">
                        <span class="room-detail-label">
                            Max Occupancy
                        </span>
                        <span class="room-detail-value">
                            ${room.maxOccupancy} Guests
                        </span>
                    </div>
                    <div class="room-detail">
                        <span class="room-detail-label">
                            Price/Night
                        </span>
                        <span class="room-detail-value">
                            Rs. ${room.roomType.basePrice}
                        </span>
                    </div>
                    <div class="amenities">
                        <strong>Amenities:</strong>
                        ${room.roomType.amenities}
                    </div>
                </div>

            </div>
        </c:forEach>
    </div>
</div>

<script>
function filterRooms(status, btn) {
    // Update active button
    document.querySelectorAll('.filter-btn')
            .forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    // Filter cards
    document.querySelectorAll('.room-card').forEach(card => {
        if (status === 'all') {
            card.style.display = 'block';
        } else {
            card.style.display =
                card.dataset.status === status ? 'block' : 'none';
        }
    });
}
</script>

</body>
</html>