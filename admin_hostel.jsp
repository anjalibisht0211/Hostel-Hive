<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>

<%
/* ===== PREVENT CACHE ===== */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

/* ===== SESSION CHECK ===== */
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("adminlogin.jsp");
    return;
}

/* ===== PARAMETERS ===== */
String selectedHostel = request.getParameter("hostel");
if(selectedHostel == null) selectedHostel = "none";

/* ===== VARIABLES ===== */
String hostelName = "";
boolean[][] booked = new boolean[91][3];
String[][] tooltip = new String[91][3];

Connection con = null;
PreparedStatement pstHostels = null;
ResultSet rsHostels = null;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");

    // Fetch hostels for dropdown
    pstHostels = con.prepareStatement("SELECT DISTINCT hostel_name FROM hostel");
    rsHostels = pstHostels.executeQuery();

    // If a hostel is selected, load bookings
    if(!"none".equals(selectedHostel)){
        hostelName = selectedHostel;

        PreparedStatement psBookings = con.prepareStatement(
            "SELECT b.room_number,b.bed,s.name,s.studentId,s.phone " +
            "FROM bookings b JOIN students s ON b.student_id=s.id " +
            "WHERE b.hostel_name=?"
        );
        psBookings.setString(1,hostelName);
        ResultSet rsBookings = psBookings.executeQuery();

        while(rsBookings.next()){
            int r = rsBookings.getInt("room_number");
            String b = rsBookings.getString("bed");

            String info = "Name: "+rsBookings.getString("name")+
                          " | ID: "+rsBookings.getString("studentId")+
                          " | Phone: "+rsBookings.getString("phone")+
                          " | Room "+r+"-"+b;

            if("A".equals(b)){ booked[r][0]=true; tooltip[r][0]=info; }
            if("B".equals(b)){ booked[r][1]=true; tooltip[r][1]=info; }
            if("C".equals(b)){ booked[r][2]=true; tooltip[r][2]=info; }
        }
        rsBookings.close();
        psBookings.close();
    }

}catch(Exception e){ out.println("<p style='color:red'>"+e+"</p>"); }
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Hostel Occupancy | Hostel Hive</title>
<style>
body{margin:0;font-family:Segoe UI;background:#f4f5ff;}
.sidebar{width:240px;background:#4e54c8;color:white;min-height:100vh;padding:25px 15px;position:fixed;}
.nav a{margin:10px 0;display:block;text-decoration:none;color:white;background:rgba(255,255,255,0.15);padding:10px;border-radius:10px;}
.nav a:hover,.active{background:white;color:#4e54c8;}
.container{margin-left:260px;padding:20px;}
.roomContainer{background:white;padding:25px;border-radius:20px;box-shadow:0 5px 20px rgba(0,0,0,0.1); margin-bottom:40px;}
.floor h2{color:#4e54c8;}
.floor{margin-bottom:60px;}
.floor-row{display:flex;justify-content:space-between;gap:40px;}
.block{width:48%;}
.top-row{display:grid;grid-template-columns:repeat(5,1fr);gap:10px;}
.bottom-row{display:grid;grid-template-columns:repeat(6,1fr);gap:10px;}
.middle{display:flex;justify-content:space-between;margin:10px 0;}
.side{display:grid;gap:10px;}
.room{background:#f7f8ff;padding:8px;border-radius:12px;text-align:center;font-size:12px;border:1px solid #e0e3ff;}
.room h4{margin:3px;color:#4e54c8;font-size:13px;}
.beds button{margin:3px;padding:5px 8px;font-size:11px;border:none;border-radius:6px;cursor:pointer;}
.booked{background:#e53935;color:white;}
.free{background:#00c853;color:white;}
.courtyard{width:48%;height:130px;background:#eef0ff;border:2px dashed #4e54c8;border-radius:18px;display:flex;justify-content:center;align-items:center;flex-direction:column;color:#4e54c8;font-weight:bold;}
label{font-weight:bold;margin-right:10px;}
select{padding:5px;margin-bottom:20px;}
.hostelTitle{font-size:22px;color:#4e54c8;margin-bottom:15px;font-weight:bold;}
</style>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
<h2>HOSTEL HIVE</h2>
<div class="nav">
<a href="admindashboard.jsp">🏠 Dashboard</a>
<a href="admin-complaintStudent.jsp">📊 Complaints</a>
<a href="admin-registeredStudents.jsp">🧑‍🎓 Students</a>
<a href="admin-registerStudent.jsp">➕ Register Student</a>
<a href="admin-roomBookingControl.jsp">🛏️ Bookings</a>
<a href="admin-warden.jsp">👮 Warden</a>
<a href="admin_hostel.jsp" class="active">🏢 Hostel</a>
<a href="adminlogin.jsp">🚪 Logout</a>
</div>
</div>

<div class="container">
<h1>Hostel Room Occupancy</h1>

<form method="get" action="admin_hostel.jsp">
<label for="hostel">Select Hostel:</label>
<select name="hostel" id="hostel" onchange="this.form.submit()">
<option value="none" <%= "none".equals(selectedHostel)?"selected":"" %>>None (Overall)</option>
<%
while(rsHostels.next()){
    String hname = rsHostels.getString("hostel_name");
%>
<option value="<%=hname%>" <%= hname.equals(selectedHostel)?"selected":"" %>><%=hname%></option>
<% } 
rsHostels.close(); pstHostels.close(); con.close(); %>
</select>
</form>

<% if(!"none".equals(selectedHostel)) { %>
<p class="hostelTitle">Hostel: <%=hostelName.toUpperCase()%></p>
<p>Hover on booked bed to see student details</p>
🟢 Available | 🔴 Booked
<%
int roomNumber = 1;
for(int floor = 1; floor <= 3; floor++) { 
%>
<div class="roomContainer">
<div class="floor">
<h2><%= (floor==1)?"Ground Floor":(floor==2)?"First Floor":"Second Floor" %></h2>
<div class="floor-row">

<% for(int block=1; block<=2; block++) { %>
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
<button disabled title="<%= tip==null?"Available":tip %>" class="<%=booked[roomNumber][b]?"booked":"free"%>"><%=bed%></button>
<% } %>
</div>
</div>
<% roomNumber++; } %>
</div> <!-- end top-row -->

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
<button disabled title="<%= tip==null?"Available":tip %>" class="<%=booked[roomNumber][b]?"booked":"free"%>"><%=bed%></button>
<% } %>
</div>
</div>
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
<button disabled title="<%= tip==null?"Available":tip %>" class="<%=booked[rn][b]?"booked":"free"%>"><%=bed%></button>
<% } %>
</div>
</div>
<% } %>
</div>

</div> <!-- end middle -->

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
<button disabled title="<%= tip==null?"Available":tip %>" class="<%=booked[rn][b]?"booked":"free"%>"><%=bed%></button>
<% } %>
</div>
</div>
<% } %>
</div> <!-- end bottom-row -->

</div> <!-- end block -->
<% } %> <!-- end block loop -->
</div> <!-- end floor-row -->
</div> <!-- end floor -->
</div> <!-- end roomContainer -->
<% } } %>

</div>
</body>
</html>