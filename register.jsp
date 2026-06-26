<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register | NetBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #1a237e, #283593); min-height: 100vh; display: flex; flex-direction: column; }
        .card { border-radius: 16px; border: none; }
        .pin-hint { font-size: 12px; color: #888; }
        .main-wrap { flex: 1; display: flex; align-items: center; justify-content: center; padding: 40px 0; }
    </style>
</head>
<body>

<div class="main-wrap">
<div class="container">
<div class="row justify-content-center">
<div class="col-md-5 col-lg-4">
<div class="card shadow-lg p-4">

    <div class="text-center mb-4">
        <i class="bi bi-person-plus-fill text-primary" style="font-size:2.5rem;"></i>
        <h4 class="fw-bold mt-1">Create Account</h4>
    </div>

    <% if ("email".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-x-circle-fill me-1"></i> This email is already registered.</div>
    <% } else if ("pin".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-x-circle-fill me-1"></i> PIN must be exactly 4 digits.</div>
    <% } else if ("invalid".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-x-circle-fill me-1"></i> Please fill all fields correctly.</div>
    <% } else if ("server".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-x-circle-fill me-1"></i> Registration failed. Please try again.</div>
    <% } %>

    <form action="RegisterServlet" method="post">
        <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input type="text" name="name" class="form-control" placeholder="Harsh Shah" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Min. 6 characters" required minlength="6">
        </div>
        <div class="mb-3">
            <label class="form-label">4-Digit Transaction PIN</label>
            <input type="password" name="pin" class="form-control" placeholder="e.g. 1234"
                   required pattern="\d{4}" maxlength="4" minlength="4" inputmode="numeric">
            <div class="pin-hint mt-1"><i class="bi bi-shield-lock me-1"></i>You will need this PIN every time you deposit, withdraw or transfer money.</div>
        </div>
        <div class="mb-4">
            <label class="form-label">Opening Balance (₹)</label>
            <input type="number" name="balance" class="form-control" placeholder="e.g. 5000" min="0" required>
            <div class="form-text text-muted"><i class="bi bi-info-circle me-1"></i>Account number will be auto-generated.</div>
        </div>
        <button type="submit" class="btn btn-primary w-100 fw-semibold">Register</button>
    </form>

    <p class="text-center text-muted mt-3 mb-0 small">
        Already have an account? <a href="login.jsp">Login</a>
    </p>
</div>
</div>
</div>
</div>
</div>

<%@ include file="footer-dark.html" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
