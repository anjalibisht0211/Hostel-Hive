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
int hostelId=(Integer)session.getAttribute("hostelid");
Connection con=null;
String hostelName="";

/* arrays for rooms */
boolean[][] booked=new boolean[91][3];
String[][] tooltip=new String[91][3];

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con=DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");

    /* get hostel name */
    PreparedStatement ps1=con.prepareStatement(
        "SELECT hostel_name FROM hostel WHERE hostel_id=?"
    );
    ps1.setInt(1,hostelId);
    ResultSet rs1=ps1.executeQuery();
    if(rs1.next()) hostelName=rs1.getString(1);

    /* get booked beds + student info */
    PreparedStatement ps=con.prepareStatement(
        "SELECT b.room_number,b.bed,s.name,s.studentId,s.phone "+
        "FROM bookings b JOIN students s ON b.student_id=s.id "+
        "WHERE b.hostel_name=?"
    );
    ps.setString(1,hostelName);
    ResultSet rs=ps.executeQuery();

    while(rs.next()){
        int r=rs.getInt("room_number");
        String b=rs.getString("bed");

        String info="Name: "+rs.getString("name")
        +" | ID: "+rs.getString("studentId")
        +" | Phone: "+rs.getString("phone")
        +" | Room "+r+"-"+b;

        if("A".equals(b)){ booked[r][0]=true; tooltip[r][0]=info; }
        if("B".equals(b)){ booked[r][1]=true; tooltip[r][1]=info; }
        if("C".equals(b)){ booked[r][2]=true; tooltip[r][2]=info; }
    }

}catch(Exception e){ out.println(e); }
%>

<!DOCTYPE html>
<html>
<head>
<title>Room Occupancy</title>

<style>
body{
    margin:0;
    font-family:Segoe UI;
    background:#f4f5ff;
}

/* ===== SIDEBAR (same as complaints) ===== */
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
    padding:20px;
}

/* ===== ROOM CONTAINER — WHITE THEME ===== */
.roomContainer{
    background:white;
    padding:25px;
    border-radius:20px;
    box-shadow:0 5px 20px rgba(0,0,0,0.1);
}

/* FLOOR TITLE */
.floor h2{
    color:#4e54c8;
}

/* GRID STRUCTURE */
.floor{margin-bottom:60px;}
.floor-row{display:flex;justify-content:space-between;gap:40px;}
.block{width:48%;}
.top-row{display:grid;grid-template-columns:repeat(5,1fr);gap:10px;}
.bottom-row{display:grid;grid-template-columns:repeat(6,1fr);gap:10px;}
.middle{display:flex;justify-content:space-between;margin:10px 0;}
.side{display:grid;gap:10px;}

/* ROOM CARD */
.room{
    background:#f7f8ff;
    padding:8px;
    border-radius:12px;
    text-align:center;
    font-size:12px;
    border:1px solid #e0e3ff;
}
.room h4{
    margin:3px;
    color:#4e54c8;
    font-size:13px;
}

/* BEDS */
.beds button{
    margin:3px;
    padding:5px 8px;
    font-size:11px;
    border:none;
    border-radius:6px;
    cursor:pointer;
}

/* OCCUPIED BED */
.booked{
    background:#e53935;
    color:white;
}

/* FREE BED */
.free{
    background:#00c853;
    color:white;
}

/* COURTYARD */
.courtyard{
    width:48%;
    height:130px;
    background:#eef0ff;
    border:2px dashed #4e54c8;
    border-radius:18px;
    display:flex;
    justify-content:center;
    align-items:center;
    flex-direction:column;
    color:#4e54c8;
    font-weight:bold;
}
</style>

</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
<h2>HOSTEL HIVE</h2>
<div class="nav">
<a href="wardendashboard.jsp">🏠 Dashboard</a>
<a href="emptyBedsReport.jsp" >🛏 Available Beds Report</a>
<a href="warden_students.jsp">👨‍🎓 Students</a>
<a href="warden_complaints.jsp">📢 Complaints</a>
<a href="warden_availability.jsp" class="active" >🛏 Rooms</a>
<a href="wardenSwapRequests.jsp" >🔁 Room Swap</a>
<a href="wardenlogin.jsp">🚪 Logout</a>
</div>
</div>

<div class="container">
<h1>Room Occupancy — <%=hostelName.toUpperCase()%></h1>


<div class="roomContainer">
    
<p>Hover on booked bed to see student details</p>
🟢 Available <b style="color:#00ff88;"></b> |
🔴 Booked <b style="color:#ff4d4d;"></b>
</p>
<%
int roomNumber=1;
for(int floor=1;floor<=3;floor++){
%>

<div class="floor">
<h2><%= (floor==1)?"Ground Floor":(floor==2)?"First Floor":"Second Floor" %></h2>
<div class="floor-row">

<% for(int block=1;block<=2;block++){ %>
<div class="block">

<div class="top-row">
<% for(int i=0;i<5;i++){ %>
<div class="room">
<h4>Room <%=roomNumber%></h4>
<div class="beds">
<% for(int b=0;b<3;b++){
String bed=(b==0)?"A":(b==1)?"B":"C";
String tip=tooltip[roomNumber][b];
%>
<button disabled title="<%= tip==null?"Available":tip %>"
class="<%=booked[roomNumber][b]?"booked":"free"%>"><%=bed%></button>
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
<% for(int b=0;b<3;b++){
String bed=(b==0)?"A":(b==1)?"B":"C";
String tip=tooltip[roomNumber][b];
%>
<button disabled title="<%= tip==null?"Available":tip %>"
class="<%=booked[roomNumber][b]?"booked":"free"%>"><%=bed%></button>
<% } %></div></div>
<% roomNumber++; } %>
</div>

<div class="courtyard">🏠 HoHi</div>

<%
int[] leftRooms=new int[2];
for(int i=0;i<2;i++){ leftRooms[i]=roomNumber; roomNumber++; }
%>

<div class="side">
<% for(int i=1;i>=0;i--){ int rn=leftRooms[i]; %>
<div class="room">
<h4>Room <%=rn%></h4>
<div class="beds">
<% for(int b=0;b<3;b++){
String bed=(b==0)?"A":(b==1)?"B":"C";
String tip=tooltip[rn][b];
%>
<button disabled title="<%= tip==null?"Available":tip %>"
class="<%=booked[rn][b]?"booked":"free"%>"><%=bed%></button>
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
<% for(int b=0;b<3;b++){
String bed=(b==0)?"A":(b==1)?"B":"C";
String tip=tooltip[rn][b];
%>
<button disabled title="<%= tip==null?"Available":tip %>"
class="<%=booked[rn][b]?"booked":"free"%>"><%=bed%></button>
<% } %></div></div>
<% } %>
</div>

</div>
<% } %>
</div></div>
<% } %>

</div>
</div>
</body>
</html>
