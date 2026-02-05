package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        String userEmail = (String) session.getAttribute("user"); // assuming email is stored in session

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        if (cart == null || cart.isEmpty()) {
            session.setAttribute("message", "❌ Your cart is empty.");
            response.sendRedirect("cart.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // transaction start

            double total = 0;

            // Calculate total
            for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                String productId = entry.getKey();
                int qty = entry.getValue();

                PreparedStatement ps = conn.prepareStatement("SELECT price FROM products WHERE id = ?");
                ps.setInt(1, Integer.parseInt(productId));
                ResultSet prs = ps.executeQuery();
                if (prs.next()) {
                    total += prs.getDouble("price") * qty;
                }
                prs.close();
                ps.close();
            }

            // Insert into orders
            String orderSql = "INSERT INTO orders (user_email, total_amount, name, address, phone) VALUES (?, ?, ?, ?, ?)";
            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setString(1, userEmail);
            orderStmt.setDouble(2, total);
            orderStmt.setString(3, name);
            orderStmt.setString(4, address);
            orderStmt.setString(5, phone);
            orderStmt.executeUpdate();

            rs = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // Insert order items
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            itemStmt = conn.prepareStatement(itemSql);

            for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                int productId = Integer.parseInt(entry.getKey());
                int qty = entry.getValue();

                PreparedStatement ps = conn.prepareStatement("SELECT price FROM products WHERE id = ?");
                ps.setInt(1, productId);
                ResultSet prs = ps.executeQuery();
                double price = 0;
                if (prs.next()) {
                    price = prs.getDouble("price");
                }
                prs.close();
                ps.close();

                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, productId);
                itemStmt.setInt(3, qty);
                itemStmt.setDouble(4, price);
                itemStmt.addBatch();
            }
            itemStmt.executeBatch();

            conn.commit(); // commit transaction

            // Clear cart
            session.removeAttribute("cart");
            session.setAttribute("message", "✅ Order placed successfully!");
            response.sendRedirect("products");

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            session.setAttribute("message", "❌ Failed to place order.");
            response.sendRedirect("cart.jsp");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (orderStmt != null) orderStmt.close(); } catch (Exception e) {}
            try { if (itemStmt != null) itemStmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
