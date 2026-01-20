<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    // 1️⃣ Login check
    if(session.getAttribute("student_id") == null){
        response.sendRedirect("studentlogin.jsp");
        return;
    }

    int studentId = (Integer) session.getAttribute("student_id");
    String hostel = (String) session.getAttribute("selected_hostel");

    String room = request.getParameter("room");
    String bed  = request.getParameter("bed");

    String message = "";
    boolean success = false;

    if(hostel == null){
        message = "❌ Hostel not selected.";
    }
    else if(room == null || room.isEmpty() || bed == null || bed.isEmpty()){
        message = "⚠️ Please select a room and a bed.";
    }
    else{
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/hostelhive?zeroDateTimeBehavior=CONVERT_TO_NULL",
                "root","");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO bookings(student_id, hostel_name, room_number, bed) VALUES (?,?,?,?)");

            ps.setInt(1, studentId);
            ps.setString(2, hostel);
            ps.setInt(3, Integer.parseInt(room));
            ps.setString(4, bed);

            ps.executeUpdate();
            con.close();

            success = true;
            message = "✅ Booking Confirmed Successfully!";
        }
        catch(SQLIntegrityConstraintViolationException e){
            message = "❌ This bed is already booked!";
        }
        catch(Exception e){
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Hostel Hive | Booking Status</title>

<style>
@import url('https://fonts.googleapis.com/css2?family=Pacifico&family=Poppins:wght@400;600&display=swap');

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(120deg,#4B0082,#2E0854);
    font-family:'Poppins',sans-serif;
    color:white;
}

.container{
    background:rgba(255,255,255,0.12);
    padding:40px 50px;
    border-radius:20px;
    text-align:center;
    width:450px;
    backdrop-filter:blur(10px);
    box-shadow:0 8px 20px rgba(0,0,0,0.4);
}

h1{
    font-family:'Pacifico',cursive;
    color:#FFD700;
    font-size:2.5rem;
    margin-bottom:20px;
}

.details{
    margin:20px 0;
    font-size:1.1rem;
    line-height:1.8;
}

.success{
    color:#00ff7f;
    font-weight:bold;
}

.error{
    color:#ff6b6b;
    font-weight:bold;
}

button{
    margin-top:25px;
    padding:12px 22px;
    font-size:1rem;
    background:#FFD700;
    color:#4B0082;
    border:none;
    border-radius:10px;
    cursor:pointer;
    transition:0.3s;
}

button:hover{
    background:#ffe75f;
    transform:translateY(-3px);
}

.footer{
    margin-top:25px;
    font-size:0.9rem;
    color:#ddd;
}
</style>
</head>

<body>

<div class="container">

    <h1>🏠 Hostel Hive</h1>

    <% if(success){ %>
        <div class="success"><%= message %></div>

        <div class="details">
            <p><b>Hostel:</b> <%= hostel %></p>
            <p><b>Room:</b> <%= room %></p>
            <p><b>Bed:</b> <%= bed %></p>
        </div>

        <button onclick="location.href='student_dash.jsp'">
            Go to Dashboard
        </button>

    <% } else { %>
        <div class="error"><%= message %></div>

        <button onclick="history.back()">
            Go Back
        </button>
    <% } %>

    <div class="footer">
        © 2025 Hostel Hive | Smart Hostel Management System
    </div>

</div>

</body>
</html>
