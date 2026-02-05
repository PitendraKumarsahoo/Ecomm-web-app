package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class MyOrdersServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail"); // set at login
        List<Map<String, Object>> orders = new ArrayList<>();

        if (userEmail != null) {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT * FROM orders WHERE user_email = ? ORDER BY created_at DESC";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, userEmail);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Map<String, Object> order = new HashMap<>();
                    order.put("id", rs.getInt("id"));
                    order.put("total_amount", rs.getDouble("total_amount"));
                    order.put("name", rs.getString("name"));
                    order.put("address", rs.getString("address"));
                    order.put("phone", rs.getString("phone"));
                    order.put("payment_method", rs.getString("payment_method"));
                    order.put("created_at", rs.getTimestamp("created_at"));

                    // fetch order items
                    List<Map<String, Object>> items = new ArrayList<>();
                    PreparedStatement psItems = conn.prepareStatement(
                        "SELECT oi.quantity, oi.price, p.name FROM order_items oi " +
                        "JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?");
                    psItems.setInt(1, rs.getInt("id"));
                    ResultSet rsItems = psItems.executeQuery();
                    while (rsItems.next()) {
                        Map<String, Object> item = new HashMap<>();
                        item.put("name", rsItems.getString("name"));
                        item.put("price", rsItems.getDouble("price"));
                        item.put("quantity", rsItems.getInt("quantity"));
                        items.add(item);
                    }
                    order.put("items", items);

                    orders.add(order);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("orders", orders);
        RequestDispatcher rd = request.getRequestDispatcher("myorders.jsp");
        rd.forward(request, response);
    }
}
