<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>

<%
        /* ===== PREVENT BROWSER CACHE ===== */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

/* ===== SESSION CHECK ===== */
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("adminlogin.jsp");
    return;
}


String adminName=(String)session.getAttribute("admin_name");

int totalStudents=0;
int totalHostels=0;
int totalWardens=0;
int totalBookings=0;
int totalRooms=0;
int totalBeds=0;
int availableBeds=0;
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard | Hostel Hive</title>

<style>
body{
    margin:0;
    font-family:Segoe UI;
    background:#f4f5ff;
}

/* ===== SIDEBAR ===== */
.sidebar{
    width:250px;
    background:#4e54c8;
    color:white;
    position:fixed;
    height:100%;
    padding:25px 15px;
}

.sidebar h2{
    text-align:left;
    margin-bottom:30px;
}

.nav a{
    display:block;
    padding:12px;
    margin:10px 0;
    text-decoration:none;
    color:white;
    background:rgba(255,255,255,0.15);
    border-radius:10px;
    transition:.3s;
}

.nav a:hover,
.nav .active{
    background:white;
    color:#4e54c8;
}

/* ===== MAIN ===== */
.main{
    margin-left:270px;
    padding:30px;
}

.header{
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.header h1{
    margin:0;
}

.logout-btn{
    background:#e53935;
    color:white;
    padding:8px 15px;
    border-radius:10px;
    text-decoration:none;
}

.cards{
    margin-top:30px;
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
}

.card{
    background:white;
    padding:25px;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
    transition:.3s;
}

.card:hover{
    transform:translateY(-5px);
}

.card h3{
    margin:0;
    font-size:14px;
    color:#666;
}

.card h1{
    margin-top:10px;
    font-size:28px;
    color:#4e54c8;
}
</style>
</head>

<body>

<!-- SIDEBAR -->


<div class="sidebar">
    <h2>HOSTEL HIVE</h2>

    <div class="nav">
        <a href="admindashboard.jsp" class="active">🏠 Dashboard</a>
        <a href="admin-complaintStudent.jsp">📊 Complaints</a>
        <a href="admin-registeredStudents.jsp">🧑‍🎓 Registered Students</a>
        <a href="admin-registerStudent.jsp">➕ Register Student</a>
        <a href="admin-roomBookingControl.jsp" >🛏️ Room Booking</a>
       <a href="admin-warden.jsp">👮 Warden</a>
       <a href="admin_hostel.jsp" >🏢 Hostel</a>
        <a href="adminlogin.jsp">🚪 Logout</a>
    </div>
</div>


<!-- MAIN CONTENT -->
<div class="main">

<div class="header">
<h1>Welcome, Admin!</h1>
</div>

<%
try{
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con=DriverManager.getConnection(
    "jdbc:mysql://localhost:3307/hostelhive","root","");

/* Total Students */
PreparedStatement ps1=con.prepareStatement("SELECT COUNT(*) FROM students");
ResultSet rs1=ps1.executeQuery();
if(rs1.next()) totalStudents=rs1.getInt(1);

/* Total Hostels */
PreparedStatement ps2=con.prepareStatement("SELECT COUNT(*) FROM hostel");
ResultSet rs2=ps2.executeQuery();
if(rs2.next()) totalHostels=rs2.getInt(1);

/* Total Wardens */
PreparedStatement ps3=con.prepareStatement("SELECT COUNT(*) FROM wardens");
ResultSet rs3=ps3.executeQuery();
if(rs3.next()) totalWardens=rs3.getInt(1);

/* Total Bookings */
PreparedStatement ps4=con.prepareStatement("SELECT COUNT(*) FROM bookings");
ResultSet rs4=ps4.executeQuery();
if(rs4.next()) totalBookings=rs4.getInt(1);

/* System Capacity */
totalRooms = totalHostels * 90;
totalBeds  = totalRooms * 3;
availableBeds = totalBeds - totalBookings;

con.close();
}catch(Exception e){
    out.println("<p style='color:red'>"+e+"</p>");
}
%>

<!-- DASHBOARD CARDS -->
<div class="cards">

<div class="card">
<h3>Total Registered Students</h3>
<h1><%=totalStudents%></h1>
</div>

<div class="card">
<h3>Total Hostels</h3>
<h1><%=totalHostels%></h1>
</div>

<div class="card">
<h3>Total Wardens</h3>
<h1><%=totalWardens%></h1>
</div>

<div class="card">
<h3>Total Bookings</h3>
<h1><%=totalBookings%></h1>
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
<h1 style="color:#00c853;"><%=availableBeds%></h1>
</div>

</div>

</div>

</body>
</html>
