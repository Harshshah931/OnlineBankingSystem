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
    <title>Transfer | NetBank</title>
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
        <h5 class="fw-bold mb-0"><i class="bi bi-arrow-left-right text-primary me-2"></i>Transfer Money</h5>
    </div>

    <div class="bg-light rounded p-3 mb-3 text-center">
        <p class="mb-0 text-muted small">Your Balance</p>
        <h4 class="fw-bold text-primary mb-0">₹ <%= String.format("%,.2f", user.getBalance()) %></h4>
    </div>

    <!-- Alerts -->
    <% if ("invalid".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-x-circle-fill me-1"></i> Enter a valid amount greater than 0.</div>
    <% } else if ("sameaccount".equals(error)) { %>
    <div class="alert alert-warning py-2"><i class="bi bi-exclamation-triangle-fill me-1"></i> Cannot transfer to your own account.</div>
    <% } else if ("wrongpin".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-shield-x me-1"></i> Incorrect PIN. Please try again.</div>
    <% } else if ("failed".equals(error)) { %>
    <div class="alert alert-danger py-2"><i class="bi bi-x-circle-fill me-1"></i> Transfer failed. Check receiver account or your balance.</div>
    <% } %>

    <form action="TransferServlet" method="post">
        <div class="mb-3">
            <label class="form-label">Receiver Account Number</label>
            <input type="text" name="receiver" class="form-control" placeholder="e.g. ACC17264182" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Amount (₹)</label>
            <input type="number" name="amount" class="form-control form-control-lg"
                   placeholder="0.00" min="1" step="0.01"
                   max="<%= user.getBalance() %>" required>
            <div class="form-text text-muted">Max: ₹ <%= String.format("%,.2f", user.getBalance()) %></div>
        </div>
        <div class="mb-4 pin-dots">
            <label class="form-label"><i class="bi bi-shield-lock-fill text-primary me-1"></i>Transaction PIN</label>
            <input type="password" name="pin" class="form-control form-control-lg"
                   placeholder="• • • •" maxlength="4" minlength="4"
                   pattern="\d{4}" inputmode="numeric" required>
            <div class="form-text text-muted">Enter your 4-digit PIN to confirm this transaction.</div>
        </div>
        <button type="submit" class="btn btn-primary w-100 fw-semibold">Confirm Transfer</button>
    </form>
</div>

<%@ include file="footer.html" %> %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
