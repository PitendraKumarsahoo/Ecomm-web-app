<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.giet.DBConnection" %>
<%
    Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
    String message = (String) session.getAttribute("message");
    if(message != null){
        session.removeAttribute("message"); // remove after showing once
    }

    List<String[]> cartProducts = new ArrayList<>();
    double total = 0;

    if(cart != null && !cart.isEmpty()){
        try (Connection conn = DBConnection.getConnection()) {
            for(String productId : cart.keySet()){
                String sql = "SELECT * FROM products WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(productId));
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    String[] product = new String[5];
                    product[0] = String.valueOf(rs.getInt("id"));
                    product[1] = rs.getString("name");
                    product[2] = rs.getString("description");
                    product[3] = String.valueOf(rs.getDouble("price"));
                    product[4] = String.valueOf(cart.get(productId)); // quantity
                    cartProducts.add(product);
                    total += rs.getDouble("price") * cart.get(productId);
                }
            }
        } catch(Exception e){ e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f6f8fa;
            margin: 0;
            padding: 30px;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .message {
            background: #eafbea;
            color: #2f6627;
            border: 1px solid #c6e9c6;
            padding: 12px 18px;
            border-radius: 6px;
            text-align: center;
            margin: 15px auto;
            max-width: 600px;
        }

        .cart-container {
            max-width: 900px;
            margin: auto;
            background: #fff;
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }

        th, td {
            border-bottom: 1px solid #e0e0e0;
            padding: 12px;
            text-align: center;
        }

        th {
            background: #fafafa;
            font-weight: 600;
            color: #444;
        }

        tr:last-child td {
            border-bottom: none;
        }

        input[type="number"] {
            width: 60px;
            padding: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .total-row td {
            font-weight: bold;
            font-size: 16px;
            border-top: 2px solid #ccc;
        }

        .actions {
            text-align: center;
            margin-top: 15px;
        }

        input[type="submit"], button {
            background: #0077cc;
            color: #fff;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            margin: 5px;
            transition: background 0.3s ease;
        }

        input[type="submit"]:hover,
        button:hover {
            background: #005fa3;
        }

        .checkout-form {
            margin-top: 25px;
            padding: 20px;
            border-top: 1px solid #eee;
        }

        .checkout-form input[type="text"],
        .checkout-form textarea {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .checkout-form textarea {
            resize: vertical;
            min-height: 80px;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #0077cc;
            font-weight: 600;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        window.onload = function() {
            const msg = document.getElementById("msg");
            if(msg){
                setTimeout(() => { msg.style.display = 'none'; }, 5000);
            }
        }
    </script>
</head>
<body>
    <h2>🛒 Your Shopping Cart</h2>

    <% if(message != null){ %>
        <div class="message" id="msg"><%= message %></div>
    <% } %>

    <div class="cart-container">
        <form method="post" action="<%=request.getContextPath()%>/cart/update">
            <table>
                <tr>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price (₹)</th>
                    <th>Quantity</th>
                    <th>Subtotal (₹)</th>
                </tr>
                <% if(cartProducts.isEmpty()){ %>
                    <tr>
                        <td colspan="5">Your cart is empty.</td>
                    </tr>
                <% } else { 
                    for(String[] p : cartProducts){ 
                        double price = Double.parseDouble(p[3]);
                        int qty = Integer.parseInt(p[4]);
                %>
                    <tr>
                        <td><%= p[1] %></td>
                        <td style="max-width:250px;"><%= p[2] %></td>
                        <td><%= p[3] %></td>
                        <td>
                            <input type="number" name="quantity_<%= p[0] %>" value="<%= qty %>" min="0"/>
                        </td>
                        <td><%= price * qty %></td>
                    </tr>
                <% } } %>
                <% if(!cartProducts.isEmpty()){ %>
                    <tr class="total-row">
                        <td colspan="4" style="text-align:right;">Total:</td>
                        <td>₹ <%= total %></td>
                    </tr>
                <% } %>
            </table>

            <% if(!cartProducts.isEmpty()){ %>
                <div class="actions">
                    <input type="submit" value="Update Cart"/>
                </div>
            </form>

            <form method="post" action="<%=request.getContextPath()%>/checkout" class="checkout-form">
                <h3>Checkout Details</h3>
                <input type="text" name="name" placeholder="Full Name" required />
                <textarea name="address" placeholder="Delivery Address" required></textarea>
                <input type="text" name="phone" placeholder="Phone Number" required />
                <button type="submit">✅ Place Order</button>
            </form>
            <% } %>
        </div>

        <div style="text-align:center;">
            <a href="<%=request.getContextPath()%>/products" class="back-link">⬅ Continue Shopping</a>
        </div>
</body>
</html>
