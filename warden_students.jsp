<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

if(session.getAttribute("warden_id")==null){
    response.sendRedirect("wardenlogin.jsp");
    return;
}

String hostelName = "";
Connection con = null;
PreparedStatement ps1 = null, ps = null;
ResultSet rs1 = null, rs = null;
%>

<!DOCTYPE html>
<html>
<head>
<title>Students</title>
<style>
body {
    font-family: Segoe UI;
    background: #f4f5ff;
    margin: 0;
}
.sidebar {
    width: 240px;
    background: #4e54c8;
    color: white;
    min-height: 100vh;
    padding: 25px 15px;
    position: fixed;
}
.nav a {
    margin: 10px 0;
    display: block;
    text-decoration: none;
    color: white;
    background: rgba(255,255,255,0.15);
    padding: 10px;
    border-radius: 10px;
}
.nav a:hover, .active {
    background: white;
    color: #4e54c8;
}
.container {
    margin-left: 260px;
    padding: 20px;
}
table {
    width: 100%;
    border-collapse: collapse;
    background: white;
}
th, td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
}
th {
    background: #4e54c8;
    color: white;
}
tr:hover {
    background-color: #f1f1ff;
}
input[type="text"] {
    width: 90%;
    padding: 5px;
}
</style>
</head>

<body>

<div class="sidebar">
<h2>HOSTEL HIVE</h2>
<div class="nav">
    <a href="wardendashboard.jsp">🏠 Dashboard</a>
    <a href="emptyBedsReport.jsp">🛏 Available Beds</a>
    <a href="warden_students.jsp" class="active">👨‍🎓 Students</a>
    <a href="warden_complaints.jsp">📢 Complaints</a>
    <a href="warden_availability.jsp">🛏 Rooms</a>
    <a href="wardenSwapRequests.jsp">🔁 Room Swap</a>
    <a href="logout.jsp">🚪 Logout</a>
</div>
</div>

<div class="container">
<h1>Students of Hostel</h1>

<table id="studentTable">
<tr>
<th>ID<br><input type="text" id="searchId" onkeyup="searchTable()"></th>
<th>Name<br><input type="text" id="searchName" onkeyup="searchTable()"></th>
<th>Email</th>
<th>Phone</th>
<th>Room<br><input type="text" id="searchRoom" onkeyup="searchTable()"></th>
</tr>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");

    int hostelId = (Integer) session.getAttribute("hostelid");

    ps1 = con.prepareStatement("SELECT hostel_name FROM hostel WHERE hostel_id=?");
    ps1.setInt(1, hostelId);
    rs1 = ps1.executeQuery();

    if(rs1.next()) hostelName = rs1.getString(1);

    ps = con.prepareStatement("SELECT * FROM students WHERE Hostel=?");
    ps.setString(1, hostelName);
    rs = ps.executeQuery();

    while(rs.next()){
        String room = rs.getString("room");
        if(room == null || room.trim().isEmpty()) room = "-";
%>

<tr>
<td><%= rs.getString("studentId") %></td>  <!-- FIXED HERE -->
<td><%= rs.getString("name") %></td>
<td><%= rs.getString("email") %></td>
<td><%= rs.getString("phone") %></td>
<td><%= room %></td>
</tr>

<%
    }
} catch(Exception e){
    out.println("<p style='color:red;'>Error: "+e.getMessage()+"</p>");
} finally {
    try {
        if(rs!=null) rs.close();
        if(rs1!=null) rs1.close();
        if(ps!=null) ps.close();
        if(ps1!=null) ps1.close();
        if(con!=null) con.close();
    } catch(Exception e){}
}
%>

</table>
</div>

<script>
function searchTable() {
    let id = document.getElementById("searchId").value.toLowerCase();
    let name = document.getElementById("searchName").value.toLowerCase();
    let room = document.getElementById("searchRoom").value.toLowerCase();

    let rows = document.querySelectorAll("#studentTable tr");

    for (let i = 1; i < rows.length; i++) {
        let cols = rows[i].getElementsByTagName("td");

        let match =
            cols[0].innerText.toLowerCase().includes(id) &&
            cols[1].innerText.toLowerCase().includes(name) &&
            cols[4].innerText.toLowerCase().includes(room);

        rows[i].style.display = match ? "" : "none";
    }
}
</script>

</body>
</html>