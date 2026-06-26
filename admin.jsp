<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bank.model.User" %>
<%@ page import="com.bank.model.Transaction" %>
<%
    List<User>        allUsers     = (List<User>)        request.getAttribute("allUsers");
    List<Transaction> recentTxns   = (List<Transaction>) request.getAttribute("recentTxns");
    double            totalBalance = (double)             request.getAttribute("totalBalance");
    int               totalUsers   = (int)                request.getAttribute("totalUsers");
    int               totalTxns    = (int)                request.getAttribute("totalTxns");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel | NetBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .stat-card { border-radius: 14px; border: none; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark px-4 py-2" style="background:#1a237e;">
    <span class="navbar-brand fw-bold"><i class="bi bi-shield-lock-fill me-2"></i>Admin Panel</span>
    <a href="dashboard.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Dashboard</a>
</nav>

<div class="container py-4">

    <!-- Stats Row -->
    <div class="row g-3 mb-4">

        <div class="col-md-4">
            <div class="card stat-card shadow-sm p-3 text-center">
                <div class="text-primary" style="font-size:2rem;"><i class="bi bi-people-fill"></i></div>
                <h3 class="fw-bold mt-1"><%= totalUsers %></h3>
                <p class="text-muted mb-0">Total Users</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card stat-card shadow-sm p-3 text-center">
                <div class="text-success" style="font-size:2rem;"><i class="bi bi-currency-rupee"></i></div>
                <h3 class="fw-bold mt-1">₹ <%= String.format("%,.2f", totalBalance) %></h3>
                <p class="text-muted mb-0">Total Balance Held</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card stat-card shadow-sm p-3 text-center">
                <div class="text-warning" style="font-size:2rem;"><i class="bi bi-arrow-left-right"></i></div>
                <h3 class="fw-bold mt-1"><%= totalTxns %></h3>
                <p class="text-muted mb-0">Total Transactions</p>
            </div>
        </div>

    </div>

    <!-- All Users Table -->
    <div class="card shadow-sm mb-4">
        <div class="card-header fw-semibold bg-white">
            <i class="bi bi-person-lines-fill me-2 text-primary"></i>All Registered Users
        </div>
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Account No.</th>
                        <th>Balance (₹)</th>
                    </tr>
                </thead>
                <tbody>
                <% if (allUsers != null) { for (User u : allUsers) { %>
                    <tr>
                        <td><%= u.getId() %></td>
                        <td><%= u.getName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><code><%= u.getAccountNumber() %></code></td>
                        <td class="fw-semibold">₹ <%= String.format("%,.2f", u.getBalance()) %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Recent Transactions Table -->
    <div class="card shadow-sm">
        <div class="card-header fw-semibold bg-white">
            <i class="bi bi-clock-history me-2 text-warning"></i>Recent Transactions (Last 50)
        </div>
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Type</th>
                        <th>Amount (₹)</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <% if (recentTxns != null) { for (Transaction t : recentTxns) { %>
                    <tr>
                        <td><%= t.getTransactionId() %></td>
                        <td><span class="badge bg-secondary"><%= t.getType() %></span></td>
                        <td>₹ <%= String.format("%,.2f", t.getAmount()) %></td>
                        <td><%= t.getSenderAccount()   != null ? t.getSenderAccount()   : "—" %></td>
                        <td><%= t.getReceiverAccount() != null ? t.getReceiverAccount() : "—" %></td>
                        <td><%= t.getDate() %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
