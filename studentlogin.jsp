<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hostel Hive | Student Login</title>

<style>
@import url('https://fonts.googleapis.com/css2?family=Pacifico&family=Poppins:wght@400;600&display=swap');

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(120deg, #4B0082, #2E0854);
    font-family: 'Poppins', sans-serif;
    color: white;
}

.login-card {
    background: rgba(255, 255, 255, 0.1);
    padding: 50px 70px;
    border-radius: 25px;
    text-align: center;
    width: 420px;
    box-shadow: 0 6px 15px rgba(0,0,0,0.3);
    backdrop-filter: blur(10px);
}

h1 {
    font-family: 'Pacifico', cursive;
    color: #FFD700;
    font-size: 3rem;
    margin-bottom: 35px;
}

.login-card input {
    width: 100%;
    padding: 14px;
    margin: 12px 0;
    border: none;
    border-radius: 10px;
    outline: none;
}

.login-card button {
    width: 100%;
    background: #FFD700;
    color: #4B0082;
    font-weight: bold;
    padding: 14px;
    border: none;
    border-radius: 12px;
    cursor: pointer;
}

.alert {
    margin-top: 12px;
    font-weight: bold;
    color: #ff4444;
}

.back-link {
    margin-top: 15px;
    cursor: pointer;
    color: #FFD700;
}

.footer {
    margin-top: 20px;
    font-size: 0.85rem;
    opacity: 0.8;
}
</style>
</head>

<body>

<div class="login-card">
<h1>Hostel Hive 🏠</h1>

<%
String message = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String username = request.getParameter("username").trim().toLowerCase();
    String password = request.getParameter("password").trim();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive",
            "root",
            ""
        );

        String sql = "SELECT id, username FROM students WHERE LOWER(username)=? AND password=?";
        ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);

        rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("student_id", rs.getInt("id"));
            session.setAttribute("username", rs.getString("username"));
            response.sendRedirect("student_dash.jsp");
        } else {
            message = "❌ Invalid username or password!";
        }

    } catch (Exception e) {
        message = "⚠️ Error: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
}
%>

<form method="post">
    <input type="text" name="username" placeholder="Enter Username" required>
    <input type="password" name="password" placeholder="Enter Password" required>
    <button type="submit">Login</button>

    <% if (!message.isEmpty()) { %>
        <div class="alert"><%= message %></div>
    <% } %>
</form>

<div class="back-link" onclick="goBack()">⬅ Back</div>
<div class="footer">© 2025 Hostel Hive | Smart Hostel Management System</div>
</div>

<script>
function goBack() {
    window.location.href = "user.html";
}
</script>

</body>
</html>
