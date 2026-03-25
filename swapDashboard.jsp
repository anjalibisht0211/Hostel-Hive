<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page session="true"%>

<%
/* ================= SESSION CHECK ================= */

if(session.getAttribute("student_id")==null){
    response.sendRedirect("studentlogin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>

<head>

<title>Swap Room</title>

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

/* SAME HOSTEL HIVE BACKGROUND */
background:linear-gradient(120deg,#4B0082,#2E0854);

color:white;

min-height:100vh;

display:flex;
flex-direction:column;
align-items:center;

}

/* ================= HEADER ================= */

header{

width:100%;

padding:20px;

text-align:center;

font-size:2rem;
font-weight:700;

color:#FFD700;

background:rgba(255,255,255,0.15);

box-shadow:0 4px 10px rgba(0,0,0,0.3);

}

/* ================= DASHBOARD ================= */

.dashboard{

display:flex;

gap:40px;

flex-wrap:wrap;

justify-content:center;

margin-top:80px;

}

/* ================= CARD ================= */

.card{

background:rgba(255,255,255,0.15);

border-radius:20px;

width:250px;
height:200px;

display:flex;
flex-direction:column;

justify-content:center;
align-items:center;

cursor:pointer;

box-shadow:0 8px 25px rgba(0,0,0,0.35);

transition:transform 0.3s, background 0.3s;

text-align:center;

}

.card:hover{

transform:translateY(-10px);

background:rgba(255,255,255,0.25);

}

/* ================= ICON ================= */

.emoji{

font-size:3rem;

margin-bottom:15px;

}

/* ================= TITLE ================= */

.title{

font-size:1.2rem;

font-weight:600;

}

/* ================= BACK BUTTON ================= */

.back{

margin-top:60px;

padding:12px 35px;

border-radius:25px;

border:none;

background:#FFD700;

cursor:pointer;

font-weight:bold;

font-size:1rem;

color:#2E0854;

transition:0.3s;

}

.back:hover{

background:white;

color:#4B0082;

transform:scale(1.05);

}

</style>

</head>

<body>

<header>
🔄 Room Swap Module
</header>


<div class="dashboard">

<!-- SEND REQUEST -->

<div class="card" onclick="window.location.href='swapRoom.jsp'">

<div class="emoji">➕</div>

<div class="title">
Send Swap Request
</div>

</div>


<!-- INCOMING REQUESTS -->

<div class="card" onclick="window.location.href='swapRequests.jsp'">

<div class="emoji">📩</div>

<div class="title">
Incoming Requests
</div>

</div>


<!-- MY STATUS -->

<div class="card" onclick="window.location.href='mySwapStatus.jsp'">

<div class="emoji">📊</div>

<div class="title">
My Request Status
</div>

</div>

</div>


<button class="back" onclick="window.location.href='student_dash.jsp'">

⬅ Back to Dashboard

</button>


</body>
</html>
