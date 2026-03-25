
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
/* ================= CACHE DISABLE ================= */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

/* ================= SESSION CHECK ================= */
if(session == null || session.getAttribute("student_id") == null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

String username = (String) session.getAttribute("username");

/* ================= LOGOUT LOGIC ================= */
String logout = request.getParameter("logout");

if("true".equals(logout)){
    session.removeAttribute("student_id");
    session.invalidate();
    response.sendRedirect("studentlogin.jsp");
    return;
}

/* ================= BOOKING STATUS ================= */
boolean bookingAllowed = true;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/hostelhive","root",""
    );

    Statement stmt = con.createStatement();

    ResultSet rs = stmt.executeQuery("SELECT status FROM booking_status WHERE id=1");

    if(rs.next()){
        String status = rs.getString("status");

        if("disabled".equalsIgnoreCase(status)){
            bookingAllowed = false;
        }
    }

    rs.close();
    stmt.close();
    con.close();

}catch(Exception e){
    bookingAllowed = false;
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

*{
margin:0;
padding:0;
box-sizing:border-box;
}

body{

font-family:'Poppins',sans-serif;

/* SAME COLOR AS ROOM BOOKING PAGE */
background:linear-gradient(120deg,#4B0082,#2E0854);

color:white;

min-height:100vh;

display:flex;
flex-direction:column;
align-items:center;

}

header{

width:100%;
background:rgba(255,255,255,0.12);

padding:20px 0;

text-align:center;

font-size:2rem;
font-weight:700;

/* GOLD COLOR LIKE ROOM PAGE */
color:#FFD700;

text-shadow:0 0 10px rgba(0,0,0,0.3);

box-shadow:0 4px 8px rgba(0,0,0,0.3);

}

.dashboard{

display:flex;
justify-content:center;
flex-wrap:wrap;

gap:40px;

margin-top:80px;

}

.card{

background:rgba(255,255,255,0.12);

border-radius:20px;

width:250px;
height:200px;

display:flex;
flex-direction:column;

justify-content:center;
align-items:center;

cursor:pointer;

box-shadow:0 8px 20px rgba(0,0,0,0.3);

transition:transform 0.3s, background 0.3s;

text-align:center;

}

.card:hover{

transform:translateY(-10px);

background:rgba(255,255,255,0.22);

}

.emoji{

font-size:3rem;
margin-bottom:15px;

}

.card-title{

font-size:1.3rem;
font-weight:600;

}

.logout-btn{

margin-top:60px;

background:#FFD700;
color:#2E0854;

border:none;

padding:12px 35px;

border-radius:25px;

cursor:pointer;

font-weight:bold;
font-size:1rem;

transition:0.3s;

}

.logout-btn:hover{

background:white;
color:#4B0082;

transform:scale(1.05);

}

footer{

margin-top:auto;

padding:20px;

color:#ddd;

font-size:0.9rem;

}

</style>

</head>

<body>

<header>
🏠 Hostel Hive - Welcome, <%= username %>!
</header>

<div class="dashboard">

<!-- BOOK ROOM -->

<div class="card"

<%= bookingAllowed
? "onclick=\"window.location.href='bookRoomRedirect.jsp'\""
: "onclick=\"alert('❌ Room booking is currently disabled by admin.')\""
%>

style="<%= bookingAllowed ? "" : "cursor:not-allowed;opacity:0.6;" %>"

>

<div class="emoji">🛏️</div>
<div class="card-title">Book Room</div>

</div>

<!-- COMPLAINT -->

<div class="card" onclick="window.location.href='student-complaint.jsp'">

<div class="emoji">🧾</div>
<div class="card-title">Complaint</div>

</div>

<!-- SWAP ROOM -->

<div class="card" onclick="window.location.href='swapDashboard.jsp'">

<div class="emoji">🔄</div>
<div class="card-title">Swap Room</div>

</div>

<!-- CHECK AVAILABILITY -->

<div class="card" onclick="window.location.href='roomAvailabilityStatus.jsp'">

<div class="emoji">📊</div>
<div class="card-title">Check Availability</div>

</div>

</div>

<form method="get">

<button type="submit" name="logout" value="true" class="logout-btn">
Logout
</button>

</form>

<footer>

© 2025 Hostel Hive | Smart Hostel Management System

</footer>

<script>

/* ===== BACK BUTTON PROTECTION ===== */

history.pushState(null, null, location.href);

window.onpopstate = function () {

history.go(1);

};

</script>

</body>
</html>

