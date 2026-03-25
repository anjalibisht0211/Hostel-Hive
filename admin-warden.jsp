
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>

<%!

public String generateUser(String name){
    return name.replaceAll(" ","").toLowerCase() + (int)(Math.random()*1000);
}

public String generatePass(){
    return "WH" + (int)(Math.random()*9999);
}

public boolean validName(String name){
    return name.matches("[A-Za-z ]+");
}

public boolean validPhone(String phone){
    return phone.matches("\\d{10}");
}

public boolean validEmail(String email){
    return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.(com|in|edu|org|net)$");
}

%>

<%

response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

if(session.getAttribute("admin_id")==null){
    response.sendRedirect("adminlogin.jsp");
    return;
}

Connection con=null;
String msg="";

String searchName=request.getParameter("searchName");
String hostelFilter=request.getParameter("hostelFilter");

try{

Class.forName("com.mysql.cj.jdbc.Driver");

con=DriverManager.getConnection(
"jdbc:mysql://localhost:3307/hostelhive","root","");

/* ===== ADD WARDEN ===== */

if(request.getParameter("addWarden")!=null){

String name=request.getParameter("warden_name");
String phone=request.getParameter("warden_no");
String email=request.getParameter("warden_email");
int hostelid=Integer.parseInt(request.getParameter("hostelid"));

if(!validName(name)){
msg="Invalid Name!";
}
else if(!validPhone(phone)){
msg="Phone must be 10 digits!";
}
else if(!validEmail(email)){
msg="Invalid Email domain!";
}
else{

String username=generateUser(name);
String password=generatePass();

PreparedStatement ps=con.prepareStatement(
"INSERT INTO wardens(warden_name,warden_no,warden_email,hostelid,username,password) VALUES(?,?,?,?,?,?)");

ps.setString(1,name);
ps.setString(2,phone);
ps.setString(3,email);
ps.setInt(4,hostelid);
ps.setString(5,username);
ps.setString(6,password);

ps.executeUpdate();

msg="Warden Added! Username: "+username+" | Password: "+password;

}

}

/* ===== UPDATE WARDEN ===== */

if(request.getParameter("updateWarden")!=null){

int id=Integer.parseInt(request.getParameter("warden_id"));
String name=request.getParameter("warden_name");
String phone=request.getParameter("warden_no");
String email=request.getParameter("warden_email");

PreparedStatement ps=con.prepareStatement(
"UPDATE wardens SET warden_name=?,warden_no=?,warden_email=? WHERE warden_id=?");

ps.setString(1,name);
ps.setString(2,phone);
ps.setString(3,email);
ps.setInt(4,id);

ps.executeUpdate();

msg="Warden Updated Successfully";

}

}catch(Exception e){
msg="Error : "+e.getMessage();
}

%>

<!DOCTYPE html>
<html>
<head>

<title>Admin Dashboard · Hostel Hive</title>

<style>

body{
font-family:"Segoe UI";
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
display:block;
margin:10px 0;
padding:10px;
background:rgba(255,255,255,0.15);
color:white;
text-decoration:none;
border-radius:10px;
}

.nav a:hover,.nav a.active{
background:white;
color:#4e54c8;
}

.container{
margin-left:260px;
padding:20px;
}

table{
width:100%;
background:white;
border-collapse:collapse;
box-shadow:0 3px 10px rgba(0,0,0,0.1);
}

th{
background:#4e54c8;
color:white;
padding:12px;
}

td{
padding:10px;
border-bottom:1px solid #ddd;
}

input,select{
padding:6px;
}

button{
background:#4e54c8;
color:white;
border:none;
padding:6px 12px;
border-radius:6px;
}

.searchbox{
background:white;
padding:10px;
margin-bottom:15px;
border-radius:8px;
}

.msg{
color:green;
font-weight:bold;
margin-bottom:10px;
}

</style>

</head>

<body>

<div class="sidebar">

<h2>HOSTEL HIVE</h2>

<div class="nav">

