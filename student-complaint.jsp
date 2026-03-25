
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
/* ================= SESSION CHECK ================= */
Integer studentId = (Integer) session.getAttribute("student_id");

if(studentId == null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

/* ================= FETCH STUDENT FROM DB ================= */
String studentName = "";
String hostelName = "";

try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/hostelhive","root",""
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT username, Hostel FROM students WHERE id=?"
    );

    ps.setInt(1, studentId);

    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        studentName = rs.getString("username");
        hostelName = rs.getString("Hostel");
    }

    con.close();

}catch(Exception e){
    out.println("DB Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>

<head>

<title>Register Complaint</title>

<style>

body{
margin:0;
height:100vh;

/* SAME BACKGROUND AS OTHER PAGES */
background:linear-gradient(120deg,#4B0082,#2E0854);

display:flex;
justify-content:center;
align-items:center;

font-family:'Segoe UI';
color:white;
}

.card{

background:rgba(255,255,255,0.12);

width:360px;
padding:30px;

border-radius:18px;

box-shadow:0 8px 25px rgba(0,0,0,0.35);

color:white;

backdrop-filter:blur(6px);

}

h2{
text-align:center;
margin-bottom:20px;
color:#FFD700;
}

.infoBox{

background:white;

color:#2E0854;

padding:12px;

border-radius:10px;

margin-bottom:15px;

font-size:14px;

}

input,select,textarea{

width:100%;

padding:10px;

margin:8px 0;

border:none;

border-radius:8px;

font-size:14px;

}

textarea{
resize:none;
height:70px;
}

.btn{

width:100%;

padding:12px;

background:#FFD700;

border:none;

border-radius:10px;

font-weight:bold;

cursor:pointer;

color:#2E0854;

margin-top:10px;

transition:0.3s;

}

.btn:hover{

background:white;
color:#4B0082;

}

.topBar{

position:absolute;

top:20px;

left:20px;

right:20px;

display:flex;

justify-content:space-between;

}

.topBtn{

background:white;

color:#4B0082;

padding:8px 18px;

border-radius:8px;

text-decoration:none;

font-weight:bold;

box-shadow:0 3px 8px rgba(0,0,0,0.2);

}

.topBtn.logout{

background:#ff4d4d;

color:white;

}

</style>

</head>

<body>

<div class="topBar">
<a href="student_dash.jsp" class="topBtn">&#8592; Back</a>
</div>

<%
/* ================= INSERT COMPLAINT ================= */

if("POST".equalsIgnoreCase(request.getMethod())){

String complaint = request.getParameter("complaint");

String description = request.getParameter("description");

if(description == null || description.trim().equals(""))
description = null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3307/hostelhive","root",""
);

PreparedStatement ps = con.prepareStatement(

"INSERT INTO complaints " +
"(student_id, student_name, hostel_name, complaint, complaint_date, description, status) " +
"VALUES (?, ?, ?, ?, CURDATE(), ?, 'Pending')"

);

ps.setInt(1, studentId);
ps.setString(2, studentName);
ps.setString(3, hostelName);
ps.setString(4, complaint);
ps.setString(5, description);

ps.executeUpdate();

con.close();
%>

<script>

alert("Complaint Submitted Successfully!");

window.location="student_dash.jsp";

</script>

<%
return;

}catch(Exception e){

out.println(e.getMessage());

}

}
%>

<div class="card">

<h2>Register Complaint</h2>

<div class="infoBox">

<b>ID:</b> <%= studentId %><br>
<b>Name:</b> <%= studentName %><br>
<b>Hostel:</b> <%= hostelName %>

</div>

<form method="post">

<label>Complaint Type</label>

<select name="complaint" required>

<option value="">Select</option>

<option>Electricity Issue</option>
<option>Water Supply Issue</option>
<option>Room Cleaning Issue</option>
<option>Internet Issue</option>
<option>Furniture Issue</option>
<option>Other Issue</option>

</select>

<label>Description</label>

<textarea name="description"></textarea>

<button type="submit" class="btn">
Submit Complaint
</button>

</form>

</div>

</body>
</html>
