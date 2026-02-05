<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin: auto; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        h2, h3 { text-align: center; }
        form { width: 50%; margin: auto; }
        input, textarea { width: 100%; margin-bottom: 10px; padding: 5px; }
        button { padding: 10px 20px; }
    </style>
</head>
<body>

<%
    List<Map<String, String>> cartDetails = (List<Map<String, String>>) session.getAttribute("cartDetails");
    if (cartDetails == null || cartDetails.isEmpty()) {
        response.sendRedirect("products");
        return;
    }

    double total = 0;
    for (Map<String,String> item : cartDetails) {
        total += Double.parseDouble(item.get("price")) * Integer.parseInt(item.get("quantity"));
    }
%>

<h2>Checkout</h2>

<table>
    <tr>
        <th>Product</th><th>Price</th><th>Quantity</th><th>Subtotal</th>
    </tr>
    <% for (Map<String,String> item : cartDetails) { %>
    <tr>
        <td><%= item.get("name") %></td>
        <td>₹<%= item.get("price") %></td>
        <td><%= item.get("quantity") %></td>
        <td>₹<%= Double.parseDouble(item.get("price")) * Integer.parseInt(item.get("quantity")) %></td>
    </tr>
    <% } %>
    <tr>
        <td colspan="3"><b>Total</b></td>
        <td>₹<%= total %></td>
    </tr>
</table>

<h3>Delivery Info</h3>
<form action="checkout" method="post">
    Name: <input type="text" name="name" required><br>
    Address: <textarea name="address" required></textarea><br>
    Phone: <input type="text" name="phone" required><br>
    <button type="submit">Place Order</button>
</form>


</body>
</html>
