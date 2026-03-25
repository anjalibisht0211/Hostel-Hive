<%@page import="java.sql.*"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>

<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

if(session.getAttribute("admin_id")==null){
    response.sendRedirect("adminlogin.jsp");
    return;
}

/* ===== FILTER PARAMETERS ===== */
String selectedHostel=request.getParameter("hostel");
String selectedComplaint=request.getParameter("complaint");
String selectedDate=request.getParameter("date");
String selectedStudentName=request.getParameter("studentname");
String selectedStudentId=request.getParameter("studentid");
String selectedStatus=request.getParameter("status");
String globalSearch=request.getParameter("searchall");
String viewOption=request.getParameter("view");

if(selectedHostel==null) selectedHostel="";
if(selectedComplaint==null) selectedComplaint="";
if(selectedDate==null) selectedDate="";
if(selectedStudentName==null) selectedStudentName="";
if(selectedStudentId==null) selectedStudentId="";
if(selectedStatus==null) selectedStatus="";
if(globalSearch==null) globalSearch="";
if(viewOption==null) viewOption="";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Complaints · Hostel Hive</title>
<style>
body{font-family:"Segoe UI"; background:#f4f5ff; margin:0;}
.sidebar{width:240px; background:#4e54c8; color:white; min-height:100vh; padding:25px 15px; position:fixed;}
.nav a{display:block; margin:10px 0; text-decoration:none; color:white; background:rgba(255,255,255,.15); padding:10px; border-radius:10px;}
.nav a:hover,.nav a.active{background:white;color:#4e54c8;}
.container{margin-left:260px; padding:20px;}
.title{font-size:26px;color:#4e54c8;font-weight:700;}
.searchBox{margin-bottom:15px;}
table{width:100%;border-collapse:collapse;margin-top:20px;background:white;}
th,td{padding:12px;text-align:center;border:1px solid #ddd;}
th{background:#4e54c8;color:white;}
tr:hover{background:#ececff;}
select,input{padding:6px;border-radius:6px;border:none;font-weight:600;}
button{padding:6px 10px; border:none; border-radius:6px; background:#4e54c8; color:white; cursor:pointer; font-weight:600;}
button:hover{background:#3b40a0;}
</style>
</head>
<body>

<div class="sidebar">
<h2>HOSTEL HIVE</h2>
<div class="nav">
<a href="admindashboard.jsp">🏠 Dashboard</a>
<a href="admin-complaintStudent.jsp" class="active">📊 Complaints</a>
<a href="admin-registeredStudents.jsp">🧑‍🎓 Registered Students</a>
<a href="admin-registerStudent.jsp">➕ Register Student</a>
<a href="admin-roomBookingControl.jsp">🛏️ Room Booking</a>
<a href="admin-warden.jsp">👮 Warden</a>
<a href="admin_hostel.jsp" >🏢 Hostel</a>
<a href="adminlogin.jsp">🚪 Logout</a>
</div>
</div>

<div class="container">

<h1 class="title">Complaints</h1>

<form method="get" id="filterForm">

<div class="searchBox">
Global Search :
<input type="text" name="searchall" placeholder="Search anything..." value="<%=globalSearch%>" onchange="filterForm.submit()">
&nbsp;&nbsp;
Show :
<select name="view" onchange="filterForm.submit()">
<option value="">None</option>
<option value="all" <%= "all".equals(viewOption)?"selected":"" %>>All Records</option>
</select>
&nbsp;&nbsp;
<button type="button" onclick="clearFilters()">Clear Filters</button>
</div>

<table>
<tr>
<th>STUDENT ID<br>
<input type="number" name="studentid" value="<%=selectedStudentId%>" onchange="filterForm.submit()">
</th>
<th>Name<br>
<input type="text" name="studentname" value="<%=selectedStudentName%>" onchange="filterForm.submit()">
</th>
<th>Hostel<br>
<select name="hostel" onchange="filterForm.submit()">
<option value="">None</option>
<option value="Bhuvnam" <%=selectedHostel.equals("Bhuvnam")?"selected":""%>>Bhuvnam</option>
<option value="Vaasam" <%=selectedHostel.equals("Vaasam")?"selected":""%>>Vaasam</option>
<option value="Nishantam" <%=selectedHostel.equals("Nishantam")?"selected":""%>>Nishantam</option>
<option value="Aynam" <%=selectedHostel.equals("Aynam")?"selected":""%>>Aynam</option>
<option value="Sadam" <%=selectedHostel.equals("Sadam")?"selected":""%>>Sadam</option>
<option value="Uthjam" <%=selectedHostel.equals("Uthjam")?"selected":""%>>Uthjam</option>
<option value="Puri" <%=selectedHostel.equals("Puri")?"selected":""%>>Puri</option>
</select>
</th>
<th>Complaint<br>
<select name="complaint" onchange="filterForm.submit()">
<option value="">None</option>
<option value="Electricity Issue" <%=selectedComplaint.equals("Electricity Issue")?"selected":""%>>Electricity</option>
<option value="Water Supply Issue" <%=selectedComplaint.equals("Water Supply Issue")?"selected":""%>>Water</option>
<option value="Room Cleaning Issue" <%=selectedComplaint.equals("Room Cleaning Issue")?"selected":""%>>Cleaning</option>
<option value="Internet Issue" <%=selectedComplaint.equals("Internet Issue")?"selected":""%>>Internet</option>
<option value="Furniture Issue" <%=selectedComplaint.equals("Furniture Issue")?"selected":""%>>Furniture</option>
<option value="Other Issue" <%=selectedComplaint.equals("Other Issue")?"selected":""%>>Other</option>
</select>
</th>
<th>Date<br>
<input type="date" name="date" value="<%=selectedDate%>" onchange="filterForm.submit()">
</th>
<th>Status<br>
<select name="status" onchange="filterForm.submit()">
<option value="">None</option>
<option value="Pending" <%=selectedStatus.equals("Pending")?"selected":""%>>Pending</option>
<option value="Done" <%=selectedStatus.equals("Done")?"selected":""%>>Done</option>
</select>
</th>
</tr>

<%
boolean showData = !selectedStudentId.equals("") ||
                   !selectedStudentName.equals("") ||
                   !selectedHostel.equals("") ||
                   !selectedComplaint.equals("") ||
                   !selectedDate.equals("") ||
                   !selectedStatus.equals("") ||
                   !globalSearch.equals("") ||
                   "all".equals(viewOption);

if(showData){
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");
        String sql="SELECT * FROM complaints WHERE 1=1";

        if(!selectedStudentId.equals("")) sql+=" AND student_id=?";
        if(!selectedStudentName.equals("")) sql+=" AND student_name LIKE ?";
        if(!selectedHostel.equals("")) sql+=" AND hostel_name=?";
        if(!selectedComplaint.equals("")) sql+=" AND complaint=?";
        if(!selectedDate.equals("")) sql+=" AND complaint_date=?";
        if(!selectedStatus.equals("")) sql+=" AND status=?";
        if(!globalSearch.equals("")) sql+=" AND (student_name LIKE ? OR hostel_name LIKE ? OR complaint LIKE ? OR status LIKE ?)";

        PreparedStatement ps=con.prepareStatement(sql);
        int i=1;
        if(!selectedStudentId.equals("")) ps.setString(i++,selectedStudentId);
        if(!selectedStudentName.equals("")) ps.setString(i++,"%"+selectedStudentName+"%");
        if(!selectedHostel.equals("")) ps.setString(i++,selectedHostel);
        if(!selectedComplaint.equals("")) ps.setString(i++,selectedComplaint);
        if(!selectedDate.equals("")) ps.setString(i++,selectedDate);
        if(!selectedStatus.equals("")) ps.setString(i++,selectedStatus);
        if(!globalSearch.equals("")){
            ps.setString(i++,"%"+globalSearch+"%");
            ps.setString(i++,"%"+globalSearch+"%");
            ps.setString(i++,"%"+globalSearch+"%");
            ps.setString(i++,"%"+globalSearch+"%");
        }

        ResultSet rs=ps.executeQuery();
        boolean found=false;
        while(rs.next()){
            found=true;
%>
<tr>
<td><%=rs.getInt("student_id")%></td>
<td><%=rs.getString("student_name")%></td>
<td><%=rs.getString("hostel_name")%></td>
<td><%=rs.getString("complaint")%></td>
<td><%=rs.getDate("complaint_date")%></td>
<td><%=rs.getString("status")%></td>
</tr>
<%
        }
        if(!found){
%>
<tr><td colspan="6">No complaints found.</td></tr>
<%
        }
        con.close();
    }catch(Exception e){
%>
<tr><td colspan="6">Error: <%=e.getMessage()%></td></tr>
<%
    }
}else{
%>
<tr><td colspan="6">No data shown. Apply filter or select All Records.</td></tr>
<%
}
%>

</table>
</form>

</div>

<script>
function clearFilters(){
    document.getElementsByName('studentid')[0].value = '';
    document.getElementsByName('studentname')[0].value = '';
    document.getElementsByName('hostel')[0].value = '';
    document.getElementsByName('complaint')[0].value = '';
    document.getElementsByName('date')[0].value = '';
    document.getElementsByName('status')[0].value = '';
    document.getElementsByName('searchall')[0].value = '';
    document.getElementsByName('view')[0].value = '';
    document.getElementById('filterForm').submit();
}
</script>

</body>
</html>