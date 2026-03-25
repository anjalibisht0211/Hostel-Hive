<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
int hostelId=(Integer)session.getAttribute("hostelid");
Connection con=null;
String hostelName="";
String msg="";
%>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con=DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");

    /* ===== GET HOSTEL NAME ===== */
    PreparedStatement ps1=con.prepareStatement(
        "SELECT hostel_name FROM hostel WHERE hostel_id=?"
    );
    ps1.setInt(1,hostelId);
    ResultSet rs1=ps1.executeQuery();
    if(rs1.next()) hostelName=rs1.getString(1);

    /* ===== UPDATE STATUS IF BUTTON CLICKED ===== */
    if(request.getParameter("complaint_id")!=null){
        int complaintId=Integer.parseInt(request.getParameter("complaint_id"));
        PreparedStatement update=con.prepareStatement(
            "UPDATE complaints SET status='Done' WHERE complaint_id=?"
        );
        update.setInt(1,complaintId);
        update.executeUpdate();
        msg="Complaint marked as Done!";
    }

}catch(Exception e){
    msg=e.getMessage();
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Complaints</title>
<style>
body{font-family:Segoe UI;background:#f4f5ff;margin:0;}
.sidebar{width:240px;background:#4e54c8;color:white;min-height:100vh;padding:25px 15px;position:fixed;}
.nav a{margin:10px 0;display:block;text-decoration:none;color:white;background:rgba(255,255,255,0.15);padding:10px;border-radius:10px;}
.nav a:hover,.active{background:white;color:#4e54c8;}
.container{margin-left:260px;padding:20px;}
table{width:100%;border-collapse:collapse;background:white;}
th,td{padding:12px;border-bottom:1px solid #ddd;text-align:left;}
th{background:#4e54c8;color:white;}
select,input[type="date"]{width:90%;padding:5px;border-radius:5px;border:1px solid #ccc;}
.btnDone{background:#28a745;color:white;border:none;padding:6px 12px;border-radius:6px;cursor:pointer;}
.doneLabel{color:green;font-weight:bold;}
.msg{color:green;font-weight:bold;margin-bottom:10px;}
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
<h2>HOSTEL HIVE</h2>
<div class="nav">
<a href="wardendashboard.jsp">🏠 Dashboard</a>
<a href="emptyBedsReport.jsp" >🛏 Available Beds Report</a>
<a href="warden_students.jsp">👨‍🎓 Students</a>
<a href="warden_complaints.jsp" class="active">📢 Complaints</a>
<a href="warden_availability.jsp" >🛏 Rooms</a>
<a href="wardenSwapRequests.jsp" >🔁 Room Swap</a>
<a href="wardenlogin.jsp">🚪 Logout</a>
</div>
</div>

<div class="container">
<h1>Complaints - <%=hostelName%></h1>

<div class="msg"><%=msg%></div>

<table id="complaintTable">
<tr>
<th>ID</th>
<th>Student</th>
<th>Complaint Type<br>
<select id="filterType" onchange="filterComplaints()">
    <option value="">All</option>
<%
    try{
        PreparedStatement psType = con.prepareStatement(
            "SELECT DISTINCT complaint FROM complaints WHERE hostel_name=?"
        );
        psType.setString(1,hostelName);
        ResultSet rsType = psType.executeQuery();
        while(rsType.next()){
            String type = rsType.getString(1);
            if(type != null) {
%>
            <option value="<%=type%>"><%=type%></option>
<%
            }
        }
    }catch(Exception e){}
%>
</select>
</th>
<th>Description</th>
<th>Date<br>
<input type="date" id="filterDate" onchange="filterComplaints()">
</th>
<th>Status<br>
<select id="filterStatus" onchange="filterComplaints()">
    <option value="">All</option>
    <option value="Pending">Pending</option>
    <option value="Done">Done</option>
</select>
</th>
<th>Action</th>
</tr>

<%
try{
    PreparedStatement ps=con.prepareStatement(
        "SELECT * FROM complaints WHERE hostel_name=? ORDER BY complaint_date DESC"
    );
    ps.setString(1,hostelName);
    ResultSet rs=ps.executeQuery();

    while(rs.next()){
        String description = rs.getString("description");
        if(description == null || description.trim().equals("")) description = "-";
%>

<tr>
<td><%=rs.getInt("complaint_id")%></td>
<td><%=rs.getString("student_name")%></td>
<td><%=rs.getString("complaint")%></td>
<td><%=description%></td>
<td><%=rs.getDate("complaint_date")%></td>
<td><%=rs.getString("status")%></td>
<td>
<%
    if(rs.getString("status").equalsIgnoreCase("Pending")){
%>
<form method="post" style="display:inline;">
<input type="hidden" name="complaint_id" value="<%=rs.getInt("complaint_id")%>">
<button class="btnDone">Mark Done</button>
</form>
<% } else { %>
<span class="doneLabel">✔ Completed</span>
<% } %>
</td>
</tr>

<% } }catch(Exception e){ out.println(e);} %>
</table>
</div>

<script>
function filterComplaints(){
    var table = document.getElementById("complaintTable");
    var typeFilter = document.getElementById("filterType").value.toLowerCase();
    var dateFilter = document.getElementById("filterDate").value;
    var statusFilter = document.getElementById("filterStatus").value.toLowerCase();

    var tr = table.getElementsByTagName("tr");
    for(var i=1;i<tr.length;i++){ // skip header
        var tds = tr[i].getElementsByTagName("td");
        if(tds.length < 6) continue;

        var typeText = tds[2].textContent.toLowerCase();
        var dateText = tds[4].textContent;
        var statusText = tds[5].textContent.toLowerCase();

        var show = true;
        if(typeFilter && typeText.indexOf(typeFilter) === -1) show = false;
        if(dateFilter && dateText !== dateFilter) show = false;
        if(statusFilter && statusText !== statusFilter) show = false;

        tr[i].style.display = show ? "" : "none";
    }
}
</script>

</body>
</html>
