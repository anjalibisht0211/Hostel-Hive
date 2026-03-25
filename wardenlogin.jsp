<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
/* ===== DISABLE CACHE ===== */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

/* ===== OPTIONAL: DESTROY OLD SESSION ===== */
if(session.getAttribute("warden_id")!=null){
     response.sendRedirect("wardenlogin.jsp");
     session.invalidate();
}

String errorMsg = "";

/* ===== LOGIN LOGIC ===== */
if("POST".equalsIgnoreCase(request.getMethod())){

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive","root",""
        );

        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM wardens WHERE username=? AND password=?"
        );

        ps.setString(1,username);
        ps.setString(2,password);

        ResultSet rs = ps.executeQuery();

        if(rs.next()){

            /* CREATE SESSION */

            session.setAttribute("warden_id",rs.getInt("warden_id"));
            session.setAttribute("warden_name",rs.getString("warden_name"));
            session.setAttribute("hostelid",rs.getInt("hostelid"));
            session.setAttribute("warden_username",rs.getString("username"));

            /* REDIRECT */

            response.sendRedirect("wardendashboard.jsp");
            return;

        }else{

            errorMsg="Invalid Username or Password!";

        }

        con.close();

    }catch(Exception e){

        errorMsg="Database Error : "+e.getMessage();

    }
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Warden Login | Hostel Hive</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&family=Pacifico&display=swap" rel="stylesheet">

<style>

*{margin:0;padding:0;box-sizing:border-box;font-family:Poppins;}

body{
height:100vh;
background:linear-gradient(120deg,#4e54c8,#8f94fb);
display:flex;
justify-content:center;
align-items:center;
}

.card{
background:rgba(255,255,255,0.15);
backdrop-filter:blur(12px);
padding:40px;
width:380px;
border-radius:25px;
box-shadow:0 25px 60px rgba(0,0,0,0.35);
text-align:center;
color:white;
}

.brand{
font-family:Pacifico;
font-size:34px;
color:#ffd369;
margin-bottom:10px;
}

.subtitle{
margin-bottom:25px;
opacity:.9;
}

.inputBox{
margin-bottom:18px;
}

.inputBox input{
width:100%;
padding:13px;
border-radius:12px;
border:none;
}

.btn{
width:100%;
padding:14px;
border:none;
border-radius:25px;
background:#ffd369;
color:#4e54c8;
font-weight:600;
cursor:pointer;
}

.btn:hover{
background:white;
transform:scale(1.05);
}

.error{
margin-top:15px;
color:#ffb3b3;
}

.backLink{
display:block;
margin-top:15px;
color:white;
text-decoration:none;
}

</style>

<script>

/* ===== PREVENT BACK BUTTON ===== */

function preventBack(){
window.history.pushState(null,null,window.location.href);
}

window.onload=function(){
preventBack();
window.onpopstate=function(){
window.history.pushState(null,null,window.location.href);
}
};

</script>

</head>

<body>

<div class="card">

<div class="brand">Hostel Hive</div>
<div class="subtitle">Warden Login Portal</div>

<form method="post">

<div class="inputBox">
<input type="text" name="username" placeholder="Username" required>
</div>

<div class="inputBox">
<input type="password" name="password" placeholder="Password" required>
</div>

<button class="btn">Login</button>

</form>

<div class="error"><%= errorMsg %></div>

<a href="user.jsp" class="backLink">⬅ Back</a>

</div>

</body>
</html>