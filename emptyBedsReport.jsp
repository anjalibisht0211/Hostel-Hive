<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
/* ===== SESSION CHECK ===== */
if(session.getAttribute("warden_id")==null){
response.sendRedirect("wardenlogin.jsp");
return;
}

/* ===== CACHE DISABLE ===== */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

int hostelId=(Integer)session.getAttribute("hostelid");

Connection con=null;

String hostelName="";
String search=request.getParameter("search");

/* arrays to store booking info */
boolean[][] booked=new boolean[91][3];

try{

Class.forName("com.mysql.cj.jdbc.Driver");

con=DriverManager.getConnection(
"jdbc:mysql://localhost:3307/hostelhive","root","");

/* ===== GET HOSTEL NAME ===== */

PreparedStatement ps1=con.prepareStatement(
"SELECT hostel_name FROM hostel WHERE hostel_id=?");

ps1.setInt(1,hostelId);

ResultSet rs1=ps1.executeQuery();

if(rs1.next()){
hostelName=rs1.getString(1);
}

/* ===== LOAD ALL BOOKINGS ===== */

PreparedStatement ps=con.prepareStatement(
"SELECT room_number,bed FROM bookings WHERE hostel_name=?");

ps.setString(1,hostelName);

ResultSet rs=ps.executeQuery();

while(rs.next()){

int r=rs.getInt("room_number");

String b=rs.getString("bed");

if("A".equals(b)) booked[r][0]=true;

if("B".equals(b)) booked[r][1]=true;

if("C".equals(b)) booked[r][2]=true;

}

}catch(Exception e){
out.println("Error: "+e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Room Availability Report</title>

<style>

body{
font-family:Segoe UI;
background:#f4f5ff;
margin:0;
}

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

.report-box{
background:white;
padding:25px;
border-radius:15px;
box-shadow:0 4px 12px rgba(0,0,0,.08);
}

table{
width:100%;
border-collapse:collapse;
margin-top:20px;
}

th,td{
padding:10px;
border:1px solid #ddd;
text-align:center;
}

th{
background:#4e54c8;
color:white;
}

.available{
color:green;
font-weight:bold;
}

.booked{
color:red;
font-weight:bold;
}

.btn{
padding:8px 15px;
background:#4e54c8;
color:white;
border:none;
border-radius:8px;
cursor:pointer;
}

.search-box{
padding:8px;
width:150px;
}

</style>

<script>
function printReport(){
window.print();
}
</script>

</head>

<body>

<div class="sidebar">

<h2>HOSTEL HIVE</h2>

<div class="nav">

<a href="wardendashboard.jsp">🏠 Dashboard</a>

<a href="emptyBedsReport.jsp" class="active">🛏 Available Beds Report</a>

<a href="warden_students.jsp">👨‍🎓 Students</a>

<a href="warden_complaints.jsp">📢 Complaints</a>

<a href="warden_availability.jsp">🛏 Rooms</a>

<a href="wardenSwapRequests.jsp">🔁 Room Swap</a>

<a href="wardenlogin.jsp">🚪 Logout</a>

</div>

</div>

<div class="container">

<h1>Room Availability Report</h1>

<form method="get">

<input type="text" name="search" placeholder="Room No"
value="<%=search!=null?search:""%>" class="search-box">

<button class="btn">Search</button>

<button type="button" onclick="printReport()" class="btn">Print</button>

</form>

<div class="report-box">

<h3>Hostel: <%=hostelName%></h3>

<table>

<tr>
<th>Room</th>
<th>A</th>
<th>B</th>
<th>C</th>
</tr>

<%

for(int room=1;room<=90;room++){

if(search!=null && !search.trim().isEmpty()){

if(!String.valueOf(room).contains(search)) continue;

}

%>

<tr>

<td><b><%=room%></b></td>

<td class="<%=booked[room][0]?"booked":"available"%>">
<%=booked[room][0]?"❌":"✔"%>
</td>

<td class="<%=booked[room][1]?"booked":"available"%>">
<%=booked[room][1]?"❌":"✔"%>
</td>

<td class="<%=booked[room][2]?"booked":"available"%>">
<%=booked[room][2]?"❌":"✔"%>
</td>

</tr>

<%
}
%>

</table>

</div>

</div>

</body>
</html>
