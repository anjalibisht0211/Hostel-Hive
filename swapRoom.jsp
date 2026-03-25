
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
/* ================= SESSION CHECK ================= */

if(session.getAttribute("student_id") == null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

int myId = (Integer)session.getAttribute("student_id");

String msg = "";

/* ================= DATABASE ================= */

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3307/hostelhive","root",""
);

/* ================= GET MY ROOM ================= */

String myRoom="";
String myHostel="";

PreparedStatement ps1 = con.prepareStatement(
"SELECT room, Hostel FROM students WHERE id=?"
);

ps1.setInt(1,myId);

ResultSet rs1 = ps1.executeQuery();

if(rs1.next()){
    myRoom = rs1.getString("room");
    myHostel = rs1.getString("Hostel");
}

/* ================= HANDLE FORM ================= */

if(request.getParameter("type")!=null){

String type=request.getParameter("type");
String reason=request.getParameter("reason");

/* CHECK PENDING REQUEST */

PreparedStatement chk=con.prepareStatement(
"SELECT * FROM room_swap_requests WHERE requester_id=? AND status IN('pending','waiting_warden')"
);

chk.setInt(1,myId);

ResultSet rsChk=chk.executeQuery();

if(rsChk.next()){

msg="⏳ You already have a pending request!";

}
else{

/* ================= BED CHANGE ================= */

if("bed_change".equals(type)){

String newRoom=request.getParameter("newRoomNum");
String newBed=request.getParameter("newBedLetter");

if(newRoom.equals("")||newBed.equals("")){
msg="❌ Enter new room & bed!";
}
else{

PreparedStatement checkBed=con.prepareStatement(
"SELECT * FROM bookings WHERE hostel_name=? AND room_number=? AND bed=?"
);

checkBed.setString(1,myHostel);
checkBed.setInt(2,Integer.parseInt(newRoom));
checkBed.setString(3,newBed);

ResultSet rsBed=checkBed.executeQuery();

if(rsBed.next()){
msg="❌ Bed already occupied!";
}
else{

PreparedStatement insert=con.prepareStatement(
"INSERT INTO room_swap_requests(requester_id,target_student_id,requester_room,target_room,request_type,status,reason,created_at) VALUES(?,?,?,?, 'bed_change','waiting_warden',?,NOW())"
);

insert.setInt(1,myId);
insert.setNull(2,java.sql.Types.INTEGER);
insert.setString(3,myRoom);
insert.setString(4,newRoom+newBed);
insert.setString(5,reason);

insert.executeUpdate();

msg="✅ Request sent to warden!";
}
}
}

/* ================= STUDENT SWAP ================= */

if("student_swap".equals(type)){

String tRoom=request.getParameter("targetRoom");
String tBed=request.getParameter("targetBed");

PreparedStatement find=con.prepareStatement(
"SELECT id FROM students WHERE room=? AND Hostel=?"
);

find.setString(1,tRoom+tBed);
find.setString(2,myHostel);

ResultSet rs=find.executeQuery();

if(rs.next()){

int targetId=rs.getInt("id");

PreparedStatement insert=con.prepareStatement(
"INSERT INTO room_swap_requests(requester_id,target_student_id,requester_room,target_room,request_type,status,reason,created_at) VALUES(?,?,?,?, 'student_swap','pending',?,NOW())"
);

insert.setInt(1,myId);
insert.setInt(2,targetId);
insert.setString(3,myRoom);
insert.setString(4,tRoom+tBed);
insert.setString(5,reason);

insert.executeUpdate();

msg="📩 Request sent to student!";
}
else{
msg="❌ Student not found!";
}
}

}

}

con.close();
%>


<!DOCTYPE html>
<html>

<head>

<title>Room Swap</title>

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

width:420px;

text-align:center;

box-shadow:0 8px 25px rgba(0,0,0,0.35);

backdrop-filter:blur(6px);

}

/* ================= HEADINGS ================= */

h2{
color:#FFD700;
margin-bottom:10px;
}

b{
color:#FFD700;
}

/* ================= INPUTS ================= */

input,textarea,select{

width:90%;

padding:10px;

margin-top:10px;

border:none;

border-radius:10px;

font-size:14px;

}

textarea{
resize:none;
height:70px;
}

/* ================= BUTTON ================= */

button{

margin-top:20px;

padding:12px 30px;

border:none;

border-radius:25px;

background:#FFD700;

font-weight:bold;

cursor:pointer;

color:#2E0854;

transition:0.3s;

}

button:hover{

background:white;

color:#4B0082;

}

/* ================= BACK LINK ================= */

.back{

color:#FFD700;

display:block;

margin-top:15px;

text-decoration:none;

font-weight:bold;

}

/* ================= MESSAGE ================= */

.msg{

color:#7CFF6B;

font-weight:bold;

margin-top:10px;

}

.hidden{
display:none;
}

</style>

<script>

function toggleFields(){

let type=document.getElementById("type").value;

if(type=="bed_change"){

document.getElementById("bedChangeFields").style.display="block";
document.getElementById("studentSwapFields").style.display="none";

}
else{

document.getElementById("bedChangeFields").style.display="none";
document.getElementById("studentSwapFields").style.display="block";

}

}

</script>

</head>


<body>

<div class="card">

<h2>🔁 Room Swap / Bed Change</h2>

<b>Your Room:</b> <%=myRoom%>

<form method="post">

<select name="type" id="type" onchange="toggleFields()" required>

<option value="">Select Request Type</option>

<option value="student_swap">Swap with Student</option>
<option value="bed_change">Change Bed Only</option>

</select>


<!-- BED CHANGE -->

<div id="bedChangeFields" class="hidden">

<h4>New Bed Details</h4>

<input type="text" name="newRoomNum" placeholder="New Room Number">

<input type="text" name="newBedLetter" placeholder="Bed A/B/C">

</div>


<!-- STUDENT SWAP -->

<div id="studentSwapFields" class="hidden">

<h4>Target Student Details</h4>

<input type="text" name="targetRoom" placeholder="Target Room Number">

<input type="text" name="targetBed" placeholder="Target Bed">

</div>


<textarea name="reason" placeholder="Reason for request" required></textarea>

<button type="submit">

Send Request

</button>

</form>

<p class="msg"><%=msg%></p>

<a class="back" href="swapDashboard.jsp">

⬅ Back

</a>

</div>

</body>

</html>