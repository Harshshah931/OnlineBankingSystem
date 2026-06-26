package com.bank.main;

import com.bank.model.User;
import com.bank.service.UserService;
import com.bank.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=session");
            return;
        }

        User sender = (User) session.getAttribute("user");
        String receiver = request.getParameter("receiver").trim();

        double amount;
        try {
            amount = Double.parseDouble(request.getParameter("amount"));
        } catch (NumberFormatException e) {
            response.sendRedirect("transfer.jsp?error=invalid");
            return;
        }

        if (amount <= 0) {
            response.sendRedirect("transfer.jsp?error=invalid");
            return;
        }

        if (sender.getAccountNumber().equals(receiver)) {
            response.sendRedirect("transfer.jsp?error=sameaccount");
            return;
        }

        // ── Verify PIN ────────────────────────────────────────────────────────
        String pinRaw    = request.getParameter("pin");
        String hashedPin = PasswordUtil.hashPassword(pinRaw);

        UserService service = new UserService();

        if (!service.verifyPin(sender.getAccountNumber(), hashedPin)) {
            response.sendRedirect("transfer.jsp?error=wrongpin");
            return;
        }

        boolean success = service.transfer(sender.getAccountNumber(), receiver, amount);

        if (success) {
            sender.setBalance(sender.getBalance() - amount);
            session.setAttribute("user", sender);
            response.sendRedirect("dashboard.jsp?success=transfer");
        } else {
            response.sendRedirect("transfer.jsp?error=failed");
        }
    }
}
