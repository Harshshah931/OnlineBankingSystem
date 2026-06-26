<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String error   = request.getParameter("error");
    String success = request.getParameter("success");
    String account = request.getParameter("account");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | NetBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #1a237e, #283593); min-height: 100vh; display: flex; flex-direction: column; }
        .card { border-radius: 16px; border: none; }
        .main-wrap { flex: 1; display: flex; align-items: center; justify-content: center; }
    </style>
</head>
<body>

<div class="main-wrap">
<div class="container">
<div class="row justify-content-center">
<div class="col-md-5 col-lg-4">
<div class="card shadow-lg p-4">

    <div class="text-center mb-4">
        <i class="bi bi-bank2 text-primary" style="font-size:2.5rem;"></i>
        <h4 class="fw-bold mt-1">NetBank Login</h4>
    </div>

    <% if ("registered".equals(success)) { %>
    <div class="alert alert-success py-2">
        <i class="bi bi-check-circle-fill me-1"></i> Registered successfully!
        <% if (account != null) { %> Your account: <strong><%= account %></strong><% } %>
    </div>
    <% } %>
    <% if ("invalid".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-x-circle-fill me-1"></i> Invalid email or password.</div>
    <% } else if ("session".equals(error)) { %>
    <div class="alert alert-warning py-2"><i class="bi bi-exclamation-circle-fill me-1"></i> Session expired. Please login again.</div>
    <% } %>

    <form action="LoginServlet" method="post">
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
        </div>
        <div class="mb-4">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn btn-primary w-100 fw-semibold">Login</button>
    </form>

    <p class="text-center text-muted mt-3 mb-0 small">
        Don't have an account? <a href="register.jsp">Register</a>
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
