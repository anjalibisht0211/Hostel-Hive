
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>

<%
/* ===== DESTROY SESSION WHEN RETURNING TO ROLE PAGE ===== */
if(session != null){
    session.invalidate();
}

/* ===== STRONG CACHE PREVENTION ===== */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setHeader("Expires","0");
response.setDateHeader("Expires",0);
%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Hostel Hive | Role Selection</title>

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
font-family:'Poppins',sans-serif;
background:linear-gradient(120deg,#4B0082,#6a5acd);
color:white;
}

.container{
text-align:center;
}

h1{
font-family:'Pacifico',cursive;
font-size:3.2rem;
color:#FFD700;
margin-bottom:15px;
text-shadow:0 4px 10px rgba(0,0,0,0.4);
}

p{
font-size:1.1rem;
margin-bottom:35px;
opacity:0.9;
}

.role-container{
display:flex;
gap:35px;
justify-content:center;
}

.role-card{
width:170px;
height:170px;
background:rgba(255,255,255,0.15);
border-radius:18px;
display:flex;
flex-direction:column;
justify-content:center;
align-items:center;
cursor:pointer;
transition:all 0.3s ease;
box-shadow:0 8px 20px rgba(0,0,0,0.25);
}

.role-card:hover{
background:rgba(255,255,255,0.25);
transform:translateY(-8px);
}

.role-card span{
font-size:3.2rem;
margin-bottom:12px;
}

.role-card h3{
font-size:1.2rem;
font-weight:600;
}

</style>

<script>

/* ===== STRONG BACK BUTTON PROTECTION ===== */

function disableBack(){

    window.history.forward();

}

setTimeout("disableBack()",0);

window.onunload=function(){};

/* ===== NAVIGATION FUNCTIONS ===== */

function goToStudent(){
    window.location.href="studentlogin.jsp";
}

function goToWarden(){
    window.location.href="wardenlogin.jsp";
}

function goToAdmin(){
    window.location.href="adminlogin.jsp";
}

</script>

</head>

<body>

<div class="container">

<h1>Hostel Hive</h1>
<p>Select your role:</p>

<div class="role-container">

<div class="role-card" onclick="goToStudent()">
<span>🎓</span>
<h3>Student</h3>
</div>

<div class="role-card" onclick="goToWarden()">
<span>👮</span>
<h3>Warden</h3>
</div>

<div class="role-card" onclick="goToAdmin()">
<span>🛡️</span>
<h3>Admin</h3>
</div>

</div>

</div>

</body>
</html>

