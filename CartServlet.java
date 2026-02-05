package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class CartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        List<Map<String, String>> cartDetails = new ArrayList<>();

        if (cart != null && !cart.isEmpty()) {
            try (Connection conn = DBConnection.getConnection()) {
                for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                    String productId = entry.getKey();
                    int quantity = entry.getValue();

                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
                    ps.setInt(1, Integer.parseInt(productId));
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        Map<String, String> product = new HashMap<>();
                        product.put("id", String.valueOf(rs.getInt("id")));
                        product.put("name", rs.getString("name"));
                        product.put("description", rs.getString("description"));
                        product.put("price", String.valueOf(rs.getDouble("price")));
                        product.put("image_url", rs.getString("image_url"));
                        product.put("quantity", String.valueOf(quantity));
                        cartDetails.add(product);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("cartDetails", cartDetails);
        RequestDispatcher dispatcher = request.getRequestDispatcher("cart.jsp");
        dispatcher.forward(request, response);
    }
}
