package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.*;

public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productId = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        int quantity = 1;
        try { 
            quantity = Integer.parseInt(quantityStr); 
        } catch (Exception e) { 
            quantity = 1; 
        }

        HttpSession session = request.getSession();

        // ✅ Store as Map<String,Integer>
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        cart.put(productId, cart.getOrDefault(productId, 0) + quantity);

        session.setAttribute("cart", cart);
        session.setAttribute("message", "✅ Product added to cart successfully!");

        // redirect to cart page
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
