
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>

<%
/* ===== PREVENT PAGE CACHING ===== */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

/* ===== DESTROY OLD SESSION ===== */
if(session.getAttribute("admin_id") != null){
    session.invalidate();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Hostel Hive | Admin Portal</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Segoe UI',sans-serif;
}

body{
height:100vh;
display:flex;
justify-content:center;
align-items:center;
background:linear-gradient(135deg,#4e54c8,#8f94fb);
}

.login-container{
width:420px;
background:white;
padding:45px 35px;
border-radius:20px;
box-shadow:0 15px 35px rgba(0,0,0,0.15);
text-align:center;
}

.logo{
font-size:26px;
font-weight:bold;
color:#4e54c8;
margin-bottom:5px;
}

.subtitle{
font-size:14px;
color:#777;
margin-bottom:30px;
}

h2{
margin-bottom:25px;
color:#333;
}

input{
width:100%;
padding:12px;
margin-bottom:18px;
border-radius:10px;
border:1.5px solid #ccc;
font-size:14px;
transition:0.3s;
}

input:focus{
border-color:#4e54c8;
outline:none;
box-shadow:0 0 0 2px rgba(78,84,200,0.2);
}

button{
width:100%;
padding:12px;
border:none;
border-radius:10px;
background:#4e54c8;
color:white;
font-size:16px;
font-weight:bold;
cursor:pointer;
transition:0.3s;
}

button:hover{
background:#3d42b3;
}

.back-link{
margin-top:18px;
display:inline-block;
font-size:14px;
color:#4e54c8;
text-decoration:none;
}

.back-link:hover{
text-decoration:underline;
}

.footer{
margin-top:25px;
font-size:12px;
color:#999;
}

</style>

</head>

<body>

<div class="login-container">

<div class="logo">HOSTEL HIVE</div>
<div class="subtitle">Administrative Access Portal</div>

<h2>🛡️ Admin Login</h2>

<form action="AdminLoginServlet" method="POST" onsubmit="return validateForm()">

<input type="text" id="id" name="id" placeholder="Enter Admin ID">

<input type="text" id="name" name="name" placeholder="Enter Admin Name">

<button type="submit">Sign In</button>

</form>

<a href="user.jsp" class="back-link">⬅ Back</a>

<div class="footer">
© 2026 Hostel Hive Management System
</div>

</div>

<script>

/* ===== FORM VALIDATION ===== */

function validateForm(){

let id=document.getElementById("id").value.trim();
let name=document.getElementById("name").value.trim();

if(id===""){
alert("Please enter Admin ID");
return false;
}

if(name===""){
alert("Please enter Admin Name");
return false;
}

return true;
}

/* ===== BACK BUTTON PROTECTION ===== */

history.pushState(null,null,location.href);

window.onpopstate=function(){
history.go(1);
};

</script>

</body>
</html>

