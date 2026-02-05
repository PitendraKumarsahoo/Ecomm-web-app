package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class ProductServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String[]> products = new ArrayList<>();
        
        

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM products";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                String[] product = new String[5];
                product[0] = String.valueOf(rs.getInt("id"));
                product[1] = rs.getString("name");
                product[2] = rs.getString("description");
                product[3] = rs.getString("price");

                products.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("products", products);
        RequestDispatcher dispatcher = request.getRequestDispatcher("products.jsp");
        dispatcher.forward(request, response);
    }
}
