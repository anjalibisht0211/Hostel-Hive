<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*" %>
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
String message = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String action = request.getParameter("action");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive","root","");

        Statement stmt = con.createStatement();

        /* ================= RENEW YEAR ================= */
        if ("renew".equals(action)) {

            stmt.executeUpdate("DELETE FROM bookings");
            stmt.executeUpdate("DELETE FROM complaints");
            stmt.executeUpdate("DELETE FROM room_swap_requests");

            int rows = stmt.executeUpdate(
                "UPDATE students SET hostel='Not Assigned', room='Not Booked'"
            );

            message = "✅ Academic Year Renewed! " + rows + " students reset.";
        }

        /* ================= ASSIGN HOSTEL ================= */
        else if ("assign".equals(action)) {

            String course = request.getParameter("course");
            String hostel = request.getParameter("hostel");

            if(course != null && hostel != null &&
               !course.isEmpty() && !hostel.isEmpty()) {

                PreparedStatement ps = con.prepareStatement(
                    "UPDATE students SET hostel=? WHERE course=?"
                );

                ps.setString(1, hostel);
                ps.setString(2, course);

                int rows = ps.executeUpdate();

                message = "✅ " + rows + " " + course +
                          " students assigned to " + hostel;

                ps.close();
            } else {
                message = "❌ Please select both course and hostel.";
            }
        }

        stmt.close();
        con.close();

    } catch(Exception e) {
        message = "❌ Error: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Academic Year Management</title>

<style>
body{font-family:system-ui;background:#f4f5ff;margin:0;}
.container{margin-left:260px;padding:20px;}
.sidebar{width:240px;background:#4e54c8;color:white;
min-height:100vh;padding:25px 15px;position:fixed;}
.nav a{margin:10px 0;display:block;text-decoration:none;
color:white;background:rgba(255,255,255,0.15);
padding:10px;border-radius:10px;}
.nav a:hover,.nav a.active{background:white;color:#4e54c8;}
.card{background:white;padding:25px;border-radius:10px;
box-shadow:0 3px 10px rgba(0,0,0,0.1);max-width:700px;}
.title{font-size:26px;color:#4e54c8;font-weight:700;}
.btn{padding:12px;border:none;border-radius:8px;
background:#4e54c8;color:white;font-weight:600;
cursor:pointer;margin-top:10px;width:100%;}
.danger{background:#e74c3c;}
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
<a href="admin-roomBookingControl.jsp"class="active">🛏️ Room Booking</a>
<a href="admin-warden.jsp" >👮 Warden</a>
<a href="admin_hostel.jsp" >🏢 Hostel</a>
<a href="adminlogin.jsp">🚪 Logout</a>
</div>
</div>

<div class="container">
<h1 class="title">Academic Year Reset</h1>

<div class="card">


<form method="post">

<h3>Renew Year (Complete Reset)</h3>
<button class="btn danger"
name="action" value="renew"
onclick="return confirm('This will reset all hostel & room data. Continue?')">
Renew Academic Year
</button>

<hr><br>

<h3>Select Course</h3>
<select name="course">
<option value="">-- Select Course --</option>
<option>BTech</option>
<option>MTech</option>
<option>MBA</option>
<option>BBA</option>
<option>Bcom</option>
<option>BSC</option>
</select>

<h3>Select Hostel</h3>
<select name="hostel">
<option value="">-- Select Hostel --</option>
<option>Bhuvnam</option>
<option>Vaasam</option>
<option>Nishantam</option>
<option>Aynam</option>
<option>Sadam</option>
<option>Uthjam</option>
<option>Puri</option>
</select>

<button class="btn"
name="action" value="assign">
Assign Hostel
</button>

</form>

<br>

<p style="font-weight:bold;"><%= message %></p>

</div>
</div>

</body>
</html>