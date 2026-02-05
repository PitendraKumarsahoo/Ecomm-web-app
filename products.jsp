<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Arrays"%>

<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<String[]> products = (List<String[]>) request.getAttribute("products");

    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products</title>
    <style>
        :root {
            --primary: #2575fc;
            --primary-dark: #1a5edc;
            --success: #28a745;
            --danger: #dc3545;
            --light-bg: #f9f9f9;
            --card-bg: #fff;
            --radius: 8px;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--light-bg);
            margin: 0;
            padding: 0;
        }

        /* Header */
        .header {
            background: var(--primary);
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }
        .header a {
            color: #fff;
            margin-left: 15px;
            text-decoration: none;
            font-weight: bold;
            background: rgba(255, 255, 255, 0.2);
            padding: 6px 12px;
            border-radius: var(--radius);
            transition: background 0.3s;
        }
        .header a:hover {
            background: rgba(255, 255, 255, 0.4);
        }
        .header .welcome {
            font-weight: bold;
        }
        .role-badge {
            padding: 4px 10px;
            border-radius: var(--radius);
            font-size: 13px;
            font-weight: bold;
        }
        .role-admin {
            background: #dc3545;
            color: #fff;
        }
        .role-user {
            background: #28a745;
            color: #fff;
        }
        h2 {
            text-align: center;
            margin: 20px 0;
            color: #333;
        }

        /* Success message */
        .message {
            background: var(--success);
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 10px;
            margin: 10px auto;
            width: 60%;
            border-radius: var(--radius);
            opacity: 1;
            transition: opacity 1s ease-out;
        }

        /* Product Table */
        table {
            border-collapse: collapse;
            width: 85%;
            margin: 20px auto;
            background: var(--card-bg);
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        th {
            background: var(--primary);
            color: white;
            padding: 12px;
        }
        td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        tr:hover td {
            background: #f4f8ff;
        }

        img {
            width: 90px;
            height: 90px;
            border-radius: var(--radius);
            object-fit: cover;
        }

        /* Form and buttons */
        input[type="number"] {
            width: 60px;
            padding: 6px;
            border-radius: var(--radius);
            border: 1px solid #ccc;
            text-align: center;
        }
        input[type="submit"] {
            background: var(--primary);
            border: none;
            color: white;
            padding: 8px 14px;
            border-radius: var(--radius);
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
        }
        input[type="submit"]:hover {
            background: var(--primary-dark);
        }

        /* Links */
        a {
            text-decoration: none;
            font-weight: bold;
            color: var(--primary);
            transition: color 0.3s;
        }
        a:hover {
            color: var(--primary-dark);
        }

        .footer-actions {
            text-align: center;
            margin: 20px;
        }
        .footer-actions a {
            display: inline-block;
            margin: 0 10px;
            padding: 10px 16px;
            background: var(--primary);
            color: white;
            border-radius: var(--radius);
        }
        .footer-actions a:hover {
            background: var(--primary-dark);
        }		
    </style>
</head>
<body>

    <!-- Header -->
  
    
<div class="header">
        <span class="welcome">Welcome, <%= (user != null) ? user : "Guest" %></span>
        <% if(role != null){ %>
            <% if("admin".equalsIgnoreCase(role)){ %>
                <span class="role-badge role-admin"> Admin</span>
            <% } else { %>
                <span class="role-badge role-user"> User</span>
            <% } %>
        <% } %>
        <a href="<%= request.getContextPath() %>/login.jsp">Logout</a>
        <a href="myOrders.jsp" class="btn">My Orders</a>
    </div>

    <h2>Product Catalog</h2>

    <% if (message != null) { %>
        <div id="successMessage" class="message"><%= message %></div>
        <script>
            setTimeout(() => {
                let msg = document.getElementById('successMessage');
                if (msg) msg.style.opacity = '0';
            }, 4000);
        </script>
    <% } %>

    <table>
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Price (₹)</th>
            <th>Image</th>
            <th>Add to Cart</th>
        </tr>

        <% if (products != null && !products.isEmpty()) {
               for (String[] product : products) { %>
        <tr>
            <td><%= product[1] %></td>
            <td><%= product[2] %></td>
            <td><%= product[3] %></td>
            <td>
                <% if (product[4] != null && !product[4].isEmpty()) { %>
                    <img src="<%= product[4] %>" alt="<%= product[1] %>"/>
                <% } else { %>
                    <span style="color:#aaa;">N/A</span>
                <% } %>
            </td>
            <td>
                <form method="post" action="<%=request.getContextPath()%>/cart/add">
                    <input type="hidden" name="productId" value="<%= product[0] %>"/>
                    <input type="number" name="quantity" value="1" min="1"/>
                    <input type="submit" value="Add to Cart"/>
                </form>
            </td>
        </tr>
        <%   } 
           } else { %>
        <tr>
            <td colspan="5" style="color:#999;">No products available.</td>
        </tr>
        <% } %>
    </table>

    <div class="footer-actions">
        <a href="<%=request.getContextPath()%>/cart">🛒 View Cart</a>
        <% if ("admin".equals(role)) { %>
            <a href="addProduct.jsp">➕ Add New Product</a>
        <% } %>
    </div>

</body>
</html>
