


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page session="true" %>
<%
    // Check if student is logged in
    if(session.getAttribute("student_id") == null) {
        response.sendRedirect("studentlogin.jsp"); // Redirect if not logged in
        return;
    }

    String username = (String) session.getAttribute("username");

    // Handle logout request
    String logout = request.getParameter("logout");
    if("true".equals(logout)) {
        session.invalidate();
        response.sendRedirect("user.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>🏠 Hostel Hive | Student Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
    font-family: 'Poppins', sans-serif;
    background: linear-gradient(120deg, #4e54c8, #8f94fb);
    color: white;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
}
header {
    width: 100%;
    background: rgba(255, 255, 255, 0.15);
    padding: 20px 0;
    text-align: center;
    font-size: 2rem;
    font-weight: 700;
    color: #ffd369;
    text-shadow: 0 0 10px rgba(0,0,0,0.3);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}
.dashboard {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 40px;
    margin-top: 80px;
}
.card {
    background: rgba(255, 255, 255, 0.15);
    border-radius: 20px;
    width: 250px;
    height: 200px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    box-shadow: 0 8px 20px rgba(0,0,0,0.3);
    transition: transform 0.3s, background 0.3s;
    text-align: center;
}
.card:hover {
    transform: translateY(-10px);
    background: rgba(255, 255, 255, 0.25);
}
.emoji { font-size: 3rem; margin-bottom: 15px; }
.card-title { font-size: 1.3rem; font-weight: 600; }
.logout-btn {
    margin-top: 60px;
    background: #ffd369;
    color: #333;
    border: none;
    padding: 12px 35px;
    border-radius: 25px;
    cursor: pointer;
    font-weight: bold;
    font-size: 1rem;
    transition: 0.3s;
}
.logout-btn:hover {
    background: #fff;
    color: #4e54c8;
    transform: scale(1.05);
}
footer { margin-top: auto; padding: 20px; color: #ddd; font-size: 0.9rem; }
</style>
</head>
<body>
<header>🏠 Hostel Hive - Welcome, <%= username %>!</header>

<div class="dashboard">
    <!-- Book Room Card -->
    <div class="card" onclick="window.location.href='hostel.jsp'">
        <div class="emoji">🛏️</div>
        <div class="card-title">Book Room</div>
    </div>

    <!-- Complaint Card -->
    <div class="card" onclick="window.location.href='student-complaint.jsp'">
        <div class="emoji">🧾</div>
        <div class="card-title">Complaint</div>
    </div>
</div>

<form method="get">
    <button type="submit" name="logout" value="true" class="logout-btn">Logout</button>
</form>

<footer>© 2025 Hostel Hive | Smart Hostel Management System</footer>
</body>
</html>