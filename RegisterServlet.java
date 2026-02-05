package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Get form values
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        if (role == null || (!role.equals("user") && !role.equals("admin"))) {
            role = "user"; 
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                out.println("<h2>✅ Registration Successful!</h2>");
                out.println("<p>Registered as: <b>" + role + "</b></p>");
                out.println("<a href='login.jsp'>Click here to Login</a>");
            } else {
                out.println("<h2>❌ Registration Failed!</h2>");
            }

        } catch (Exception e) {
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        }
    }
}
