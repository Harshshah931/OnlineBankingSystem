package com.bank.main;

import com.bank.model.User;
import com.bank.service.UserService;
import com.bank.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/DepositServlet")
public class DepositServlet extends HttpServlet {

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
            response.sendRedirect("deposit.jsp?error=invalid");
            return;
        }

        if (amount <= 0) {
            response.sendRedirect("deposit.jsp?error=invalid");
            return;
        }

        // ── Verify PIN ────────────────────────────────────────────────────────
        String pinRaw   = request.getParameter("pin");
        String hashedPin = PasswordUtil.hashPassword(pinRaw);
        User user = (User) session.getAttribute("user");

        UserService service = new UserService();

        if (!service.verifyPin(user.getAccountNumber(), hashedPin)) {
            response.sendRedirect("deposit.jsp?error=wrongpin");
            return;
        }

        boolean success = service.deposit(user.getAccountNumber(), amount);

        if (success) {
            user.setBalance(user.getBalance() + amount);
            session.setAttribute("user", user);
            response.sendRedirect("dashboard.jsp?success=deposit");
        } else {
            response.sendRedirect("deposit.jsp?error=failed");
        }
    }
}
