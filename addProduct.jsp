<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String admin = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (admin == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Product</title>
    <style>
        :root {
            --accent1: #B5CFB7;
            --accent2: #BC9F8B;
            --radius: 10px;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073); /* Blue gradient */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .card {
            background: #fff;
            padding: 35px 30px;
            border-radius: var(--radius);
            width: 420px;
            box-shadow: 0 8px 22px rgba(0,0,0,0.2);
            border: none;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: var(--accent2);
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 18px;
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: 600;
            margin-bottom: 6px;
            color: #333;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: var(--radius);
            font-size: 14px;
            transition: border 0.3s ease, box-shadow 0.3s ease;
        }

        textarea {
            resize: vertical;
            min-height: 90px;
        }

        input:focus,
        textarea:focus {
            border-color: var(--accent1);
            box-shadow: 0 0 5px rgba(181, 207, 183, 0.6);
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            background: var(--accent2);
            border: none;
            border-radius: var(--radius);
            color: white;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background: #a97f6d;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 18px;
            color: var(--accent2);
            font-weight: 500;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>Add a New Product</h2>
        <form action="addProduct" method="post">
            <div class="form-group">
                <label>Name</label>
                <input type="text" name="name" required>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" required></textarea>
            </div>

            <div class="form-group">
                <label>Price (₹)</label>
                <input type="number" step="0.01" name="price" required>
            </div>

            <div class="form-group">
                <label>Stock</label>
                <input type="number" name="stock" required>
            </div>

            <div class="form-group">
                <label>Image URL</label>
                <input type="text" name="image_url" placeholder="e.g. images/laptop.jpg" required>
            </div>

            <button type="submit">➕ Add Product</button>
        </form>

        <a href="products.jsp" class="back-link">⬅ Back to Products</a>
    </div>
</body>
</html>
