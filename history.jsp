<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bank.model.Transaction" %>
<%@ page import="com.bank.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    String filterType = (String) request.getAttribute("filterType");
    String filterFrom = (String) request.getAttribute("filterFrom");
    String filterTo   = (String) request.getAttribute("filterTo");
    if (filterType == null) filterType = "";
    if (filterFrom == null) filterFrom = "";
    if (filterTo   == null) filterTo   = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transaction History | NetBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .badge-DEPOSIT    { background:#d4edda; color:#155724; }
        .badge-WITHDRAWAL { background:#f8d7da; color:#721c24; }
        .badge-TRANSFER   { background:#cce5ff; color:#004085; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark px-4 py-2" style="background:#1a237e;">
    <span class="navbar-brand fw-bold"><i class="bi bi-bank2 me-2"></i>NetBank</span>
    <a href="dashboard.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Dashboard</a>
</nav>

<div class="container py-4">
    <h4 class="mb-4 fw-bold"><i class="bi bi-clock-history me-2"></i>Transaction History</h4>

    <!-- Filter Form -->
    <div class="card shadow-sm p-3 mb-4">
        <form action="TransactionHistoryServlet" method="get" class="row g-2 align-items-end">
            <div class="col-md-3">
                <label class="form-label mb-1">Type</label>
                <select name="type" class="form-select form-select-sm">
                    <option value="">All Types</option>
                    <option value="DEPOSIT"    <%= "DEPOSIT".equals(filterType)    ? "selected" : "" %>>Deposit</option>
                    <option value="WITHDRAWAL" <%= "WITHDRAWAL".equals(filterType) ? "selected" : "" %>>Withdrawal</option>
                    <option value="TRANSFER"   <%= "TRANSFER".equals(filterType)   ? "selected" : "" %>>Transfer</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label mb-1">From Date</label>
                <input type="date" name="from" class="form-control form-control-sm" value="<%= filterFrom %>">
            </div>
            <div class="col-md-3">
                <label class="form-label mb-1">To Date</label>
                <input type="date" name="to" class="form-control form-control-sm" value="<%= filterTo %>">
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary btn-sm flex-fill"><i class="bi bi-funnel"></i> Filter</button>
                <a href="TransactionHistoryServlet" class="btn btn-outline-secondary btn-sm flex-fill"><i class="bi bi-x"></i> Reset</a>
            </div>
        </form>
    </div>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                    <tr><th>#</th><th>Type</th><th>Amount (₹)</th><th>From</th><th>To</th><th>Date</th></tr>
                </thead>
                <tbody>
                <% if (transactions == null || transactions.isEmpty()) { %>
                    <tr><td colspan="6" class="text-center text-muted py-4">No transactions found.</td></tr>
                <% } else { int sr = 1; for (Transaction t : transactions) { %>
                    <tr>
                        <td><%= sr++ %></td>
                        <td><span class="badge rounded-pill badge-<%= t.getType() %> px-3 py-2"><%= t.getType() %></span></td>
                        <td class="fw-semibold">₹ <%= String.format("%,.2f", t.getAmount()) %></td>
                        <td><%= t.getSenderAccount()   != null ? t.getSenderAccount()   : "—" %></td>
                        <td><%= t.getReceiverAccount() != null ? t.getReceiverAccount() : "—" %></td>
                        <td><%= t.getDate() %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </div>
    <% if (transactions != null) { %><p class="text-muted mt-2 small">Showing <%= transactions.size() %> transaction(s)</p><% } %>
</div>

<%@ include file="footer.html" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
