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
    <title>Manage Room Types</title>
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
        .tab-links {
            display: flex; gap: 10px; margin-bottom: 25px;
        }
        .tab-link {
            padding: 10px 20px; border-radius: 6px;
            text-decoration: none; font-size: 14px;
            font-weight: bold;
        }
        .tab-active   { background: #1F4E79; color: white; }
        .tab-inactive {
            background: white; color: #1F4E79;
            border: 2px solid #1F4E79;
        }
        .layout {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 25px; align-items: start;
        }
        .form-card {
            background: white; padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-top: 4px solid #cc0000;
        }
        .form-card h3 { color: #1F4E79; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; font-size: 13px;
        }
        input, textarea {
            width: 100%; padding: 9px 10px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 13px;
        }
        input:focus, textarea:focus {
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
        .actions { display: flex; gap: 5px; }
        .modal {
            display: none; position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5); z-index: 1000;
            align-items: center; justify-content: center;
        }
        .modal.show { display: flex; }
        .modal-box {
            background: white; padding: 30px;
            border-radius: 10px; width: 420px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .modal-box h3 { color: #1F4E79; margin-bottom: 20px; }
        .modal-footer {
            display: flex; gap: 10px;
            justify-content: flex-end; margin-top: 20px;
        }
        .btn-cancel {
            background: #888; color: white;
            padding: 9px 18px; border: none;
            border-radius: 6px; cursor: pointer;
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

    <h2>📋 Room Types</h2>

    <%-- ─── TABS ─── --%>
    <div class="tab-links">
        <a href="${pageContext.request.contextPath}/room?action=manageRooms"
           class="tab-link tab-inactive">
            🛏️ Rooms
        </a>
        <a href="${pageContext.request.contextPath}/room?action=manageRoomTypes"
           class="tab-link tab-active">
            📋 Room Types
        </a>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <div class="success">${success}</div>
    <% } %>

    <div class="layout">

        <%-- ─── ADD ROOM TYPE FORM ─── --%>
        <div class="form-card">
            <h3>➕ Add New Room Type</h3>
            <form method="post"
                  action="${pageContext.request.contextPath}/room">
                <input type="hidden" name="formAction"
                       value="saveRoomType" />
                <div class="form-group">
                    <label>Type Name *</label>
                    <input type="text" name="typeName"
                           placeholder="e.g. Deluxe"
                           required />
                </div>
                <div class="form-group">
                    <label>Description *</label>
                    <textarea name="description" rows="3"
                              placeholder="Room type description"
                              required></textarea>
                </div>
                <div class="form-group">
                    <label>Base Price per Night (Rs.) *</label>
                    <input type="number" name="basePrice"
                           min="0" step="0.01"
                           placeholder="e.g. 8000"
                           required />
                </div>
                <div class="form-group">
                    <label>Amenities</label>
                    <textarea name="amenities" rows="3"
                              placeholder="e.g. WiFi, AC, TV, Mini Bar">
                    </textarea>
                </div>
                <button type="submit" class="btn btn-primary">
                    Add Room Type
                </button>
            </form>
        </div>

        <%-- ─── ROOM TYPES TABLE ─── --%>
        <div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Type Name</th>
                        <th>Description</th>
                        <th>Price/Night</th>
                        <th>Amenities</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty roomTypes}">
                            <tr>
                                <td colspan="6"
                                    style="text-align:center;
                                           padding:30px;
                                           color:#888;">
                                    No room types found
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="rt"
                                       items="${roomTypes}">
                                <tr>
                                    <td>${rt.roomTypeId}</td>
                                    <td>${rt.typeName}</td>
                                    <td>${rt.description}</td>
                                    <td>Rs. ${rt.basePrice}</td>
                                    <td>${rt.amenities}</td>
                                    <td>
                                        <div class="actions">
                                            <button
                                                class="btn btn-warning"
                                                onclick="openEditRoomType(
                                                '${rt.roomTypeId}',
                                                '${rt.typeName}',
                                                '${rt.description}',
                                                '${rt.basePrice}',
                                                '${rt.amenities}')">
                                                ✏️ Edit
                                            </button>
                                            <button
                                                class="btn btn-danger"
                                                onclick="confirmDeleteRoomType(
                                                '${rt.roomTypeId}',
                                                '${rt.typeName}')">
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

<%-- ─── EDIT ROOM TYPE MODAL ─── --%>
<div class="modal" id="editRoomTypeModal">
    <div class="modal-box">
        <h3>✏️ Edit Room Type</h3>
        <form method="post"
              action="${pageContext.request.contextPath}/room">
            <input type="hidden" name="formAction"
                   value="updateRoomType" />
            <input type="hidden" name="roomTypeId"
                   id="editRoomTypeIdField" />
            <div class="form-group">
                <label>Type Name *</label>
                <input type="text" name="typeName"
                       id="editTypeName" required />
            </div>
            <div class="form-group">
                <label>Description *</label>
                <textarea name="description" rows="3"
                          id="editTypeDesc"
                          required></textarea>
            </div>
            <div class="form-group">
                <label>Base Price (Rs.) *</label>
                <input type="number" name="basePrice"
                       id="editBasePrice"
                       min="0" step="0.01" required />
            </div>
            <div class="form-group">
                <label>Amenities</label>
                <textarea name="amenities" rows="3"
                          id="editAmenities"></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel"
                        onclick="closeModal(
                            'editRoomTypeModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-warning">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<%-- ─── DELETE ROOM TYPE MODAL ─── --%>
<div class="modal" id="deleteRoomTypeModal">
    <div class="modal-box">
        <h3>🗑️ Delete Room Type</h3>
        <p id="deleteRoomTypeText"
           style="color:#555; margin-bottom:20px;
                  font-size:14px;"></p>
        <div class="modal-footer">
            <button type="button" class="btn-cancel"
                    onclick="closeModal(
                        'deleteRoomTypeModal')">
                Cancel
            </button>
            <a id="deleteRoomTypeBtn" href="#"
               class="btn btn-danger">
                Delete
            </a>
        </div>
    </div>
</div>

<script>
function openEditRoomType(id, name, desc,
                           price, amenities) {
    document.getElementById('editRoomTypeIdField').value
        = id;
    document.getElementById('editTypeName').value
        = name;
    document.getElementById('editTypeDesc').value
        = desc;
    document.getElementById('editBasePrice').value
        = price;
    document.getElementById('editAmenities').value
        = amenities || '';
    document.getElementById('editRoomTypeModal')
            .classList.add('show');
}

function confirmDeleteRoomType(id, name) {
    document.getElementById('deleteRoomTypeText')
            .textContent
        = 'Are you sure you want to delete room type: '
          + name + '?';
    document.getElementById('deleteRoomTypeBtn').href
        = '${pageContext.request.contextPath}/room'
          + '?action=deleteRoomType&roomTypeId=' + id;
    document.getElementById('deleteRoomTypeModal')
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