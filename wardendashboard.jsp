<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/* Disable cache */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

/* Session check */
if(session.getAttribute("warden_id")==null){
    response.sendRedirect("wardenlogin.jsp");
    return;
}
String wardenName=(String)session.getAttribute("warden_name");
int hostelId=(Integer)session.getAttribute("hostelid");

Connection con=null;
String hostelName="";
int totalStudents=0;
int totalRooms=90;
int totalBeds=270;
int bookedBeds=0;
int availableBeds=0;
%>

<!DOCTYPE html>
<html>
<head>
<title>Warden Dashboard</title>
<style>
body{
    font-family:Segoe UI;
    background:#f4f5ff;
    margin:0;
}

/* SIDEBAR (UNCHANGED) */
.sidebar{
    width:240px;
    background:#4e54c8;
    color:white;
    min-height:100vh;
    padding:25px 15px;
    position:fixed;
}
.nav a{
    margin:10px 0;
    display:block;
    text-decoration:none;
    color:white;
    background:rgba(255,255,255,0.15);
    padding:10px;
    border-radius:10px;
}
.nav a:hover,.active{
    background:white;
    color:#4e54c8;
}

.container{
    margin-left:260px;
    padding:30px;
}

.dashboard-grid{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
    margin-top:20px;
}

.card{
    background:white;
    padding:25px;
    border-radius:15px;
    box-shadow:0 4px 12px rgba(0,0,0,.08);
    transition:.3s;
}

.card:hover{
    transform:translateY(-4px);
}

.card h3{
    margin:0;
    font-size:16px;
    color:#555;
}

.card h1{
    margin-top:10px;
    font-size:28px;
    color:#4e54c8;
}
.hostel-title{
    font-size:22px;
    font-weight:bold;
    margin-top:10px;
    color:#333;
}
</style>
</head>

<body>

<div class="sidebar">
<h2>HOSTEL HIVE</h2>
<div class="nav">
<a href="wardendashboard.jsp" class="active">🏠 Dashboard</a>
<a href="emptyBedsReport.jsp" >🛏 Available Beds Report</a>
<a href="warden_students.jsp">👨‍🎓 Students</a>
<a href="warden_complaints.jsp">📢 Complaints</a>
<a href="warden_availability.jsp" >🛏 Rooms</a>
<a href="wardenSwapRequests.jsp" >🔁 Room Swap</a>
<a href="wardenlogin.jsp">🚪 Logout</a>
</div>
</div>

<div class="container">

<h1>Welcome, <%=wardenName%></h1>

<%
try{
Class.forName("com.mysql.cj.jdbc.Driver");
con=DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");

/* Get Hostel Name */
PreparedStatement ps1=con.prepareStatement(
"SELECT hostel_name FROM hostel WHERE hostel_id=?");
ps1.setInt(1,hostelId);
ResultSet rs1=ps1.executeQuery();
if(rs1.next()) hostelName=rs1.getString(1).toUpperCase();

/* Total Students */
PreparedStatement ps2=con.prepareStatement(
"SELECT COUNT(*) FROM students WHERE Hostel=?");
ps2.setString(1,hostelName);
ResultSet rs2=ps2.executeQuery();
if(rs2.next()) totalStudents=rs2.getInt(1);

/* Booked Beds */
PreparedStatement ps3=con.prepareStatement(
"SELECT COUNT(*) FROM bookings WHERE hostel_name=?");
ps3.setString(1,hostelName);
ResultSet rs3=ps3.executeQuery();
if(rs3.next()) bookedBeds=rs3.getInt(1);

availableBeds=totalBeds-bookedBeds;
%>

<div class="hostel-title">
🏠 HOSTEL : <%=hostelName%>
</div>

<div class="dashboard-grid">

<div class="card">
<h3>Total Students</h3>
<h1><%=totalStudents%></h1>
</div>

<div class="card">
<h3>Total Rooms</h3>
<h1><%=totalRooms%></h1>
</div>

<div class="card">
<h3>Total Beds</h3>
<h1><%=totalBeds%></h1>
</div>

<div class="card">
<h3>Available Beds</h3>
<h1><%=availableBeds%></h1>
</div>

</div>

<%
}catch(Exception e){ out.println(e); }
%>

</div>
</body>
</html>
