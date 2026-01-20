<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    if(session.getAttribute("student_id") == null){
        response.sendRedirect("studentlogin.jsp");
        return;
    }

    String hostel = (String) session.getAttribute("selected_hostel");
    if(hostel == null){
        response.sendRedirect("hostel.jsp");
        return;
    }

    boolean[][] booked = new boolean[91][3];

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive?zeroDateTimeBehavior=CONVERT_TO_NULL",
            "root","");

        PreparedStatement ps = con.prepareStatement(
            "SELECT room_number, bed FROM bookings WHERE hostel_name=?");
        ps.setString(1, hostel);
        ResultSet rs = ps.executeQuery();

        while(rs.next()){
            int r = rs.getInt("room_number");
            String b = rs.getString("bed");
            if("A".equals(b)) booked[r][0] = true;
            if("B".equals(b)) booked[r][1] = true;
            if("C".equals(b)) booked[r][2] = true;
        }
        con.close();
    }catch(Exception e){
        out.println("<p style='color:red'>"+e+"</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Room Booking</title>

<style>
body{
    margin:0;
    background:linear-gradient(120deg,#4B0082,#2E0854);
    font-family:Arial;
    color:white;
}
header{
    padding:15px;
    text-align:center;
    background:rgba(0,0,0,0.3);
}
header h1{
    color:#FFD700;
}

.courtyard{
    display:grid;
    grid-template-columns:repeat(6,1fr);
    gap:15px;
    padding:30px;
}
.room{
    background:rgba(255,255,255,0.1);
    padding:10px;
    border-radius:12px;
    text-align:center;
}
.room h3{
    margin:6px;
    color:#FFD700;
}

/* 🔹 BED COLORS */
.beds button{
    margin:4px;
    padding:6px 12px;
    border-radius:6px;
    border:none;
    cursor:pointer;
    background:#bdbdbd;      /* GREY = AVAILABLE */
    color:black;
    font-weight:bold;
}

.beds button:hover{
    background:#9e9e9e;
}

.booked{
    background:#e53935 !important;  /* RED = BOOKED */
    color:white;
    cursor:not-allowed;
}

.selected{
    background:#00c853 !important;  /* GREEN = SELECTED */
    color:white;
}

.confirm{
    display:block;
    margin:30px auto;
    padding:12px 25px;
    font-size:16px;
    background:#FFD700;
    border:none;
    border-radius:10px;
    cursor:pointer;
}
</style>

<script>
let selectedBtn = null;

function selectBed(btn, room, bed){
    if(btn.classList.contains("booked")) return;

    if(selectedBtn) selectedBtn.classList.remove("selected");
    btn.classList.add("selected");
    selectedBtn = btn;

    document.getElementById("room").value = room;
    document.getElementById("bed").value = bed;
}
</script>
</head>

<body>

<header>
<h1>Hostel Hive - <%=hostel%></h1>
<p>Select Room & Bed</p>
</header>

<form method="post" action="savebooking.jsp">
<input type="hidden" name="room" id="room">
<input type="hidden" name="bed" id="bed">

<div class="courtyard">
<%
for(int r=1;r<=90;r++){
%>
<div class="room">
<h3>Room <%=r%></h3>
<div class="beds">

<button type="button"
class="<%=booked[r][0]?"booked":""%>"
<%=booked[r][0]?"disabled":""%>
onclick="selectBed(this,<%=r%>,'A')">A</button>

<button type="button"
class="<%=booked[r][1]?"booked":""%>"
<%=booked[r][1]?"disabled":""%>
onclick="selectBed(this,<%=r%>,'B')">B</button>

<button type="button"
class="<%=booked[r][2]?"booked":""%>"
<%=booked[r][2]?"disabled":""%>
onclick="selectBed(this,<%=r%>,'C')">C</button>

</div>
</div>
<% } %>
</div>

<button class="confirm">Confirm Booking</button>
</form>

</body>
</html>
