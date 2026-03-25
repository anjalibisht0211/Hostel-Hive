
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*" %>

<%
/* ================= SESSION CHECK ================= */

if(session.getAttribute("student_id")==null){
response.sendRedirect("studentlogin.jsp");
return;
}

int myId=(Integer)session.getAttribute("student_id");

String msg="";

/* ================= DATABASE ================= */

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3307/hostelhive","root","");

/* ================= ACCEPT / REJECT ================= */

String action=request.getParameter("action");
String reqId=request.getParameter("reqId");

if(action!=null){

PreparedStatement ps;

if(action.equals("accept")){

ps=con.prepareStatement(
"UPDATE room_swap_requests SET status='waiting_warden' WHERE id=?"
);

msg="✅ Sent to warden!";

}
else{

ps=con.prepareStatement(
"UPDATE room_swap_requests SET status='rejected' WHERE id=?"
);

msg="❌ Request rejected";

}

ps.setInt(1,Integer.parseInt(reqId));
ps.executeUpdate();

}
%>


<!DOCTYPE html>
<html>

<head>

<title>Swap Requests</title>

<style>

@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

*{
margin:0;
padding:0;
box-sizing:border-box;
}

body{

font-family:'Poppins',sans-serif;

background:linear-gradient(120deg,#4B0082,#2E0854);

color:white;

display:flex;

justify-content:center;
align-items:center;

min-height:100vh;

}

/* ================= CARD ================= */

.card{

background:rgba(255,255,255,0.15);

padding:40px;

border-radius:20px;

width:520px;

max-height:85vh;

overflow:auto;

box-shadow:0 8px 25px rgba(0,0,0,0.35);

backdrop-filter:blur(6px);

}

/* ================= HEADER ================= */

h2{

color:#FFD700;

margin-bottom:10px;

}

/* ================= REQUEST BOX ================= */

.req{

background:rgba(255,255,255,0.20);

padding:15px;

border-radius:15px;

margin-top:15px;

}

/* ================= BUTTONS ================= */

.btn{

padding:8px 15px;

border:none;

border-radius:10px;

font-weight:bold;

cursor:pointer;

margin-right:10px;

}

/* ACCEPT */

.accept{

background:#FFD700;

color:#2E0854;

}

/* REJECT */

.reject{

background:#ff4d4d;

color:white;

}

/* BUTTON HOVER */

.accept:hover{

background:white;

color:#4B0082;

}

.reject:hover{

background:#ff7777;

}

/* ================= MESSAGE ================= */

.msg{

color:#7CFF6B;

font-weight:bold;

margin-bottom:10px;

}

/* ================= BACK LINK ================= */

.back{

color:#FFD700;

text-decoration:none;

font-weight:bold;

display:inline-block;

margin-top:20px;

}

</style>

</head>


<body>

<div class="card">

<h2>📩 Incoming Swap Requests</h2>

<p class="msg"><%=msg%></p>


<%

PreparedStatement pst=con.prepareStatement(

"SELECT r.id,r.requester_room,r.target_room,s.name " +
"FROM room_swap_requests r " +
"JOIN students s ON r.requester_id=s.id " +
"WHERE r.target_student_id=? AND r.status='pending'"

);

pst.setInt(1,myId);

ResultSet rs=pst.executeQuery();

boolean found=false;

while(rs.next()){

found=true;

%>


<div class="req">

<b><%=rs.getString("name")%></b> wants to swap<br>

<%=rs.getString("requester_room")%> ↔ <%=rs.getString("target_room")%>

<br><br>

<a href="?action=accept&reqId=<%=rs.getInt("id")%>">

<button class="btn accept">
Accept
</button>

</a>


<a href="?action=reject&reqId=<%=rs.getInt("id")%>">

<button class="btn reject">
Reject
</button>

</a>

</div>


<%

}

if(!found){

%>

No pending requests 🙂

<%

}

%>


<br>

<a class="back" href="swapDashboard.jsp">

⬅ Back

</a>

</div>

</body>

</html>

