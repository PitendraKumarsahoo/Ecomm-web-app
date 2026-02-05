package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class UpdateCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");

        if (cart != null) {
            // Loop through all products in the cart and update quantity
            for (String productId : cart.keySet()) {
                String qtyParam = request.getParameter("quantity_" + productId);
                if (qtyParam != null) {
                    int qty = Integer.parseInt(qtyParam);
                    if (qty > 0) {
                        cart.put(productId, qty);
                    } else {
                        cart.remove(productId); // remove if quantity <= 0
                    }
                }
            }
            session.setAttribute("cart", cart);
            session.setAttribute("message", "Cart updated successfully!");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
