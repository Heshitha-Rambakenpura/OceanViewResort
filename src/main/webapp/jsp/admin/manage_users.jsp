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

        /* ─── LAYOUT ─── */
        .layout {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 25px; align-items: start;
        }

        /* ─── FORM CARD ─── */
        .form-card {
            background: white; padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-top: 4px solid #cc0000;
            margin-bottom: 20px;
        }
        .form-card h3 {
            color: #1F4E79; margin-bottom: 20px; font-size: 16px;
        }
        .form-group { margin-bottom: 15px; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; font-size: 13px; color: #333;
        }
        input, select {
            width: 100%; padding: 9px 10px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 13px;
        }
        input:focus, select:focus {
            outline: none; border-color: #2E75B6;
        }
        .hint {
            font-size: 11px; color: #888; margin-top: 3px;
        }
        .btn {
            padding: 9px 18px; border: none;
            border-radius: 6px; cursor: pointer;
            font-size: 13px; font-weight: bold;
        }
        .btn-primary {
            background: #1F4E79; color: white; width: 100%;
            padding: 11px;
        }
        .btn-primary:hover { background: #2E75B6; }
        .btn-danger  { background: #cc0000; color: white; }
        .btn-warning { background: #cc6600; color: white; }
        .btn-info    { background: #2E75B6; color: white; }
        .btn:hover   { opacity: 0.85; }

        /* ─── MESSAGES ─── */
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

        /* ─── TABLE ─── */
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
        .role-badge {
            padding: 3px 9px; border-radius: 20px;
            font-size: 11px; font-weight: bold;
        }
        .ADMIN        { background: #ffe0e0; color: #cc0000; }
        .RECEPTIONIST { background: #e0f0ff; color: #0066cc; }
        .FINANCE      { background: #e0ffe0; color: #006600; }
        .actions { display: flex; gap: 5px; }

        /* ─── MODAL ─── */
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
            border-radius: 10px; width: 400px;
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

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <div class="success">${success}</div>
    <% } %>

    <div class="layout">

        <%-- ─── LEFT - CREATE USER ─── --%>
        <div>
            <div class="form-card">
                <h3>➕ Create New Account</h3>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin">
                    <input type="hidden"
                           name="formAction"
                           value="createUser" />
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
                        <p class="hint">Minimum 6 characters</p>
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
                    <button type="submit" class="btn btn-primary">
                        Create Account
                    </button>
                </form>
            </div>
        </div>

        <%-- ─── RIGHT - USER LIST ─── --%>
        <div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Actions</th>
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
                                    <td>
                                        <div class="actions">
                                            <button class="btn btn-info"
                                                onclick="openEditModal(
                                                    '${u.userId}',
                                                    '${u.name}',
                                                    '${u.username}',
                                                    '${u.role}')">
                                                ✏️ Edit
                                            </button>
                                            <button class="btn btn-warning"
                                                onclick="openPasswordModal(
                                                    '${u.userId}',
                                                    '${u.name}')">
                                                🔑 Password
                                            </button>
                                            <button class="btn btn-danger"
                                                onclick="confirmDelete(
                                                    '${u.userId}',
                                                    '${u.name}')">
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

<%-- ─── EDIT USER MODAL ─── --%>
<div class="modal" id="editModal">
    <div class="modal-box">
        <h3>✏️ Edit User</h3>
        <form method="post"
              action="${pageContext.request.contextPath}/admin">
            <input type="hidden" name="formAction"
                   value="updateUser" />
            <input type="hidden" name="targetUserId"
                   id="editUserId" />
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="name"
                       id="editName" required />
            </div>
            <div class="form-group">
                <label>Username *</label>
                <input type="text" name="username"
                       id="editUsername" required />
            </div>
            <div class="form-group">
                <label>Role *</label>
                <select name="role" id="editRole" required>
                    <option value="RECEPTIONIST">Receptionist</option>
                    <option value="ADMIN">Admin</option>
                    <option value="FINANCE">Finance Department</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel"
                        onclick="closeModal('editModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-info">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<%-- ─── CHANGE PASSWORD MODAL ─── --%>
<div class="modal" id="passwordModal">
    <div class="modal-box">
        <h3>🔑 Change Password</h3>
        <p id="passwordUserName"
           style="color:#888; margin-bottom:15px;
                  font-size:14px;"></p>
        <form method="post"
              action="${pageContext.request.contextPath}/admin">
            <input type="hidden" name="formAction"
                   value="changePassword" />
            <input type="hidden" name="targetUserId"
                   id="passwordUserId" />
            <div class="form-group">
                <label>New Password *</label>
                <input type="password" name="newPassword"
                       placeholder="Enter new password"
                       required />
                <p class="hint">Minimum 6 characters</p>
            </div>
            <div class="form-group">
                <label>Confirm New Password *</label>
                <input type="password"
                       name="confirmNewPassword"
                       placeholder="Re-enter new password"
                       required />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel"
                        onclick="closeModal('passwordModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-warning">
                    Change Password
                </button>
            </div>
        </form>
    </div>
</div>

<%-- ─── DELETE CONFIRM MODAL ─── --%>
<div class="modal" id="deleteModal">
    <div class="modal-box">
        <h3>🗑️ Delete User</h3>
        <p id="deleteUserName"
           style="color:#555; margin-bottom:20px;
                  font-size:14px;"></p>
        <div class="modal-footer">
            <button type="button" class="btn-cancel"
                    onclick="closeModal('deleteModal')">
                Cancel
            </button>
            <a id="deleteConfirmBtn"
               href="#" class="btn btn-danger">
                Delete User
            </a>
        </div>
    </div>
</div>

<script>
function openEditModal(id, name, username, role) {
    document.getElementById('editUserId').value    = id;
    document.getElementById('editName').value      = name;
    document.getElementById('editUsername').value  = username;
    document.getElementById('editRole').value      = role;
    document.getElementById('editModal')
            .classList.add('show');
}

function openPasswordModal(id, name) {
    document.getElementById('passwordUserId').value  = id;
    document.getElementById('passwordUserName')
            .textContent = 'Changing password for: ' + name;
    document.getElementById('passwordModal')
            .classList.add('show');
}

function confirmDelete(id, name) {
    document.getElementById('deleteUserName')
            .textContent =
        'Are you sure you want to delete user: ' + name + '?';
    document.getElementById('deleteConfirmBtn').href =
        '${pageContext.request.contextPath}/admin'
        + '?action=deleteUser&userId=' + id;
    document.getElementById('deleteModal')
            .classList.add('show');
}

function closeModal(modalId) {
    document.getElementById(modalId)
            .classList.remove('show');
}

// Close modal when clicking outside
window.onclick = function(e) {
    document.querySelectorAll('.modal').forEach(modal => {
        if (e.target === modal) {
            modal.classList.remove('show');
        }
    });
}
</script>

</body>
</html>