<a href="admindashboard.jsp">🏠 Dashboard</a>
<a href="admin-complaintStudent.jsp">📊 Complaints</a>
<a href="admin-registeredStudents.jsp">🧑‍🎓 Registered Students</a>
<a href="admin-registerStudent.jsp">➕ Register Student</a>
<a href="admin-roomBookingControl.jsp">🛏️ Room Booking</a>
<a href="admin-warden.jsp" class="active">👮 Warden</a>
<a href="admin_hostel.jsp" >🏢 Hostel</a>
<a href="adminlogin.jsp">🚪 Logout</a>

</div>

</div>

<div class="container">

<h1>Warden Management</h1>

<div class="msg"><%=msg%></div>

<h3>Add New Warden</h3>

<form method="post">

Name:
<input name="warden_name" required>

Phone:
<input name="warden_no" maxlength="10" required>

Email:
<input name="warden_email" required>

Hostel:

<select name="hostelid" required>

<option value="">Select Hostel</option>

<%

PreparedStatement psHostel=con.prepareStatement(
"SELECT hostel_id,hostel_name FROM hostel");

ResultSet rsHostel=psHostel.executeQuery();

while(rsHostel.next()){
%>

<option value="<%=rsHostel.getInt("hostel_id")%>">
<%=rsHostel.getString("hostel_name")%>
</option>

<%
}
%>

</select>

<button name="addWarden">Add Warden</button>

</form>

<br><br>
<h3>Registered Wardens</h3>
<div class="searchbox">

<form method="get">

Search Name:
<input type="text" name="searchName" value="<%=searchName==null?"":searchName%>">

Hostel:

<select name="hostelFilter">

<option value="">None Selected</option>
<option value="all">All Hostels</option>

<%

PreparedStatement psHostel2=con.prepareStatement(
"SELECT hostel_id,hostel_name FROM hostel");

ResultSet rsHostel2=psHostel2.executeQuery();

while(rsHostel2.next()){
%>

<option value="<%=rsHostel2.getInt("hostel_id")%>">
<%=rsHostel2.getString("hostel_name")%>
</option>

<%
}
%>

</select>

<button type="submit">Search</button>

</form>

</div>



<table>

<tr>
<th>ID</th>
<th>Name</th>
<th>Phone</th>
<th>Email</th>
<th>Hostel</th>
<th>Action</th>
</tr>

<%

if((searchName!=null && !searchName.trim().equals("")) || 
   (hostelFilter!=null && !hostelFilter.equals(""))){

String sql="SELECT w.warden_id,w.warden_name,w.warden_no,w.warden_email,h.hostel_name "+
"FROM wardens w LEFT JOIN hostel h ON w.hostelid=h.hostel_id WHERE 1=1 ";

if(hostelFilter!=null && !hostelFilter.equals("") && !hostelFilter.equals("all")){
sql+=" AND h.hostel_id=?";
}

if(searchName!=null && !searchName.trim().equals("")){
sql+=" AND w.warden_name LIKE ?";
}

PreparedStatement pst=con.prepareStatement(sql);

int index=1;

if(hostelFilter!=null && !hostelFilter.equals("") && !hostelFilter.equals("all")){
pst.setInt(index++,Integer.parseInt(hostelFilter));
}

if(searchName!=null && !searchName.trim().equals("")){
pst.setString(index,"%"+searchName+"%");
}

ResultSet rs=pst.executeQuery();

while(rs.next()){
%>

<form method="post">

<tr>

<td>

<%=rs.getInt("warden_id")%>

<input type="hidden" name="warden_id"
value="<%=rs.getInt("warden_id")%>">

</td>

<td>

<input name="warden_name"
value="<%=rs.getString("warden_name")%>">

</td>

<td>

<input name="warden_no"
value="<%=rs.getString("warden_no")%>"
maxlength="10">

</td>

<td>

<input name="warden_email"
value="<%=rs.getString("warden_email")%>">

</td>

<td>

<%=rs.getString("hostel_name")%>

</td>

<td>

<button name="updateWarden">Update</button>

</td>

</tr>

</form>

<%
}

}else{
%>

<tr>
<td colspan="6" style="text-align:center;">
Search by name or select hostel to view wardens
</td>
</tr>

<%
}

if(con!=null) con.close();

%>

</table>

</div>

</body>
</html>
