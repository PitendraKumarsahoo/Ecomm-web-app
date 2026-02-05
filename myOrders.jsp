<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    String userEmail = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f7fa; margin: 0; padding: 20px; }
        h2 { text-align: center; color: #333; }
        table { width: 90%; margin: 20px auto; border-collapse: collapse; background: white; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: center; }
        th { background: #007BFF; color: white; }
        tr:nth-child(even) { background: #f9f9f9; }
        .btn { display: inline-block; margin: 15px auto; padding: 10px 20px; background: #007BFF; color: white; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>

<h2>My Orders</h2>

<a href="products" class="btn">⬅ Back to Products</a>

<table>
    <tr>
        <th>Order ID</th>
        <th>Total Amount (₹)</th>
        <th>Name</th>
        <th>Address</th>
        <th>Phone</th>
        <th>Created At</th>
    </tr>

    <%
        try {
            conn = com.giet.DBConnection.getConnection();

            String sql;
            if ("admin".equals(role)) {
                // Admin sees all orders
                sql = "SELECT * FROM orders ORDER BY created_at DESC";
                ps = conn.prepareStatement(sql);
            } else {
                // Normal user sees only their orders
                sql = "SELECT * FROM orders WHERE user_email = ? ORDER BY created_at DESC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, userEmail);
            }

            rs = ps.executeQuery();

            boolean hasOrders = false;
            while (rs.next()) {
                hasOrders = true;
    %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td>₹<%= rs.getDouble("total_amount") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("address") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                </tr>
    <%
            }

            if (!hasOrders) {
    %>
                <tr>
                    <td colspan="6">No orders found.</td>
                </tr>
    <%
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>
</table>

</body>
</html>
