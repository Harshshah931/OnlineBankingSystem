package com.bank.main;

import com.bank.model.Transaction;
import com.bank.model.User;
import com.bank.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    // ── Change this to YOUR actual registered email ────────────────────────────
    private static final String ADMIN_EMAIL = "harsh@gmail.com";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Session guard ─────────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=session");
            return;
        }

        User user = (User) session.getAttribute("user");

        // ── Admin guard — block anyone who is not the admin ───────────────────
        if (!ADMIN_EMAIL.equals(user.getEmail())) {
            response.sendRedirect("dashboard.jsp?error=unauthorized");
            return;
        }

        // ── Fetch all data ────────────────────────────────────────────────────
        UserService service = new UserService();
        List<User>        allUsers     = service.getAllUsers();
        List<Transaction> recentTxns   = service.getAllTransactions();
        double            totalBalance = service.getTotalBalance();
        int               totalTxns    = service.getTotalTransactionCount();

        request.setAttribute("allUsers",     allUsers);
        request.setAttribute("recentTxns",   recentTxns);
        request.setAttribute("totalBalance", totalBalance);
        request.setAttribute("totalUsers",   allUsers.size());
        request.setAttribute("totalTxns",    totalTxns);

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
