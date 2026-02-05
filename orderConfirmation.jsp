<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer orderId = (Integer) session.getAttribute("orderId");
    String customerName = (String) session.getAttribute("orderCustomer");

    if (orderId == null) {
        response.sendRedirect("products");
        return;
    }

    // Clear session order info after showing
    session.removeAttribute("orderId");
    session.removeAttribute("orderCustomer");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
</head>
<body>
    <h2>✅ Order Placed Successfully!</h2>
    <p>Thank you, <b><%= customerName %></b>.</p>
    <p>Your order ID is: <b>#<%= orderId %></b></p>
    <a href="products">Continue Shopping</a>
</body>
</html>
