package com.bank.main;
 
import com.bank.model.User;
import com.bank.service.UserService;
import com.bank.util.PasswordUtil;
 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
 
import java.io.IOException;
 
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
 
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        String email    = request.getParameter("email").trim();
        String password = PasswordUtil.hashPassword(request.getParameter("password"));
 
        UserService service = new UserService();
        User user = service.login(email, password);
 
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 min timeout
            response.sendRedirect("dashboard.jsp");
        } else {
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}
 