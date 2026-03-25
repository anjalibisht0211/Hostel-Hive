
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
/* ===== SESSION CHECK ===== */

if(session.getAttribute("student_id") == null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

int myId = (Integer)session.getAttribute("student_id");

/* ===== DB CONNECTION ===== */

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3307/hostelhive","root",""
);
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>My Swap Requests</title>

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

width:500px;

max-height:80vh;

overflow:auto;

box-shadow:0 8px 25px rgba(0,0,0,0.35);

backdrop-filter:blur(6px);

}

/* ================= HEADER ================= */

h2{

color:#FFD700;

margin-bottom:15px;

}

/* ================= REQUEST BOX ================= */

.req{

background:rgba(255,255,255,0.20);

padding:15px;

border-radius:15px;

margin-top:15px;

}

/* ================= STATUS COLORS ================= */

.pending{
color:#FFD700;
}

.approved{
color:#7CFF6B;
}

.rejected{
color:#ff4d4d;
}

.wait{
color:#FFE066;
}

/* ================= BACK LINK ================= */

.back{

color:#FFD700;

display:block;

margin-top:20px;

text-decoration:none;

font-weight:bold;

}

.back:hover{

color:white;

}

</style>

</head>

<body>

<div class="card">

<h2>📩 My Swap Requests</h2>

<%

PreparedStatement pst = con.prepareStatement(

    "SELECT r.id, r.requester_room, r.target_room, r.status, " +
    "s2.name AS target_name, r.target_student_id " +
    "FROM room_swap_requests r " +
    "LEFT JOIN students s2 ON r.target_student_id=s2.id " +
    "WHERE r.requester_id=? ORDER BY r.id DESC"

);

pst.setInt(1, myId);

ResultSet rs = pst.executeQuery();

boolean hasReq = false;

while(rs.next()){

hasReq = true;

String status = rs.getString("status");

String css = "pending";

String text = "⏳ Waiting for target student / warden approval";


if("approved".equals(status)){

css="approved";
text="✅ Approved by Warden";

}

if("rejected".equals(status)){

css="rejected";
text="❌ Rejected by Warden";

}

if("waiting_warden".equals(status)){

css="wait";
text="🏢 Waiting for Warden Approval";

}


String targetName = rs.getString("target_name");

if(targetName == null || rs.getInt("target_student_id") == 0){

targetName = "Warden Assigned Bed";

}

%>


<div class="req">

<b>Swap Request ID:</b> <%=rs.getInt("id")%>

<br><br>

Target: <b><%=targetName%></b>

<br>

Your Room: <b><%=rs.getString("requester_room")%></b>

<br>

Target Room: <b><%=rs.getString("target_room")%></b>

<br>

Status: <b class="<%=css%>"><%=text%></b>

</div>


<%

}

if(!hasReq){

%>

<p>You have not sent any swap requests yet 🙂</p>

<%

}

%>


<a class="back" href="swapDashboard.jsp">

⬅ Back

</a>

</div>

</body>

</html>

