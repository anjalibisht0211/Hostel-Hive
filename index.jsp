<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hostel Hive | Hostel Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(120deg, #4e54c8, #8f94fb);
            overflow: hidden;
            color: #fff;
        }

        .container {
            text-align: center;
            animation: fadeIn 2s ease-in-out;
        }

        .logo {
            font-size: 5rem;
            font-weight: 800;
            letter-spacing: 3px;
            margin-bottom: 25px;
            animation: slideIn 2s ease forwards;
        }

        .subtitle {
            font-size: 2rem;
            margin-bottom: 40px;
            border-right: 3px solid white;
            white-space: nowrap;
            overflow: hidden;
            width: 0;
            animation: typing 4s steps(40, end) forwards, blink 0.8s infinite;
        }

        .btn {
            padding: 15px 40px;
            font-size: 1.3rem;
            color: #4e54c8;
            background: #fff;
            border: none;
            border-radius: 40px;
            cursor: pointer;
            transition: 0.3s;
            font-weight: bold;
        }

        .btn:hover {
            background: #ffd369;
            color: #000;
            transform: scale(1.1);
        }

        @keyframes typing {
            from { width: 0; }
            to { width: 100%; }
        }

        @keyframes blink {
            50% { border-color: transparent; }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
</head>

<body>

<%-- Optional: redirect if already logged in --%>
<%--
if(session.getAttribute("studentid") != null){
    response.sendRedirect("student.jsp");
}
--%>

<div class="container">
    <div class="logo">🏠 Hostel Hive</div>
    <div class="subtitle">Smart Hostel Management System</div>

    <a href="user.html">
        <button class="btn">Get Started</button>
    </a>
</div>

</body>
</html>
