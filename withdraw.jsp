<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.bank.model.User" %>
<%
    User user  = (User) session.getAttribute("user");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Withdraw | NetBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .card { border-radius: 16px; border: none; }
        .pin-dots input { letter-spacing: 6px; font-size: 1.3rem; text-align: center; }
    </style>
</head>
<body class="d-flex flex-column align-items-center justify-content-center min-vh-100">
<div class="card shadow p-4" style="width:420px;">

    <div class="d-flex align-items-center mb-4 gap-2">
        <a href="dashboard.jsp" class="text-decoration-none text-muted"><i class="bi bi-arrow-left fs-5"></i></a>
        <h5 class="fw-bold mb-0"><i class="bi bi-arrow-up-circle-fill text-danger me-2"></i>Withdraw Money</h5>
    </div>

    <div class="bg-light rounded p-3 mb-3 text-center">
        <p class="mb-0 text-muted small">Current Balance</p>
        <h4 class="fw-bold text-danger mb-0">₹ <%= String.format("%,.2f", user.getBalance()) %></h4>
    </div>

    <!-- Alerts -->
    <% if ("invalid".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-x-circle-fill me-1"></i> Enter a valid amount greater than 0.</div>
    <% } else if ("wrongpin".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-shield-x me-1"></i> Incorrect PIN. Please try again.</div>
    <% } else if ("insufficient".equals(error)) { %>
    <div class="alert alert-warning py-2"><i class="bi bi-exclamation-triangle-fill me-1"></i> Insufficient balance.</div>
    <% } %>

    <form action="WithdrawServlet" method="post">
        <div class="mb-3">
            <label class="form-label">Amount to Withdraw (₹)</label>
            <input type="number" name="amount" class="form-control form-control-lg"
                   placeholder="0.00" min="1" step="0.01"
                   max="<%= user.getBalance() %>" required autofocus>
            <div class="form-text text-muted">Max: ₹ <%= String.format("%,.2f", user.getBalance()) %></div>
        </div>
        <div class="mb-4 pin-dots">
            <label class="form-label"><i class="bi bi-shield-lock-fill text-primary me-1"></i>Transaction PIN</label>
            <input type="password" name="pin" class="form-control form-control-lg"
                   placeholder="• • • •" maxlength="4" minlength="4"
                   pattern="\d{4}" inputmode="numeric" required>
            <div class="form-text text-muted">Enter your 4-digit PIN to confirm this transaction.</div>
        </div>
        <button type="submit" class="btn btn-danger w-100 fw-semibold">Confirm Withdrawal</button>
    </form>
</div>

<%@ include file="footer.html" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
