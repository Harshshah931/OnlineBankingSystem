package com.bank.main;

import com.bank.model.User;
import com.bank.service.UserService;
import com.bank.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name     = request.getParameter("name").trim();
        String email    = request.getParameter("email").trim();
        String password = request.getParameter("password");
        String pinRaw   = request.getParameter("pin");
        double balance;

        try {
            balance = Double.parseDouble(request.getParameter("balance"));
        } catch (NumberFormatException e) {
            response.sendRedirect("register.jsp?error=invalid");
            return;
        }

        // ── Validate PIN: must be exactly 4 digits ────────────────────────────
        if (pinRaw == null || !pinRaw.matches("\\d{4}")) {
            response.sendRedirect("register.jsp?error=pin");
            return;
        }

        if (name.isEmpty() || email.isEmpty() || password.isEmpty() || balance < 0) {
            response.sendRedirect("register.jsp?error=invalid");
            return;
        }

        UserService service = new UserService();

        if (service.emailExists(email)) {
            response.sendRedirect("register.jsp?error=email");
            return;
        }

        // Auto-generate account number
        String accountNumber = "ACC" + String.valueOf(System.currentTimeMillis()).substring(5);

        // Hash both password and PIN using SHA-256
        String hashedPassword = PasswordUtil.hashPassword(password);
        String hashedPin      = PasswordUtil.hashPassword(pinRaw);

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(hashedPassword);
        user.setAccountNumber(accountNumber);
        user.setBalance(balance);
        user.setPin(hashedPin);

        boolean success = service.register(user);

        if (success) {
            response.sendRedirect("login.jsp?success=registered&account=" + accountNumber);
        } else {
            response.sendRedirect("register.jsp?error=server");
        }
    }
}
