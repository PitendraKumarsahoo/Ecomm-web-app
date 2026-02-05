<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <meta charset="UTF-8">
    <style>
        :root {
            --primary: #ff4da6;
            --primary-dark: #e60073;
            --card-bg: #111;
            --text-light: #eee;
            --spacing: 16px;
            --radius: 10px;
        }

        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #0f0f0f, #1a1a1a);
            color: var(--text-light);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .card {
            background: var(--card-bg);
            padding: calc(var(--spacing) * 2);
            border-radius: var(--radius);
            width: 400px;
            display: flex;
            flex-direction: column;
            gap: var(--spacing);
            position: relative;
            overflow: hidden;
        }

        /* radial glow */
        .card::before {
            content: "";
            position: absolute;
            inset: 0;
            pointer-events: none;
            background: radial-gradient(
                circle at var(--gx, 50%) var(--gy, 50%),
                rgba(255, 77, 166, 0.5),
                rgba(255, 77, 166, 0.2) 25%,
                transparent 50%
            );
            filter: blur(30px);
            opacity: var(--g-opacity, 0);
            transition: opacity 0.2s;
        }

        .card > * {
            position: relative;
            z-index: 1;
        }

        .card h2 {
            text-align: center;
            margin: 0;
        }
        .form {
    display: flex;
    flex-direction: column;
    gap: var(--spacing);
}
        

        .form-control {
            width: 100%;
            padding: 12px;
            border-radius: var(--radius);
            border: 1px solid #333;
            background: #222;
            color: var(--text-light);
            font-size: 14px;
            transition: border 0.3s, box-shadow 0.3s;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 8px rgba(255, 77, 166, 0.6);
            outline: none;
        }

        .btn {
            padding: 12px;
            border: none;
            border-radius: var(--radius);
            background: var(--primary);
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn:hover {
            background: var(--primary-dark);
        }

        .text-small {
            font-size: 14px;
            text-align: center;
        }

        .text-small a {
            color: var(--primary);
            text-decoration: none;
            font-weight: bold;
        }

        .text-small a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="card" id="register-card">
        <h2>Register</h2>
        <form action="register" method="post" class="form">
            <input type="text" name="name" class="form-control" placeholder="Name" required>
            <input type="email" name="email" class="form-control" placeholder="Email" required>
            <input type="password" name="password" class="form-control" placeholder="Password" required>
            <select name="role" class="form-control" required>
                <option value="user" selected>User</option>
                <option value="admin">Admin</option>
            </select>
            <button type="submit" class="btn">Register</button>
        </form>
        <p class="text-small">Already have an account? <a href="login.jsp">Login</a></p>
    </div>

    <script>
        (function() {
            const card = document.getElementById('register-card');
            let rafId = null;
            let latest = { xPct: 50, yPct: 50 };

            function updateGlow() {
                card.style.setProperty('--gx', latest.xPct + '%');
                card.style.setProperty('--gy', latest.yPct + '%');
                card.style.setProperty('--g-opacity', '1');
                rafId = null;
            }

            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                latest.xPct = Math.round(((e.clientX - rect.left) / rect.width) * 100);
                latest.yPct = Math.round(((e.clientY - rect.top) / rect.height) * 100);
                if (!rafId) rafId = requestAnimationFrame(updateGlow);
            });

            card.addEventListener('mouseleave', () => {
                card.style.setProperty('--g-opacity', '0');
            });
        })();
    </script>
</body>
</html>
