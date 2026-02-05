package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class CheckoutPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if(cart == null || cart.isEmpty()){
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        List<Map<String,String>> cartDetails = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            for(String productId : cart.keySet()){
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id=?");
                ps.setInt(1, Integer.parseInt(productId));
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    Map<String,String> product = new HashMap<>();
                    product.put("id", String.valueOf(rs.getInt("id")));
                    product.put("name", rs.getString("name"));
                    product.put("description", rs.getString("description"));
                    product.put("price", String.valueOf(rs.getDouble("price")));
                    product.put("quantity", String.valueOf(cart.get(productId)));
                    cartDetails.add(product);
                }
            }
        } catch(Exception e){
            e.printStackTrace();
        }

        session.setAttribute("cartDetails", cartDetails);
        response.sendRedirect(request.getContextPath() + "/checkout.jsp");
    }
}
