package com.bank.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

// Protects all these pages — if session is missing, user is sent back to login
@WebFilter({
    "/dashboard.jsp",
    "/deposit.jsp",
    "/withdraw.jsp",
    "/transfer.jsp",
    "/history.jsp",
    "/changepassword.jsp",
    "/admin.jsp"
})
public class SessionFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            // Session expired or not logged in → go to login
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=session");
        } else {
            chain.doFilter(req, res);
        }
    }
}
