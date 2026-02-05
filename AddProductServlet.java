package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class AddProductServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String imageUrl = request.getParameter("image_url");

        double price = 0;
        int stock = 0;

        try {
            price = Double.parseDouble(priceStr);
        } catch (Exception e) {
            price = 0.0;
        }

        try {
            stock = Integer.parseInt(stockStr);
        } catch (Exception e) {
            stock = 0;
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO products (name, description, price, stock, image_url) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setInt(4, stock);
            ps.setString(5, imageUrl);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                out.println("<h3>✅ Product added successfully!</h3>");
                out.println("<form action='addproduct.jsp' style='display:inline;'><button type='submit'>Add Another Product</button></form>");
                out.println("&nbsp;");
                out.println("<form action='products' style='display:inline;'><button type='submit'>View Products</button></form>");
            } else {
                out.println("<h3>❌ Failed to add product.</h3>");
                out.println("<a href='addproduct.jsp'>Try Again</a>");
            }

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}
