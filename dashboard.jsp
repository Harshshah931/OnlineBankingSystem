<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    com.bank.model.User user = (com.bank.model.User) session.getAttribute("user");
    String success = request.getParameter("success");

    // ── Admin check — only YOUR email sees the Admin Panel button ─────────────
    // 👇 Change this to YOUR actual registered email address
    boolean isAdmin = "harsh@gmail.com".equals(user.getEmail());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | NetBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .navbar { background: #1a237e; }
        .balance-card { background: linear-gradient(135deg, #1a237e, #283593); color: white; border-radius: 16px; }
        .action-card { border: none; border-radius: 12px; transition: transform .2s, box-shadow .2s; cursor: pointer; }
        .action-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,.12); }
        .action-icon { font-size: 2rem; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark px-4 py-2">
    <span class="navbar-brand fw-bold"><i class="bi bi-bank2 me-2"></i>NetBank</span>
    <div class="d-flex align-items-center gap-3">
        <span class="text-white-50">Welcome, <%= user.getName() %></span>
        <a href="LogoutServlet" class="btn btn-outline-light btn-sm"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>
</nav>

<div class="container py-4">

    <% if (success != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>
        <% if ("deposit".equals(success))  out.print("Deposit successful!"); %>
        <% if ("withdraw".equals(success)) out.print("Withdrawal successful!"); %>
        <% if ("transfer".equals(success)) out.print("Transfer successful!"); %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if ("unauthorized".equals(request.getParameter("error"))) { %>
    <div class="alert alert-warning alert-dismissible fade show">
        <i class="bi bi-shield-exclamation me-2"></i> You are not authorized to access the Admin Panel.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Balance Card -->
    <div class="balance-card p-4 mb-4 shadow">
        <div class="row align-items-center">
            <div class="col">
                <p class="mb-1 opacity-75">Account Number</p>
                <h5 class="fw-bold"><%= user.getAccountNumber() %></h5>
            </div>
            <div class="col text-end">
                <p class="mb-1 opacity-75">Available Balance</p>
                <h2 class="fw-bold">₹ <%= String.format("%,.2f", user.getBalance()) %></h2>
            </div>
        </div>
    </div>

    <!-- Action Cards -->
    <h5 class="text-muted mb-3">Quick Actions</h5>
    <div class="row g-3">

        <div class="col-6 col-md-3">
            <a href="deposit.jsp" class="text-decoration-none">
                <div class="action-card card p-3 text-center shadow-sm">
                    <div class="action-icon text-success mb-2"><i class="bi bi-arrow-down-circle-fill"></i></div>
                    <p class="fw-semibold mb-0">Deposit</p>
                </div>
            </a>
        </div>

        <div class="col-6 col-md-3">
            <a href="withdraw.jsp" class="text-decoration-none">
                <div class="action-card card p-3 text-center shadow-sm">
                    <div class="action-icon text-danger mb-2"><i class="bi bi-arrow-up-circle-fill"></i></div>
                    <p class="fw-semibold mb-0">Withdraw</p>
                </div>
            </a>
        </div>

        <div class="col-6 col-md-3">
            <a href="transfer.jsp" class="text-decoration-none">
                <div class="action-card card p-3 text-center shadow-sm">
                    <div class="action-icon text-primary mb-2"><i class="bi bi-arrow-left-right"></i></div>
                    <p class="fw-semibold mb-0">Transfer</p>
                </div>
            </a>
        </div>

        <div class="col-6 col-md-3">
            <a href="TransactionHistoryServlet" class="text-decoration-none">
                <div class="action-card card p-3 text-center shadow-sm">
                    <div class="action-icon text-warning mb-2"><i class="bi bi-clock-history"></i></div>
                    <p class="fw-semibold mb-0">History</p>
                </div>
            </a>
        </div>

        <div class="col-6 col-md-3">
            <a href="changepassword.jsp" class="text-decoration-none">
                <div class="action-card card p-3 text-center shadow-sm">
                    <div class="action-icon text-secondary mb-2"><i class="bi bi-key-fill"></i></div>
                    <p class="fw-semibold mb-0">Change Password</p>
                </div>
            </a>
        </div>

        <!-- Admin Panel button — ONLY shown to admin user ───────────────────── -->
        <% if (isAdmin) { %>
        <div class="col-6 col-md-3">
            <a href="AdminServlet" class="text-decoration-none">
                <div class="action-card card p-3 text-center shadow-sm">
                    <div class="action-icon text-dark mb-2"><i class="bi bi-shield-lock-fill"></i></div>
                    <p class="fw-semibold mb-0">Admin Panel</p>
                </div>
            </a>
        </div>
        <% } %>

    </div>
</div>

<%@ include file="footer.html" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
