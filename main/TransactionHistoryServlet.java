package com.bank.main;

import com.bank.model.Transaction;
import com.bank.model.User;
import com.bank.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/TransactionHistoryServlet")
public class TransactionHistoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Session guard ─────────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=session");
            return;
        }

        User user = (User) session.getAttribute("user");

        // ── Read optional filters ─────────────────────────────────────────────
        String type = request.getParameter("type");  // DEPOSIT | WITHDRAWAL | TRANSFER | null
        String from = request.getParameter("from");  // yyyy-MM-dd or null
        String to   = request.getParameter("to");    // yyyy-MM-dd or null

        UserService service = new UserService();
        List<Transaction> transactions;

        boolean hasFilter = (type != null && !type.isEmpty())
                         || (from != null && !from.isEmpty())
                         || (to   != null && !to.isEmpty());

        if (hasFilter) {
            transactions = service.getFilteredTransactions(user.getAccountNumber(), type, from, to);
        } else {
            transactions = service.getTransactionHistory(user.getAccountNumber());
        }

        // ── Pass to JSP ───────────────────────────────────────────────────────
        request.setAttribute("transactions", transactions);
        request.setAttribute("filterType", type);
        request.setAttribute("filterFrom", from);
        request.setAttribute("filterTo",   to);

        request.getRequestDispatcher("history.jsp").forward(request, response);
    }
}
