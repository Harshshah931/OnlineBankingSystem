package com.bank.main;

import com.bank.model.User;
import com.bank.service.UserService;
import com.bank.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/WithdrawServlet")
public class WithdrawServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=session");
            return;
        }

        double amount;
        try {
            amount = Double.parseDouble(request.getParameter("amount"));
        } catch (NumberFormatException e) {
            response.sendRedirect("withdraw.jsp?error=invalid");
            return;
        }

        if (amount <= 0) {
            response.sendRedirect("withdraw.jsp?error=invalid");
            return;
        }

        // ── Verify PIN ────────────────────────────────────────────────────────
        String pinRaw    = request.getParameter("pin");
        String hashedPin = PasswordUtil.hashPassword(pinRaw);
        User user = (User) session.getAttribute("user");

        UserService service = new UserService();

        if (!service.verifyPin(user.getAccountNumber(), hashedPin)) {
            response.sendRedirect("withdraw.jsp?error=wrongpin");
            return;
        }

        boolean success = service.withdraw(user.getAccountNumber(), amount);

        if (success) {
            user.setBalance(user.getBalance() - amount);
            session.setAttribute("user", user);
            response.sendRedirect("dashboard.jsp?success=withdraw");
        } else {
            response.sendRedirect("withdraw.jsp?error=insufficient");
        }
    }
}
