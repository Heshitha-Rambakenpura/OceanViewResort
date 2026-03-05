<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String savedIdType = (String) request.getAttribute("idType");
    if (savedIdType == null) savedIdType = "NIC";
%>
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
            display: flex; justify-content: space-between;
        }
        .navbar a { color: white; text-decoration: none; }
        .container {
            padding: 30px; max-width: 700px; margin: 0 auto;
        }
        h2 { color: #1F4E79; margin-bottom: 20px; }
        .form-card {
            background: white; padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group { margin-bottom: 20px; }
        label {
            display: block; margin-bottom: 6px;
            font-weight: bold; color: #333; font-size: 14px;
        }
        input, select, textarea {
            width: 100%; padding: 10px;
            border: 2px solid #ddd; border-radius: 6px;
            font-size: 14px;
        }
        input:focus, select:focus, textarea:focus {
            outline: none; border-color: #2E75B6;
        }
        input.invalid { border-color: #cc0000; }
        input.valid   { border-color: #006600; }

        /* ─── ID TYPE TOGGLE ─── */
        .id-toggle {
            display: flex; gap: 10px; margin-bottom: 10px;
        }
        .id-btn {
            flex: 1; padding: 10px;
            border: 2px solid #ddd; border-radius: 6px;
            cursor: pointer; text-align: center;
            background: white; font-size: 14px;
            font-weight: bold;
        }
        .id-btn.selected {
            background: #1F4E79; color: white;
            border-color: #1F4E79;
        }
        .hint {
            font-size: 12px; color: #888;
            margin-top: 5px;
        }
        .field-error {
            font-size: 12px; color: #cc0000;
            margin-top: 4px; display: none;
        }
        button[type="submit"] {
            background: #1F4E79; color: white;
            padding: 12px 30px; border: none;
            border-radius: 6px; font-size: 15px;
            cursor: pointer; width: 100%;
        }
        button[type="submit"]:hover { background: #2E75B6; }
        .error {
            background: #ffe0e0; color: #cc0000;
            padding: 12px; border-radius: 6px;
            margin-bottom: 20px; font-size: 14px;
        }
        .success {
            background: #e0ffe0; color: #006600;
            padding: 12px; border-radius: 6px;
            margin-bottom: 20px; font-size: 14px;
        }
        .back { margin-bottom: 20px; }
        .back a { color: #2E75B6; text-decoration: none; }
    </style>
</head>
<body>

<div class="navbar">
    <h1>🏨 Ocean View Resort</h1>
    <a href="${pageContext.request.contextPath}/logout">
        Logout
    </a>
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
              action="${pageContext.request.contextPath}/guest"
              id="guestForm"
              onsubmit="return validateForm()">

            <input type="hidden" name="idType"
                   id="idTypeInput"
                   value="<%= savedIdType %>" />

            <%-- ─── NAME ─── --%>
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="name" id="name"
                       placeholder="Enter full name"
                       oninput="validateName(this)"
                       required />
                <div class="field-error" id="nameError">
                    Name must contain letters only!
                </div>
                <div class="hint">
                    Letters and spaces only
                </div>
            </div>

            <%-- ─── ID TYPE TOGGLE ─── --%>
            <div class="form-group">
                <label>ID Type *</label>
                <div class="id-toggle">
                    <div class="id-btn <%= "NIC".equals(savedIdType) ? "selected" : "" %>"
                         id="nicBtn"
                         onclick="selectIdType('NIC')">
                        🪪 NIC
                    </div>
                    <div class="id-btn <%= "PASSPORT".equals(savedIdType) ? "selected" : "" %>"
                         id="passportBtn"
                         onclick="selectIdType('PASSPORT')">
                        📘 Passport
                    </div>
                </div>

                <%-- ─── NIC INPUT ─── --%>
                <div id="nicSection"
                     style="display: <%= "NIC".equals(savedIdType) ? "block" : "none" %>">
                    <input type="text" name="nic" id="nicInput"
                           placeholder="e.g. 123456789V or 200012345678"
                           oninput="validateNic(this)"
                           maxlength="12" />
                    <div class="field-error" id="nicError">
                        Use 9 digits + V/X or 12 digits only!
                    </div>
                    <div class="hint">
                        Old NIC: 9 digits + V or X
                        (e.g. 123456789V) |
                        New NIC: 12 digits
                        (e.g. 200012345678)
                    </div>
                </div>

                <%-- ─── PASSPORT INPUT ─── --%>
                <div id="passportSection"
                     style="display: <%= "PASSPORT".equals(savedIdType) ? "block" : "none" %>">
                    <input type="text" name="nic"
                           id="passportInput"
                           placeholder="e.g. N1234567"
                           oninput="validatePassport(this)"
                           maxlength="9" />
                    <div class="field-error"
                         id="passportError">
                        Use 1-2 letters + 6-7 digits only!
                    </div>
                    <div class="hint">
                        Format: 1-2 letters + 6-7 digits
                        (e.g. N1234567 or AB123456)
                    </div>
                </div>
            </div>

            <%-- ─── NATIONALITY ─── --%>
            <div class="form-group">
                <label>Nationality *</label>
                <input type="text" name="nationality"
                       id="nationality"
                       placeholder="e.g. Sri Lankan"
                       oninput="validateLettersOnly(
                           this, 'nationalityError')"
                       required />
                <div class="field-error"
                     id="nationalityError">
                    Nationality must contain letters only!
                </div>
            </div>

            <%-- ─── ADDRESS ─── --%>
            <div class="form-group">
                <label>Address *</label>
                <textarea name="address" rows="3"
                          placeholder="Enter address"
                          required></textarea>
            </div>

            <%-- ─── CONTACT ─── --%>
            <div class="form-group">
                <label>Contact Number *</label>
                <input type="text" name="contactNumber"
                       id="contactNumber"
                       placeholder="e.g. 0771234567"
                       oninput="validateContact(this)"
                       maxlength="10"
                       required />
                <div class="field-error"
                     id="contactError">
                    Contact must be 10 digits only!
                </div>
                <div class="hint">10 digits only</div>
            </div>

            <%-- ─── EMAIL ─── --%>
            <div class="form-group">
                <label>Email Address *</label>
                <input type="email" name="email"
                       id="email"
                       placeholder="e.g. john@email.com"
                       required />
            </div>

            <button type="submit">
                Register Guest
            </button>

        </form>
    </div>
</div>

<script>
var currentIdType = '<%= savedIdType %>';

// ─── SELECT ID TYPE ───
function selectIdType(type) {
    currentIdType = type;
    document.getElementById('idTypeInput').value = type;

    if (type === 'NIC') {
        document.getElementById('nicBtn')
                .classList.add('selected');
        document.getElementById('passportBtn')
                .classList.remove('selected');
        document.getElementById('nicSection')
                .style.display = 'block';
        document.getElementById('passportSection')
                .style.display = 'none';
        // ─── Enable NIC, disable passport ───
        document.getElementById('nicInput')
                .required = true;
        document.getElementById('passportInput')
                .required = false;
        document.getElementById('passportInput')
                .value = '';
    } else {
        document.getElementById('passportBtn')
                .classList.add('selected');
        document.getElementById('nicBtn')
                .classList.remove('selected');
        document.getElementById('passportSection')
                .style.display = 'block';
        document.getElementById('nicSection')
                .style.display = 'none';
        // ─── Enable passport, disable NIC ───
        document.getElementById('passportInput')
                .required = true;
        document.getElementById('nicInput')
                .required = false;
        document.getElementById('nicInput')
                .value = '';
    }
}

// ─── VALIDATE NAME ───
function validateName(input) {
    var val = input.value;
    // Remove any numbers or special chars as user types
    input.value = val.replace(/[^a-zA-Z ]/g, '');
    var error = document.getElementById('nameError');
    if (input.value.trim() === '') {
        input.classList.remove('valid', 'invalid');
        error.style.display = 'none';
    } else if (/^[a-zA-Z ]+$/.test(input.value)) {
        input.classList.add('valid');
        input.classList.remove('invalid');
        error.style.display = 'none';
    } else {
        input.classList.add('invalid');
        input.classList.remove('valid');
        error.style.display = 'block';
    }
}

// ─── VALIDATE NIC ───
function validateNic(input) {
    var val = input.value.toUpperCase();
    input.value = val;
    var error = document.getElementById('nicError');
    // Old NIC: 9 digits + V/X  OR  New NIC: 12 digits
    var oldNic = /^[0-9]{9}[VX]$/.test(val);
    var newNic = /^[0-9]{12}$/.test(val);
    if (val === '') {
        input.classList.remove('valid', 'invalid');
        error.style.display = 'none';
    } else if (oldNic || newNic) {
        input.classList.add('valid');
        input.classList.remove('invalid');
        error.style.display = 'none';
    } else {
        input.classList.add('invalid');
        input.classList.remove('valid');
        error.style.display = 'block';
    }
}

// ─── VALIDATE PASSPORT ───
function validatePassport(input) {
    var val = input.value.toUpperCase();
    input.value = val;
    var error = document.getElementById('passportError');
    // 1-2 letters + 6-7 digits
    var valid = /^[A-Z]{1,2}[0-9]{6,7}$/.test(val);
    if (val === '') {
        input.classList.remove('valid', 'invalid');
        error.style.display = 'none';
    } else if (valid) {
        input.classList.add('valid');
        input.classList.remove('invalid');
        error.style.display = 'none';
    } else {
        input.classList.add('invalid');
        input.classList.remove('valid');
        error.style.display = 'block';
    }
}

// ─── VALIDATE LETTERS ONLY ───
function validateLettersOnly(input, errorId) {
    // Remove numbers as user types
    input.value = input.value.replace(/[^a-zA-Z ]/g, '');
    var error = document.getElementById(errorId);
    if (input.value.trim() === '') {
        input.classList.remove('valid', 'invalid');
        error.style.display = 'none';
    } else if (/^[a-zA-Z ]+$/.test(input.value)) {
        input.classList.add('valid');
        input.classList.remove('invalid');
        error.style.display = 'none';
    } else {
        input.classList.add('invalid');
        input.classList.remove('valid');
        error.style.display = 'block';
    }
}

// ─── VALIDATE CONTACT ───
function validateContact(input) {
    // Remove non-digits as user types
    input.value = input.value.replace(/[^0-9]/g, '');
    var error = document.getElementById('contactError');
    if (input.value === '') {
        input.classList.remove('valid', 'invalid');
        error.style.display = 'none';
    } else if (/^[0-9]{10}$/.test(input.value)) {
        input.classList.add('valid');
        input.classList.remove('invalid');
        error.style.display = 'none';
    } else {
        input.classList.add('invalid');
        input.classList.remove('valid');
        error.style.display = 'block';
    }
}

// ─── VALIDATE FORM ON SUBMIT ───
function validateForm() {
    var name    = document.getElementById('name').value;
    var contact = document.getElementById(
                      'contactNumber').value;

    if (!name || !/^[a-zA-Z ]+$/.test(name)) {
        alert('Please enter a valid name '
              + '(letters only)!');
        return false;
    }

    if (currentIdType === 'NIC') {
        var nic = document.getElementById('nicInput').value;
        var oldNic = /^[0-9]{9}[VvXx]$/.test(nic);
        var newNic = /^[0-9]{12}$/.test(nic);
        if (!oldNic && !newNic) {
            alert('Please enter a valid NIC!\n'
                  + 'Old NIC: 9 digits + V or X\n'
                  + 'New NIC: 12 digits');
            return false;
        }
    } else {
        var passport = document.getElementById(
                           'passportInput').value;
        if (!/^[a-zA-Z]{1,2}[0-9]{6,7}$/.test(passport)) {
            alert('Please enter a valid Passport!\n'
                  + 'Format: 1-2 letters + 6-7 digits');
            return false;
        }
    }

    if (!/^[0-9]{10}$/.test(contact)) {
        alert('Contact number must be 10 digits!');
        return false;
    }

    return true;
}

// ─── INIT - Set correct required fields ───
window.onload = function() {
    selectIdType(currentIdType);
}
</script>

</body>
</html>