<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String selectedHostel = request.getParameter("hostel");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Complaints · Hostel Hive</title>

<style>
body { font-family: "Segoe UI"; background:#f4f5ff; margin:0; }
table { width:100%; border-collapse:collapse; margin-top:20px; }
th,td { padding:12px; text-align:center; border:1px solid #ddd; }
th { background:#4e54c8; color:white; }
tr:hover { background:#ececff; }

.container { margin-left:260px; padding:20px; }
.title { font-size:26px; color:#4e54c8; font-weight:700; }

.sidebar {
  width:240px; background:#4e54c8; color:white;
  min-height:100vh; padding:25px 15px; position:fixed;
}

.nav a {
  display:block; margin:10px 0; text-decoration:none;
  color:white; background:rgba(255,255,255,.15);
  padding:10px; border-radius:10px;
}
.nav a:hover, .nav a.active { background:white; color:#4e54c8; }

select {
  padding:8px; border-radius:6px;
  border:1px solid #ccc;
}
</style>
</head>

<body>

<!-- Sidebar -->
<div class="sidebar">
  <h2>HOSTEL HIVE</h2>
  <div class="nav">
    <a href="admin-complaintStudent.jsp" class="active">📊 Complaints</a>
    <a href="admin-registeredStudents.jsp">🧑‍🎓 Registered Students</a>
    <a href="admin-registerStudent.jsp">➕ Register Student</a>
    <a href="admin-roomBookingControl.jsp">🛏️ Room Booking</a>
    <a href="admin-warden.jsp">👮 Warden</a>
    <a href="user.html">🚪 Logout</a>
  </div>
</div>

<!-- Content -->
<div class="container">
  <h1 class="title">Complaints (Hostel Wise)</h1>

 <!-- Hostel Filter -->
<form method="get">
  <label><b>Select Hostel:</b></label>
  <select name="hostel" onchange="this.form.submit()">
    <option value="">All Hostels</option>

    <option value="Bhuvnam"   <%= "Bhuvnam".equals(selectedHostel)?"selected":"" %>>Bhuvnam</option>
    <option value="Vaasam"    <%= "Vaasam".equals(selectedHostel)?"selected":"" %>>Vaasam</option>
    <option value="Nishantam" <%= "Nishantam".equals(selectedHostel)?"selected":"" %>>Nishantam</option>
    <option value="Aynam"     <%= "Aynam".equals(selectedHostel)?"selected":"" %>>Aynam</option>
    <option value="Sadam"     <%= "Sadam".equals(selectedHostel)?"selected":"" %>>Sadam</option>
    <option value="Uthjam"    <%= "Uthjam".equals(selectedHostel)?"selected":"" %>>Uthjam</option>
    <option value="Puri"      <%= "Puri".equals(selectedHostel)?"selected":"" %>>Puri</option>
  </select>
</form>


  <table>
    <tr>
      <th>ID</th>
      <th>Student ID</th>
      <th>Name</th>
      <th>Hostel</th>
      <th>Complaint</th>
      <th>Date</th>
      <th>Status</th>
    </tr>

<%
String url="jdbc:mysql://localhost:3307/hostelhive";
String user="root";
String pass="";

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url,user,pass);

    String sql = "SELECT * FROM complaints";
    if(selectedHostel != null && !selectedHostel.isEmpty()){
        sql += " WHERE hostel_name=?";
    }

    PreparedStatement ps = con.prepareStatement(sql);

    if(selectedHostel != null && !selectedHostel.isEmpty()){
        ps.setString(1, selectedHostel);
    }

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>
    <tr>
      <td><%=rs.getInt("complaint_id")%></td>
      <td><%=rs.getInt("student_id")%></td>
      <td><%=rs.getString("student_name")%></td>
      <td><%=rs.getString("hostel_name")%></td>
      <td><%=rs.getString("complaint")%></td>
      <td><%=rs.getDate("complaint_date")%></td>
      <td><%=rs.getString("status")%></td>
    </tr>
<%
    }
    con.close();
}catch(Exception e){
%>
<tr>
  <td colspan="7">Error: <%=e.getMessage()%></td>
</tr>
<%
}
%>

  </table>
</div>

</body>
</html>
