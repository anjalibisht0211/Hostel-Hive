<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
if(session.getAttribute("student_id")==null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

int studentId=(Integer)session.getAttribute("student_id");
String hostel="";
boolean[][] booked=new boolean[91][3];

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con=DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/hostelhive","root","");

    PreparedStatement psHostel=con.prepareStatement(
        "SELECT hostel FROM students WHERE id=?");
    psHostel.setInt(1,studentId);
    ResultSet rh=psHostel.executeQuery();
    if(rh.next()) hostel=rh.getString("hostel");

    PreparedStatement ps=con.prepareStatement(
        "SELECT room_number,bed FROM bookings WHERE hostel_name=?");
    ps.setString(1,hostel);
    ResultSet rs=ps.executeQuery();

    while(rs.next()){
        int r=rs.getInt("room_number");
        String b=rs.getString("bed");
        if("A".equals(b)) booked[r][0]=true;
        if("B".equals(b)) booked[r][1]=true;
        if("C".equals(b)) booked[r][2]=true;
    }
    con.close();
}catch(Exception e){ out.println(e); }

/* COUNTS */
int bookedBeds=0;
for(int r=1;r<=90;r++)
 for(int b=0;b<3;b++)
  if(booked[r][b]) bookedBeds++;

int availableBeds=270-bookedBeds;
%>

<!DOCTYPE html>
<html>
<head>
<title>Room Availability</title>

<style>
body{margin:0;background:linear-gradient(120deg,#4B0082,#2E0854);font-family:'Segoe UI';color:white;}
.container{max-width:1300px;margin:auto;padding:20px;}
.topBar{display:flex;justify-content:space-between;margin-bottom:20px;}
.btn{padding:8px 16px;border-radius:8px;text-decoration:none;font-weight:bold;}
.back{background:white;color:#4B0082;}
.logout{background:#e53935;color:white;}
header{text-align:center;margin-bottom:30px;}
header h1{color:#FFD700;}
.floor{margin-bottom:60px;}
.floor-row{display:flex;justify-content:space-between;gap:40px;}
.block{width:48%;}
.top-row{display:grid;grid-template-columns:repeat(5,1fr);gap:6px;}
.bottom-row{display:grid;grid-template-columns:repeat(6,1fr);gap:6px;}
.middle{display:flex;justify-content:space-between;margin:6px 0;}
.side{display:grid;gap:6px;}
.room{background:rgba(255,255,255,0.1);padding:6px 4px;border-radius:10px;text-align:center;font-size:11px;}
.room h4{margin:3px;color:#FFD700;}
.beds button{margin:2px;padding:3px 6px;font-size:10px;border:none;border-radius:5px;}
.booked{background:#e53935;color:white;}
.free{background:#00c853;color:white;}
.courtyard{width:48%;height:130px;background:linear-gradient(120deg,#3a0066,#240046);
border-radius:18px;display:flex;justify-content:center;align-items:center;flex-direction:column;font-size:16px;}
</style>
</head>

<body>
<div class="container">

<div class="topBar">
<a href="student_dash.jsp" class="btn back">← Back</a>

</div>

<header>
<h1>Hostel Hive - <%=hostel%></h1>
<p>
🟢 Available Beds: <b style="color:#00ff88;"><%=availableBeds%></b> |
🔴 Occupied Beds: <b style="color:#ff4d4d;"><%=bookedBeds%></b>
</p>
</header>

<%
int roomNumber=1;
for(int floor=1;floor<=3;floor++){
%>

<div class="floor">
<h2><%= (floor==1)?"Ground Floor":(floor==2)?"First Floor":"Second Floor" %></h2>
<div class="floor-row">

<% for(int block=1;block<=2;block++){ %>
<div class="block">

<!-- TOP ROW -->
<div class="top-row">
<% for(int i=0;i<5;i++){ %>
<div class="room">
<h4>Room <%=roomNumber%></h4>
<div class="beds">
<% for(int b=0;b<3;b++){
String bed=(b==0)?"A":(b==1)?"B":"C"; %>
<button disabled class="<%=booked[roomNumber][b]?"booked":"free"%>"><%=bed%></button>
<% } %>
</div></div>
<% roomNumber++; } %>
</div>

<div class="middle">

<div class="side">
<% for(int i=0;i<2;i++){ %>
<div class="room">
<h4>Room <%=roomNumber%></h4>
<div class="beds">
<% for(int b=0;b<3;b++){String bed=(b==0)?"A":(b==1)?"B":"C"; %>
<button disabled class="<%=booked[roomNumber][b]?"booked":"free"%>"><%=bed%></button>
<% } %></div></div>
<% roomNumber++; } %>
</div>

<div class="courtyard">🏠<div style="color:gold;font-family:cursive;">HoHi</div></div>

<%
int[] leftRooms=new int[2];
for(int i=0;i<2;i++){ leftRooms[i]=roomNumber; roomNumber++; }
%>

<div class="side">
<% for(int i=1;i>=0;i--){ int rn=leftRooms[i]; %>
<div class="room">
<h4>Room <%=rn%></h4>
<div class="beds">
<% for(int b=0;b<3;b++){String bed=(b==0)?"A":(b==1)?"B":"C"; %>
<button disabled class="<%=booked[rn][b]?"booked":"free"%>"><%=bed%></button>
<% } %></div></div>
<% } %>
</div>

</div>

<%
int[] bottomRooms=new int[6];
for(int i=0;i<6;i++){ bottomRooms[i]=roomNumber; roomNumber++; }
%>

<div class="bottom-row">
<% for(int i=5;i>=0;i--){ int rn=bottomRooms[i]; %>
<div class="room">
<h4>Room <%=rn%></h4>
<div class="beds">
<% for(int b=0;b<3;b++){String bed=(b==0)?"A":(b==1)?"B":"C"; %>
<button disabled class="<%=booked[rn][b]?"booked":"free"%>"><%=bed%></button>
<% } %></div></div>
<% } %>
</div>

</div>
<% } %>

</div></div>
<% } %>

</div>
</body>
</html>
