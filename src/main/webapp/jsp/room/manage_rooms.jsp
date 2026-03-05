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
    <title>Manage Rooms</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar {
            background: #1F4E79; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
        }
        .navbar a {
            color: white; text-decoration: none;
            margin-left: 15px;
        }
        .container { padding: 30px; }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px; margin-bottom: 25px;
        }
        .stat-card {
            background: white; padding: 20px;
            border-radius: 10px; text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            font-size: 12px; color: #888;
            margin-bottom: 8px; text-transform: uppercase;
        }
        .stat-card p {
            font-size: 32px; font-weight: bold;
        }
        .total p     { color: #1F4E79; }
        .available p { color: #006600; }
        .occupied p  { color: #cc0000; }
        .layout {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 25px; align-items: start;
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
            font-weight: bold; font-size: 13px;
        }
        input, select, textarea {
            width: 100%; padding: 9px 10px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 13px;
        }
        input:focus, select:focus {
            outline: none; border-color: #2E75B6;
        }
        .btn {
            padding: 9px 18px; border: none;
            border-radius: 6px; cursor: pointer;
            font-size: 13px; font-weight: bold;
        }
        .btn-primary {
            background: #1F4E79; color: white;
            width: 100%; padding: 11px;
        }
        .btn-danger  { background: #cc0000; color: white; }
        .btn-warning { background: #cc6600; color: white; }
        .btn:hover   { opacity: 0.85; }
        .error {
            background: #ffe0e0; color: #cc0000;
            padding: 12px; border-radius: 6px;
            margin-bottom: 15px; font-size: 13px;
        }
        .success {
            background: #e0ffe0; color: #006600;
            padding: 12px; border-radius: 6px;
            margin-bottom: 15px; font-size: 13px;
        }
        table {
            width: 100%; border-collapse: collapse;
            background: white; border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        th {
            background: #1F4E79; color: white;
            padding: 11px; text-align: left; font-size: 13px;
        }
        td {
            padding: 11px; border-bottom: 1px solid #eee;
            font-size: 13px;
        }
        tr:hover td { background: #EBF3FB; }
        .badge {
            padding: 3px 9px; border-radius: 20px;
            font-size: 11px; font-weight: bold;
        }
        .available-badge {
            background: #e0ffe0; color: #006600;
        }
        .occupied-badge {
            background: #ffe0e0; color: #cc0000;
        }
        .actions { display: flex; gap: 5px; }
        .modal {
            display: none; position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center; justify-content: center;
        }
        .modal.show { display: flex; }
        .modal-box {
            background: white; padding: 30px;
            border-radius: 10px; width: 420px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .modal-box h3 {
            color: #1F4E79; margin-bottom: 20px;
        }
        .modal-footer {
            display: flex; gap: 10px;
            justify-content: flex-end; margin-top: 20px;
        }
        .btn-cancel {
            background: #888; color: white;
            padding: 9px 18px; border: none;
            border-radius: 6px; cursor: pointer;
        }
        .tab-links {
            display: flex; gap: 10px; margin-bottom: 25px;
        }
        .tab-link {
            padding: 10px 20px; border-radius: 6px;
            text-decoration: none; font-size: 14px;
            font-weight: bold;
        }
        .tab-active {
            background: #1F4E79; color: white;
        }
        .tab-inactive {
            background: white; color: #1F4E79;
            border: 2px solid #1F4E79;
        }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort - Admin</h1>
    <a href="${pageContext.request.contextPath}/logout">
        Logout
    </a>
</div>

<div class="container">
    <div class="back">
        <a href="${pageContext.request.contextPath}/jsp/auth/admin_dashboard.jsp">
            ← Back to Dashboard
        </a>
    </div>

    <h2>🛏️ Manage Rooms</h2>

    <%-- ─── TABS ─── --%>
    <div class="tab-links">
        <a href="${pageContext.request.contextPath}/room?action=manageRooms"
           class="tab-link tab-active">
            🛏️ Rooms
        </a>
        <a href="${pageContext.request.contextPath}/room?action=manageRoomTypes"
           class="tab-link tab-inactive">
            📋 Room Types
        </a>
    </div>

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

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <div class="success">${success}</div>
    <% } %>

    <div class="layout">

        <%-- ─── ADD ROOM FORM ─── --%>
        <div class="form-card">
            <h3>➕ Add New Room</h3>
            <form method="post"
                  action="${pageContext.request.contextPath}/room">
                <input type="hidden" name="formAction"
                       value="saveRoom" />
                <div class="form-group">
                    <label>Room Number *</label>
                    <input type="text" name="roomNumber"
                           placeholder="e.g. 101" required />
                </div>
                <div class="form-group">
                    <label>Room Type *</label>
                    <select name="roomTypeId" required>
                        <option value="">
                            -- Select Room Type --
                        </option>
                        <c:forEach var="rt" items="${roomTypes}">
                            <option value="${rt.roomTypeId}">
                                ${rt.typeName} -
                                Rs.${rt.basePrice}/night
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Floor Number *</label>
                    <input type="number" name="floorNumber"
                           min="1" max="20"
                           placeholder="e.g. 1" required />
                </div>
                <div class="form-group">
                    <label>Max Occupancy *</label>
                    <input type="number" name="maxOccupancy"
                           min="1" max="10"
                           placeholder="e.g. 2" required />
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <input type="text" name="description"
                           placeholder="Room description" />
                </div>
                <button type="submit" class="btn btn-primary">
                    Add Room
                </button>
            </form>
        </div>

        <%-- ─── ROOM TABLE ─── --%>
        <div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Room No</th>
                        <th>Type</th>
                        <th>Floor</th>
                        <th>Max</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty rooms}">
                            <tr>
                                <td colspan="7"
                                    style="text-align:center;
                                           padding:30px;
                                           color:#888;">
                                    No rooms found
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="room"
                                       items="${rooms}">
                                <tr>
                                    <td>${room.roomId}</td>
                                    <td>${room.roomNumber}</td>
                                    <td>${room.roomType.typeName}</td>
                                    <td>${room.floorNumber}</td>
                                    <td>${room.maxOccupancy}</td>
                                    <td>
                                        <span class="badge
                                            ${room.available ?
                                            'available-badge' :
                                            'occupied-badge'}">
                                            ${room.available ?
                                            '✅ Available' :
                                            '🔴 Occupied'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <button
                                                class="btn btn-warning"
                                                onclick="openEditRoom(
                                                '${room.roomId}',
                                                '${room.roomNumber}',
                                                '${room.roomType.roomTypeId}',
                                                '${room.floorNumber}',
                                                '${room.maxOccupancy}',
                                                '${room.description}')">
                                                ✏️ Edit
                                            </button>
                                            <button
                                                class="btn btn-danger"
                                                onclick="confirmDeleteRoom(
                                                '${room.roomId}',
                                                '${room.roomNumber}')">
                                                🗑️ Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- ─── EDIT ROOM MODAL ─── --%>
<div class="modal" id="editRoomModal">
    <div class="modal-box">
        <h3>✏️ Edit Room</h3>
        <form method="post"
              action="${pageContext.request.contextPath}/room">
            <input type="hidden" name="formAction"
                   value="updateRoom" />
            <input type="hidden" name="roomId"
                   id="editRoomId" />
            <div class="form-group">
                <label>Room Number *</label>
                <input type="text" name="roomNumber"
                       id="editRoomNumber" required />
            </div>
            <div class="form-group">
                <label>Room Type *</label>
                <select name="roomTypeId"
                        id="editRoomTypeId" required>
                    <c:forEach var="rt" items="${roomTypes}">
                        <option value="${rt.roomTypeId}">
                            ${rt.typeName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Floor Number *</label>
                <input type="number" name="floorNumber"
                       id="editFloorNumber"
                       min="1" required />
            </div>
            <div class="form-group">
                <label>Max Occupancy *</label>
                <input type="number" name="maxOccupancy"
                       id="editMaxOccupancy"
                       min="1" required />
            </div>
            <div class="form-group">
                <label>Description</label>
                <input type="text" name="description"
                       id="editRoomDesc" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel"
                        onclick="closeModal('editRoomModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-warning">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<%-- ─── DELETE ROOM MODAL ─── --%>
<div class="modal" id="deleteRoomModal">
    <div class="modal-box">
        <h3>🗑️ Delete Room</h3>
        <p id="deleteRoomText"
           style="color:#555; margin-bottom:20px;
                  font-size:14px;"></p>
        <div class="modal-footer">
            <button type="button" class="btn-cancel"
                    onclick="closeModal('deleteRoomModal')">
                Cancel
            </button>
            <a id="deleteRoomBtn" href="#"
               class="btn btn-danger">
                Delete Room
            </a>
        </div>
    </div>
</div>

<script>
function openEditRoom(id, number, typeId,
                      floor, maxOcc, desc) {
    document.getElementById('editRoomId').value
        = id;
    document.getElementById('editRoomNumber').value
        = number;
    document.getElementById('editRoomTypeId').value
        = typeId;
    document.getElementById('editFloorNumber').value
        = floor;
    document.getElementById('editMaxOccupancy').value
        = maxOcc;
    document.getElementById('editRoomDesc').value
        = desc || '';
    document.getElementById('editRoomModal')
            .classList.add('show');
}

function confirmDeleteRoom(id, number) {
    document.getElementById('deleteRoomText').textContent
        = 'Are you sure you want to delete Room '
          + number + '?';
    document.getElementById('deleteRoomBtn').href
        = '${pageContext.request.contextPath}/room'
          + '?action=deleteRoom&roomId=' + id;
    document.getElementById('deleteRoomModal')
            .classList.add('show');
}

function closeModal(id) {
    document.getElementById(id)
            .classList.remove('show');
}

window.onclick = function(e) {
    document.querySelectorAll('.modal').forEach(m => {
        if (e.target === m) m.classList.remove('show');
    });
}
</script>

</body>
</html>