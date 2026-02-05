<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>User Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #6a11cb, #2575fc);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
            width: 350px;
            text-align: center;
            position: relative;      /* needed for pseudo-element */
            overflow: hidden;
            /* create a stacking context so z-index behaves predictably */
            transform: translateZ(0);
        }

        /* glow layer (behind content) */
        .login-container::before {
            content: "";
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            pointer-events: none;
            z-index: 0; /* behind the card content */
            /* position uses CSS vars set by JS (defaults to center) */
            background:
                radial-gradient(
                    circle at var(--gx, 50%) var(--gy, 50%),
                    rgba(37,117,252,0.45) 0%,
                    rgba(37,117,252,0.25) 10%,
                    rgba(255,0,255,0.12) 25%,
                    transparent 40%
                );
            filter: blur(18px);
            opacity: var(--g-opacity, 0);
            transition: opacity 220ms linear;
            mix-blend-mode: screen; /* nicer neon blending */
        }

        /* make sure content is above the glow */
        .login-container > * {
            position: relative;
            z-index: 1;
        }

        .login-container h2 {
            margin-bottom: 20px;
            color: #333;
        }
        .login-container input[type="email"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: 0.25s;
        }
        .login-container input[type="email"]:focus,
        .login-container input[type="password"]:focus {
            border-color: #2575fc;
            box-shadow: 0 0 8px rgba(37,117,252,0.35);
        }
        .login-container input[type="submit"] {
            width: 100%;
            padding: 12px;
            background: #2575fc;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .login-container input[type="submit"]:hover {
            background: #1a5edc;
        }
        .login-container p {
            margin-top: 15px;
            font-size: 14px;
        }
        .login-container a {
            color: #2575fc;
            text-decoration: none;
            font-weight: bold;
        }
        .login-container a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container" id="card">
        <h2>Login</h2>
        <form action="login" method="post">
            <input type="email" name="email" placeholder="Enter your email" required>
            <input type="password" name="password" placeholder="Enter your password" required>
            <input type="submit" value="Login">
        </form>
        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>

    <script>
        (function() {
            const card = document.getElementById('card');
            if (!card) return;

            let rafId = null;
            let latest = { xPct: 50, yPct: 50 };

            function updateVars() {
                card.style.setProperty('--gx', latest.xPct + '%');
                card.style.setProperty('--gy', latest.yPct + '%');
                card.style.setProperty('--g-opacity', '1');
                rafId = null;
            }

            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                // convert to percent (more consistent across sizes)
                latest.xPct = Math.round((x / rect.width) * 100);
                latest.yPct = Math.round((y / rect.height) * 100);

                // throttle to animation frame for smoothness
                if (!rafId) rafId = requestAnimationFrame(updateVars);
            });

            card.addEventListener('mouseleave', () => {
                // fade out the glow
                card.style.setProperty('--g-opacity', '0');
            });

            // optional: show faint glow when entering
            card.addEventListener('mouseenter', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                latest.xPct = Math.round((x / rect.width) * 100);
                latest.yPct = Math.round((y / rect.height) * 100);
                if (!rafId) rafId = requestAnimationFrame(updateVars);
            });
        })();
    </script>
</body>
</html>
