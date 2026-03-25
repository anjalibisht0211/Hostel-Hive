<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>

<%
if(session.getAttribute("admin_id") == null){
    response.sendRedirect("adminlogin.jsp");
    return;
}

// GET FILTER PARAMETERS
String showOption = request.getParameter("showOption");
String selectedHostel = request.getParameter("hostel");
String searchCourse = request.getParameter("searchCourse");
String searchName = request.getParameter("searchName");
String searchEmail = request.getParameter("searchEmail");
String searchId = request.getParameter("searchId");
String globalSearch = request.getParameter("globalSearch");

if(showOption == null) showOption = "None";
if(selectedHostel == null) selectedHostel = "";
if(searchCourse == null) searchCourse = "";
if(searchName == null) searchName = "";
if(searchEmail == null) searchEmail = "";
if(searchId == null) searchId = "";
if(globalSearch == null) globalSearch = "";

// CHECK IF ANY FILTER OR ALL IS APPLIED
boolean filtersApplied = "All".equals(showOption) ||
        !searchName.isEmpty() || !searchEmail.isEmpty() || !searchId.isEmpty() ||
        !searchCourse.isEmpty() || !selectedHostel.isEmpty() || !globalSearch.isEmpty();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registered Students | Hostel Hive</title>
<style>


body{font-family:"Segoe UI"; background:#f4f5ff; margin:0;}
.sidebar{width:240px; background:#4e54c8; color:white; min-height:100vh; padding:25px 15px; position:fixed;}
.sidebar h2{ text-align:left; margin-bottom:25px; color:white }
.sidebar a{ display:block; padding:14px 20px; color:white; text-decoration:none; border-radius:8px; margin:6px 12px; transition:0.3s; }
.sidebar a:hover{ background: rgba(255,255,255,0.2); }
.sidebar a.active{ background:white; color:#4f56c1; font-weight:bold; } /* ACTIVE LINK WHITE BACKGROUND */

/* Main content */
.main-content{ margin-left:250px; padding:30px; }
h2{ color:#4e54c8; }
input,select,button{ padding:6px; border-radius:6px; border:1px solid #ccc; font-size:1rem; }
button{ background:#4e54c8; color:white; cursor:pointer; }
table{ width:100%; border-collapse:collapse; background:white; margin-top:20px; }
th{ background:#4e54c8; color:white; padding:12px; text-align:center; }
td{ padding:10px; border-bottom:1px solid #ddd; text-align:center; }
tr:hover{ background:#f0f2ff; }
.filter-input{ width:90%; padding:4px; border-radius:4px; border:1px solid #ccc; margin-top:4px; }
</style>
</head>
<body>

<div class="sidebar">
    <h2>HOSTEL HIVE</h2>
    <a href="admindashboard.jsp">🏠 Dashboard</a>
    <a href="admin-complaintStudent.jsp">📊 Complaints</a>
    <a href="admin-registeredStudents.jsp" class="active">🧑‍🎓 Registered Students</a>
    <a href="admin-registerStudent.jsp">➕ Register Student</a>
    <a href="admin-roomBookingControl.jsp">🛏️ Room Booking</a>
    <a href="admin-warden.jsp">👮 Warden</a>
    <a href="admin_hostel.jsp" >🏢 Hostel</a>
    <a href="adminlogin.jsp">🚪 Logout</a>
</div>

<div class="main-content">
<h2>Registered Students</h2>

<form method="get" id="filterForm">
 <!-- Global search & show option -->
<tr>
    <td colspan="9">
        Show: 
        <select name="showOption" onchange="this.form.submit()">
            <option value="None" <%= "None".equals(showOption)?"selected":"" %>>None</option>
            <option value="All" <%= "All".equals(showOption)?"selected":"" %>>All</option>
        </select>
        &nbsp;&nbsp;
        Global Search: <input type="text" name="globalSearch" value="<%=globalSearch%>" placeholder="Search all..." style="width:300px;" onchange="this.form.submit()">
        &nbsp;&nbsp;
        <button type="button" onclick="clearFilters()">Clear Filters</button>
    </td>
</tr>

<table>
    
<tr>
    <th>Name</th>
    <th>Email</th>
    <th>Student ID</th>
    <th>Course</th>
    <th>Hostel</th>
    <th>Room</th>
    <th>Username</th>
    <th>Phone</th>
    <th>Gender</th>
</tr>

<!-- Individual Filter Inputs -->
<tr>
    <td><input type="text" name="searchName" value="<%=searchName%>" class="filter-input" placeholder="Search Name" onchange="this.form.submit()"></td>
    <td><input type="text" name="searchEmail" value="<%=searchEmail%>" class="filter-input" placeholder="Search Email" onchange="this.form.submit()"></td>
    <td><input type="text" name="searchId" value="<%=searchId%>" class="filter-input" placeholder="Student ID" onchange="this.form.submit()"></td>
    <td>
        <select name="searchCourse" class="filter-input" onchange="this.form.submit()">
            <option value="">All</option>
            <option value="BTech" <%= "BTech".equals(searchCourse)?"selected":"" %>>BTech</option>
            <option value="MTech" <%= "MTech".equals(searchCourse)?"selected":"" %>>MTech</option>
            <option value="MBA" <%= "MBA".equals(searchCourse)?"selected":"" %>>MBA</option>
            <option value="BBA" <%= "BBA".equals(searchCourse)?"selected":"" %>>BBA</option>
            <option value="BSC" <%= "BSC".equals(searchCourse)?"selected":"" %>>BSC</option>
            <option value="Bcom" <%= "Bcom".equals(searchCourse)?"selected":"" %>>Bcom</option>
        </select>
    </td>
    <td>
        <select name="hostel" class="filter-input" onchange="this.form.submit()">
            <option value="">All</option>
            <option value="Bhuvnam" <%= "Bhuvnam".equals(selectedHostel)?"selected":"" %>>Bhuvnam</option>
            <option value="Vaasam" <%= "Vaasam".equals(selectedHostel)?"selected":"" %>>Vaasam</option>
            <option value="Nishantam" <%= "Nishantam".equals(selectedHostel)?"selected":"" %>>Nishantam</option>
            <option value="Puri" <%= "Puri".equals(selectedHostel)?"selected":"" %>>Puri</option>
            <option value="SADAM" <%= "SADAM".equals(selectedHostel)?"selected":"" %>>SADAM</option>
            <option value="Uthjam" <%= "Uthjam".equals(selectedHostel)?"selected":"" %>>Uthjam</option>
        </select>
    </td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
</tr>


<%
if(filtersApplied){ // Only show data if "All" or any filter/global search applied
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");
        String sql = "SELECT * FROM students WHERE 1=1";
        
        if(!selectedHostel.isEmpty()) sql += " AND hostel=?";
        if(!searchCourse.isEmpty()) sql += " AND course=?";
        if(!searchName.isEmpty()) sql += " AND name LIKE ?";
        if(!searchEmail.isEmpty()) sql += " AND email LIKE ?";
        if(!searchId.isEmpty()) sql += " AND studentId LIKE ?";
        if(!globalSearch.isEmpty()){
            sql += " AND (name LIKE ? OR email LIKE ? OR studentId LIKE ? OR hostel LIKE ? OR course LIKE ?)";
        }

        PreparedStatement ps = con.prepareStatement(sql);
        int i = 1;
        if(!selectedHostel.isEmpty()) ps.setString(i++, selectedHostel);
        if(!searchCourse.isEmpty()) ps.setString(i++, searchCourse);
        if(!searchName.isEmpty()) ps.setString(i++, "%"+searchName+"%");
        if(!searchEmail.isEmpty()) ps.setString(i++, "%"+searchEmail+"%");
        if(!searchId.isEmpty()) ps.setString(i++, "%"+searchId+"%");
        if(!globalSearch.isEmpty()){
            for(int j=0;j<5;j++) ps.setString(i++, "%"+globalSearch+"%");
        }

        ResultSet rs = ps.executeQuery();
        boolean found = false;
        while(rs.next()){
            found = true;
%>
<tr>
    <td><%=rs.getString("name")%></td>
    <td><%=rs.getString("email")%></td>
    <td><%=rs.getString("studentId")%></td>
    <td><%=rs.getString("course")%></td>
    <td><%=rs.getString("hostel")%></td>
    <td><%=rs.getString("room")==null?"Not Booked":rs.getString("room")%></td>
    <td><%=rs.getString("username")%></td>
    <td><%=rs.getString("phone")%></td>
    <td><%=rs.getString("gender")%></td>
</tr>
<%
        }
        if(!found){
%>
<tr><td colspan="9">No students found</td></tr>
<%
        }
        rs.close(); ps.close(); con.close();
    }catch(Exception e){
%>
<tr><td colspan="9">Error: <%=e.getMessage()%></td></tr>
<%
    }
}else{
%>
<tr><td colspan="9">No data shown. Apply filter or select All.</td></tr>
<%
}
%>
</table>
</form>

<script>
function clearFilters(){
    document.getElementsByName('searchName')[0].value = '';
    document.getElementsByName('searchEmail')[0].value = '';
    document.getElementsByName('searchId')[0].value = '';
    document.getElementsByName('searchCourse')[0].value = '';
    document.getElementsByName('hostel')[0].value = '';
    document.getElementsByName('showOption')[0].value = 'None';
    document.getElementsByName('globalSearch')[0].value = '';
    document.getElementById('filterForm').submit();
}
</script>

</div>
</body>
</html>