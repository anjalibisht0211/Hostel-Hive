<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
String selectedHostel = request.getParameter("hostel");
String searchName = request.getParameter("search");

if (selectedHostel == null) selectedHostel = "";
if (searchName == null) searchName = "";
%>

<!DOCTYPE html>
<html>
<head>
<title>Registered Students | Hostel Hive</title>
<meta charset="UTF-8">

<style>
/* ===== GLOBAL ===== */
body{
    font-family: Arial, sans-serif;
    background:#f4f6ff;
    margin:0;
}

/* ===== SIDEBAR ===== */
.sidebar {
    position: fixed;
    left: 0;
    top: 0;
    width: 230px;
    height: 100vh;
    background: #4f56c1;

    display: flex;
    flex-direction: column;
    padding: 20px 0;
}

.sidebar h2 {
    color: white;
    text-align: center;
    margin-bottom: 25px;
}

.sidebar a {
    display: block;
    padding: 14px 20px;
    color: white;
    text-decoration: none;
    font-size: 15px;
    border-radius: 8px;
    margin: 6px 12px;
}

.sidebar a:hover {
    background: rgba(255,255,255,0.2);
}

.sidebar a.active {
    background: white;
    color: #4f56c1;
    font-weight: bold;
}

/* 🔒 LOGOUT FIXED AT BOTTOM */
.sidebar .logout {
    margin-top: auto;
    margin-bottom: 20px;
}

/* ===== MAIN CONTENT ===== */
.main-content{
    margin-left: 250px;
    padding: 30px;
}

h2{
    color:#4e54c8;
}

/* ===== FILTER ===== */
.filter-box{
    display:flex;
    gap:15px;
    margin-bottom:20px;
}

select,input,button{
    padding:10px;
    border-radius:8px;
    border:1px solid #ccc;
    font-size:1rem;
}

button{
    background:#4e54c8;
    color:white;
    cursor:pointer;
}

/* ===== TABLE ===== */
table{
    width:100%;
    border-collapse:collapse;
    background:white;
}

th{
    background:#4e54c8;
    color:white;
    padding:12px;
}

td{
    padding:10px;
    border-bottom:1px solid #ddd;
    text-align:center;
}

tr:hover{
    background:#f0f2ff;
}
</style>
</head>

<body>

<!-- ===== SIDEBAR ===== -->
<div class="sidebar">
    <h2>HOSTEL HIVE</h2>

    <a href="admin-complaintStudent.jsp">📊 Complaints</a>
    <a href="admin-registeredStudents.jsp" class="active">🧑‍🎓 Registered Students</a>
    <a href="admin-registerStudent.jsp">➕ Register Student</a>
    <a href="admin-roomBookingControl.jsp">🛏️ Room Booking</a>
    <a href="admin-warden.jsp">👮 Warden</a>
    <a href="user.html" class="logout">🚪 Logout</a>
</div>

<!-- ===== MAIN CONTENT ===== -->
<div class="main-content">

<h2>Registered Students</h2>

<!-- FILTER -->
<form method="get">
<div class="filter-box">

    <select name="hostel" onchange="this.form.submit()">
        <option value="">-- Select Hostel --</option>
        <option value="Bhuvnam" <%= "Bhuvnam".equals(selectedHostel)?"selected":"" %>>Bhuvnam</option>
        <option value="Vaasam" <%= "Vaasam".equals(selectedHostel)?"selected":"" %>>Vaasam</option>
        <option value="Nishantam" <%= "Nishantam".equals(selectedHostel)?"selected":"" %>>Nishantam</option>
        <option value="Aynam" <%= "Aynam".equals(selectedHostel)?"selected":"" %>>Aynam</option>
        <option value="SADAM" <%= "SADAM".equals(selectedHostel)?"selected":"" %>>SADAM</option>
        <option value="Uthjam" <%= "Uthjam".equals(selectedHostel)?"selected":"" %>>Uthjam</option>
        <option value="Puri" <%= "Puri".equals(selectedHostel)?"selected":"" %>>Puri</option>
    </select>

    <input type="text" name="search"
           placeholder="Search student name"
           value="<%=searchName%>"/>

    <button type="submit">Search</button>
</div>
</form>

<!-- STUDENT TABLE -->
<table>
<tr>
    <th>Name</th>
    <th>Email</th>
    <th>Student ID</th>
    <th>Hostel</th>
    <th>Room</th>
    <th>Username</th>
    <th>Mobile</th>
    <th>Gender</th>
</tr>

<%
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3307/hostelhive","root","");

String sql = "SELECT * FROM students WHERE 1=1";

if(!selectedHostel.isEmpty()){
    sql += " AND hostel=?";
}
if(!searchName.isEmpty()){
    sql += " AND name LIKE ?";
}

PreparedStatement ps = con.prepareStatement(sql);

int i=1;
if(!selectedHostel.isEmpty()){
    ps.setString(i++, selectedHostel);
}
if(!searchName.isEmpty()){
    ps.setString(i++, "%"+searchName+"%");
}

ResultSet rs = ps.executeQuery();
boolean found=false;

while(rs.next()){
    found=true;
%>
<tr>
    <td><%=rs.getString("name")%></td>
    <td><%=rs.getString("email")%></td>
    <td><%=rs.getInt("studentId")%></td>
    <td><%=rs.getString("hostel")%></td>
    <td><%=rs.getString("room")%></td>
    <td><%=rs.getString("username")%></td>
    <td><%=rs.getString("phone")%></td>
    <td><%=rs.getString("gender")%></td>
</tr>
<%
}

if(!found){
%>
<tr>
    <td colspan="8">No students found</td>
</tr>
<%
}

rs.close();
ps.close();
con.close();
%>

</table>

</div>
</body>
</html>
