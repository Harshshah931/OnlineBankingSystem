<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String error   = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Change Password | NetBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f0f4f8; }
        .card { border-radius: 16px; }
    </style>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center min-vh-100">
    <div class="card shadow p-4" style="width: 420px;">

        <div class="text-center mb-4">
            <i class="bi bi-key-fill text-primary" style="font-size:2.5rem;"></i>
            <h4 class="mt-2 fw-bold">Change Password</h4>
        </div>

        <!-- Alerts -->
        <% if ("true".equals(success)) { %>
        <div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i>Password changed successfully!</div>
        <% } %>
        <% if ("mismatch".equals(error)) { %>
        <div class="alert alert-danger"><i class="bi bi-x-circle-fill me-2"></i>New passwords do not match.</div>
        <% } else if ("wrongpassword".equals(error)) { %>
        <div class="alert alert-danger"><i class="bi bi-x-circle-fill me-2"></i>Current password is incorrect.</div>
        <% } else if ("same".equals(error)) { %>
        <div class="alert alert-warning"><i class="bi bi-exclamation-circle-fill me-2"></i>New password cannot be same as old password.</div>
        <% } %>

        <form action="ChangePasswordServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Current Password</label>
                <input type="password" name="oldPassword" class="form-control" placeholder="Enter current password" required>
            </div>
            <div class="mb-3">
                <label class="form-label">New Password</label>
                <input type="password" name="newPassword" class="form-control" placeholder="Enter new password" required minlength="6">
            </div>
            <div class="mb-4">
                <label class="form-label">Confirm New Password</label>
                <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm new password" required minlength="6">
            </div>
            <button type="submit" class="btn btn-primary w-100">Update Password</button>
        </form>

        <div class="text-center mt-3">
            <a href="dashboard.jsp" class="text-decoration-none text-muted">
                <i class="bi bi-arrow-left me-1"></i>Back to Dashboard
            </a>
        </div>
    </div>
</div>
</body>
</html>
