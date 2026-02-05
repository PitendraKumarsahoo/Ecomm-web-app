package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class PlaceOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Map<String, String>> cartDetails = (List<Map<String, String>>) session.getAttribute("cartDetails");
        String userEmail = (String) session.getAttribute("userEmail"); // set this at login
        if (cartDetails == null || cartDetails.isEmpty()) {
            response.sendRedirect("products");
            return;
        }

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String paymentMethod = request.getParameter("payment_method");

        double total = 0;
        for (Map<String, String> item : cartDetails) {
            total += Double.parseDouble(item.get("price")) * Integer.parseInt(item.get("quantity"));
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Insert into orders
            String orderSql = "INSERT INTO orders (user_email, total_amount, name, address, phone, payment_method) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, userEmail);
            ps.setDouble(2, total);
            ps.setString(3, name);
            ps.setString(4, address);
            ps.setString(5, phone);
            ps.setString(6, paymentMethod);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // Insert order_items
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement psItem = conn.prepareStatement(itemSql);

            for (Map<String, String> item : cartDetails) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, Integer.parseInt(item.get("id")));
                psItem.setInt(3, Integer.parseInt(item.get("quantity")));
                psItem.setDouble(4, Double.parseDouble(item.get("price")));
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit();

            // Clear cart
            session.removeAttribute("cartDetails");
            session.removeAttribute("cart");

            session.setAttribute("message", "✅ Order placed successfully!");
            response.sendRedirect("myorders");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Failed to place order.");
            RequestDispatcher rd = request.getRequestDispatcher("checkout.jsp");
            rd.forward(request, response);
        }
    }
}
