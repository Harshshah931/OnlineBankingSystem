package com.bank.main;

import com.bank.model.User;
import com.bank.service.UserService;
import com.bank.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Session guard ─────────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=session");
            return;
        }

        User user = (User) session.getAttribute("user");

        String oldPassword  = PasswordUtil.hashPassword(request.getParameter("oldPassword"));
        String newPassword  = PasswordUtil.hashPassword(request.getParameter("newPassword"));
        String confirmPass  = PasswordUtil.hashPassword(request.getParameter("confirmPassword"));

        // ── Check new passwords match ─────────────────────────────────────────
        if (!newPassword.equals(confirmPass)) {
            response.sendRedirect("changepassword.jsp?error=mismatch");
            return;
        }

        // ── Don't allow same password ─────────────────────────────────────────
        if (oldPassword.equals(newPassword)) {
            response.sendRedirect("changepassword.jsp?error=same");
            return;
        }

        UserService service = new UserService();
        boolean success = service.changePassword(user.getAccountNumber(), oldPassword, newPassword);

        if (success) {
            // Update password in session too
            user.setPassword(newPassword);
            session.setAttribute("user", user);
            response.sendRedirect("changepassword.jsp?success=true");
        } else {
            response.sendRedirect("changepassword.jsp?error=wrongpassword");
        }
    }
}
