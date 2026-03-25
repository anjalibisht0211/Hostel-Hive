
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>

<%!

/* ===== STUDENT ID GENERATOR ===== */
String generateStudentId(String course){

    String prefix = course.substring(0,2).toUpperCase();
    int random = 100000 + (int)(Math.random()*900000);

    return prefix + random;
}

/* ===== USERNAME GENERATOR ===== */
String generateUsername(String name){

    String base = name.replaceAll(" ","").toLowerCase();
    int random = (int)(Math.random()*1000);

    return base + random;
}

/* ===== PASSWORD GENERATOR ===== */
String generatePassword(){

    int random = 1000 + (int)(Math.random()*9000);
    return "HH" + random;
}

%>


<%

/* ===== PREVENT BACK BUTTON CACHE ===== */

response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);


/* ===== INSERT STUDENT ===== */

if("POST".equalsIgnoreCase(request.getMethod())){

String name = request.getParameter("name");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String gender = request.getParameter("gender");
String course = request.getParameter("course");

String error="";


/* ===== NAME VALIDATION ===== */

if(!name.matches("[A-Za-z ]+")){
    error="Name should contain only alphabets.";
}

/* ===== EMAIL VALIDATION ===== */

else if(!email.matches("^[A-Za-z0-9+_.-]+@(gmail|yahoo|outlook|hotmail|icloud)\\.com$")){
    error="Email must end with @gmail.com, @yahoo.com etc.";
}

/* ===== PHONE VALIDATION ===== */

else if(!phone.matches("\\d{10}")){
    error="Phone must be exactly 10 digits.";
}


if(error.equals("")){

String studentId = generateStudentId(course);
String username = generateUsername(name);
String password = generatePassword();


/* ===== HOSTEL AUTO ASSIGN ===== */

String hostel="";

if("BTech".equals(course)){
    hostel="Bhuvnam";
}
else if("MTech".equals(course)){
    hostel="Vaasam";
}
else if("MBA".equals(course)){
    hostel="Nishantam";
}
else if("BBA".equals(course)){
    hostel="Puri";
}
else if("BSC".equals(course)){
    hostel="SADAM";
}
else if("Bcom".equals(course)){
    hostel="Uthjam";
}


try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3307/hostelhive",
"root",""
);

PreparedStatement ps = con.prepareStatement(

"INSERT INTO students "+
"(name,email,studentId,username,password,phone,gender,course,hostel) "+
"VALUES (?,?,?,?,?,?,?,?,?)"

);

ps.setString(1,name);
ps.setString(2,email);
ps.setString(3,studentId);
ps.setString(4,username);
ps.setString(5,password);
ps.setString(6,phone);
ps.setString(7,gender);
ps.setString(8,course);
ps.setString(9,hostel);

ps.executeUpdate();
con.close();

%>

<script>

alert("Student Registered Successfully\n\nStudent ID: <%=studentId%>\nUsername: <%=username%>\nPassword: <%=password%>");

window.location.href="admin-registeredStudents.jsp";

</script>

<%

return;

}catch(Exception e){
out.println("<script>alert('Error: "+e.getMessage()+"');</script>");
}

}else{

out.println("<script>alert('"+error+"');</script>");

}

}

%>



<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Register Student · Hostel Hive</title>

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
margin:10px 0;
display:block;
text-decoration:none;
color:white;
background:rgba(255,255,255,0.15);
padding:10px;
border-radius:10px;
}

.nav a.active,.nav a:hover{
background:white;
color:#4e54c8;
}

.container{
margin-left:260px;
padding:25px;
}

.form-box{
background:white;
max-width:600px;
padding:25px;
border-radius:12px;
box-shadow:0 3px 10px rgba(0,0,0,0.1);
}

h1{
color:#4e54c8;
}

label{
font-weight:600;
margin-top:12px;
display:block;
}

input,select{
width:100%;
padding:10px;
margin-top:6px;
border-radius:8px;
border:1px solid #ccc;
}

button{
margin-top:20px;
padding:12px;
background:#4e54c8;
color:white;
border:none;
border-radius:8px;
font-size:16px;
cursor:pointer;
}

button:hover{
background:#3b40a4;
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
<a href="admin-registerStudent.jsp" class="active">➕ Register Student</a>
<a href="admin-roomBookingControl.jsp">🛏️ Room Booking</a>
<a href="admin-warden.jsp">👮 Warden</a>
<a href="admin_hostel.jsp" >🏢 Hostel</a>
<a href="adminlogin.jsp">🚪 Logout</a>

</div>

</div>


<div class="container">

<h1>Register New Student</h1>

<div class="form-box">

<form method="post">

<label>Full Name</label>
<input type="text" name="name" pattern="[A-Za-z ]+" title="Only alphabets allowed" required>


<label>Email</label>
<input type="email" name="email" required>


<label>Phone</label>
<input type="text" name="phone" maxlength="10" pattern="\d{10}" required title="Enter 10 digit number">


<label>Gender</label>

<select name="gender" required>
<option value="">Select</option>
<option>Male</option>
<option>Female</option>
</select>


<label>Course</label>

<select name="course" required>
<option value="">Select Course</option>
<option>BTech</option>
<option>MTech</option>
<option>MBA</option>
<option>BBA</option>
<option>BSC</option>
<option>Bcom</option>
</select>


<button type="submit">Register Student</button>

</form>

</div>

</div>

</body>
</html>
