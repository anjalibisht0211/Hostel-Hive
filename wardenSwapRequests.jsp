<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");
con=DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");

/* ==============================
   HANDLE APPROVE / REJECT
============================== */

String reqIdParam=request.getParameter("reqId");
String action=request.getParameter("action");

if(reqIdParam!=null && action!=null){

int reqId=Integer.parseInt(reqIdParam);

PreparedStatement psReq=con.prepareStatement(
"SELECT r.*, s1.name AS requester_name, s2.name AS target_name,"+
"s1.room AS requester_room_curr, s2.room AS target_room_curr,"+
"s1.hostel AS hostel_name, s1.id AS s1_id, s2.id AS s2_id "+
"FROM room_swap_requests r "+
"JOIN students s1 ON r.requester_id=s1.id "+
"LEFT JOIN students s2 ON r.target_student_id=s2.id "+
"WHERE r.id=?");

psReq.setInt(1,reqId);
ResultSet rsReq=psReq.executeQuery();

if(rsReq.next()){

String type=rsReq.getString("request_type");
String status=rsReq.getString("status");
String hostelName=rsReq.getString("hostel_name");

int s1=rsReq.getInt("s1_id");
int s2=rsReq.getInt("s2_id");

/* Only process if waiting for warden */

if(!"waiting_warden".equalsIgnoreCase(status)){
response.sendRedirect("wardenSwapRequests.jsp");
return;
}

/* ==============================
   APPROVE REQUEST
============================== */

if("approve".equalsIgnoreCase(action)){

/* BED CHANGE */

if("bed_change".equalsIgnoreCase(type)){

String newRoom=rsReq.getString("target_room");

String roomNumStr=newRoom.replaceAll("[^0-9]","");
String bedLetter=newRoom.replaceAll("[0-9]","");

int roomNum=Integer.parseInt(roomNumStr);

/* Check if bed free */

PreparedStatement check=con.prepareStatement(
"SELECT * FROM bookings WHERE hostel_name=? AND room_number=? AND bed=?");

check.setString(1,hostelName);
check.setInt(2,roomNum);
check.setString(3,bedLetter);

ResultSet bedRs=check.executeQuery();

if(!bedRs.next()){

con.setAutoCommit(false);

/* Delete old booking */

PreparedStatement del=con.prepareStatement(
"DELETE FROM bookings WHERE student_id=? AND hostel_name=?");

del.setInt(1,s1);
del.setString(2,hostelName);
del.executeUpdate();

/* Insert new booking */

PreparedStatement insert=con.prepareStatement(
"INSERT INTO bookings(student_id,hostel_name,room_number,bed) VALUES(?,?,?,?)");

insert.setInt(1,s1);
insert.setString(2,hostelName);
insert.setInt(3,roomNum);
insert.setString(4,bedLetter);
insert.executeUpdate();

/* Update student room */

PreparedStatement updStudent=con.prepareStatement(
"UPDATE students SET room=? WHERE id=?");

updStudent.setString(1,newRoom);
updStudent.setInt(2,s1);
updStudent.executeUpdate();

/* Update request */

PreparedStatement updReq=con.prepareStatement(
"UPDATE room_swap_requests SET status='approved' WHERE id=?");

updReq.setInt(1,reqId);
updReq.executeUpdate();

con.commit();
con.setAutoCommit(true);

}
}

/* STUDENT SWAP */

if("student_swap".equalsIgnoreCase(type) && s2>0){

String room1=rsReq.getString("requester_room_curr");
String room2=rsReq.getString("target_room_curr");

String room1Num=room1.replaceAll("[^0-9]","");
String bed1=room1.replaceAll("[0-9]","");

String room2Num=room2.replaceAll("[^0-9]","");
String bed2=room2.replaceAll("[0-9]","");

con.setAutoCommit(false);

/* Temporary move */

PreparedStatement temp=con.prepareStatement(
"UPDATE bookings SET room_number=9999,bed='X' WHERE student_id=? AND hostel_name=?");

temp.setInt(1,s1);
temp.setString(2,hostelName);
temp.executeUpdate();

/* Move student 2 */

PreparedStatement updB2=con.prepareStatement(
"UPDATE bookings SET room_number=?,bed=? WHERE student_id=? AND hostel_name=?");

updB2.setInt(1,Integer.parseInt(room1Num));
updB2.setString(2,bed1);
updB2.setInt(3,s2);
updB2.setString(4,hostelName);
updB2.executeUpdate();

/* Move student 1 */

PreparedStatement updB1=con.prepareStatement(
"UPDATE bookings SET room_number=?,bed=? WHERE student_id=? AND hostel_name=?");

updB1.setInt(1,Integer.parseInt(room2Num));
updB1.setString(2,bed2);
updB1.setInt(3,s1);
updB1.setString(4,hostelName);
updB1.executeUpdate();

/* Update students */

PreparedStatement updS1=con.prepareStatement(
"UPDATE students SET room=? WHERE id=?");

updS1.setString(1,room2);
updS1.setInt(2,s1);
updS1.executeUpdate();

PreparedStatement updS2=con.prepareStatement(
"UPDATE students SET room=? WHERE id=?");

updS2.setString(1,room1);
updS2.setInt(2,s2);
updS2.executeUpdate();

/* Update request */

PreparedStatement updReq=con.prepareStatement(
"UPDATE room_swap_requests SET status='approved' WHERE id=?");

updReq.setInt(1,reqId);
updReq.executeUpdate();

con.commit();
con.setAutoCommit(true);

}

}

/* ==============================
   REJECT REQUEST
============================== */

else if("reject".equalsIgnoreCase(action)){

PreparedStatement upd=con.prepareStatement(
"UPDATE room_swap_requests SET status='rejected' WHERE id=?");

upd.setInt(1,reqId);
upd.executeUpdate();

}

response.sendRedirect("wardenSwapRequests.jsp");
return;

}

}

}catch(Exception e){
out.println("Error : "+e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Warden Room Swap</title>

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
padding:20px;
}

table{
width:100%;
border-collapse:collapse;
background:white;
}

th,td{
padding:12px;
border-bottom:1px solid #ddd;
text-align:left;
}

th{
background:#4e54c8;
color:white;
}

.btn{
padding:6px 12px;
border:none;
border-radius:6px;
color:white;
cursor:pointer;
}

.approve{background:#28a745;}
.reject{background:#f44336;}

</style>
</head>

<body>

<div class="sidebar">

<h2>HOSTEL HIVE</h2>

<div class="nav">

<a href="wardendashboard.jsp">🏠 Dashboard</a>
<a href="emptyBedsReport.jsp">🛏 Available Beds Report</a>
<a href="warden_students.jsp">👨‍🎓 Students</a>
<a href="warden_complaints.jsp">📢 Complaints</a>
<a href="warden_availability.jsp">🛏 Rooms</a>
<a href="wardenSwapRequests.jsp" class="active">🔁 Room Swap</a>
<a href="wardenlogin.jsp">🚪 Logout</a>

</div>
</div>

<div class="container">

<h1>Room Swap Requests</h1>

<table>

<tr>
<th>ID</th>
<th>Requester</th>
<th>Target</th>
<th>From</th>
<th>To</th>
<th>Type</th>
<th>Status</th>
<th>Action</th>
</tr>

<%
ps=con.prepareStatement(
"SELECT r.*, s1.name AS requester_name, s2.name AS target_name "+
"FROM room_swap_requests r "+
"JOIN students s1 ON r.requester_id=s1.id "+
"LEFT JOIN students s2 ON r.target_student_id=s2.id "+
"ORDER BY r.created_at DESC");

rs=ps.executeQuery();

while(rs.next()){
%>

<tr>

<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("requester_name")%></td>
<td><%=rs.getString("target_name")%></td>
<td><%=rs.getString("requester_room")%></td>
<td><%=rs.getString("target_room")%></td>
<td><%=rs.getString("request_type")%></td>
<td><%=rs.getString("status")%></td>

<td>

<% if("waiting_warden".equalsIgnoreCase(rs.getString("status"))){ %>

<form method="post" style="display:inline">

<input type="hidden" name="reqId" value="<%=rs.getInt("id")%>">
<input type="hidden" name="action" value="approve">

<button class="btn approve">Approve</button>

</form>

<form method="post" style="display:inline">

<input type="hidden" name="reqId" value="<%=rs.getInt("id")%>">
<input type="hidden" name="action" value="reject">

<button class="btn reject">Reject</button>

</form>

<% } else { %>

--

<% } %>

</td>
</tr>

<% } %>

</table>

</div>

</body>
</html>