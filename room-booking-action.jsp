<%@ page import="java.sql.*, java.util.*" %>

<%
/* ================= SESSION CHECK ================= */
Integer studentId = (Integer) session.getAttribute("studentId");
if(studentId == null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

/* ================= INPUT ================= */
String hostel = request.getParameter("hostel");
if(hostel == null) hostel = "Hostel Hive";

int floor = 1;
if(request.getParameter("floor") != null){
    floor = Integer.parseInt(request.getParameter("floor"));
}

/* ================= DB CONNECTION ================= */
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3307/hostelhive","root","");

/* ================= HANDLE BOOKING ================= */
String message = "";

if("POST".equalsIgnoreCase(request.getMethod())){
    int room = Integer.parseInt(request.getParameter("room_no"));
    String bed = request.getParameter("bed");

    // ? Check if already booked
    PreparedStatement check = con.prepareStatement(
        "SELECT booking_id FROM booking WHERE hostel_name=? AND floor=? AND room_no=? AND bed=?"
    );
    check.setString(1, hostel);
    check.setInt(2, floor);
    check.setInt(3, room);
    check.setString(4, bed);

    ResultSet crs = check.executeQuery();

    if(crs.next()){
        message = "? Bed already booked!";
    } else {
        // ? Insert booking
        PreparedStatement ins = con.prepareStatement(
            "INSERT INTO booking (hostel_name, floor, room_no, bed, student_id) VALUES (?,?,?,?,?)"
        );
        ins.setString(1, hostel);
        ins.setInt(2, floor);
        ins.setInt(3, room);
        ins.setString(4, bed);
        ins.setInt(5, studentId);
        ins.executeUpdate();

        message = "? Room booked successfully!";
        ins.close();
    }
    crs.close();
    check.close();
}

/* ================= FETCH BOOKED BEDS ================= */
PreparedStatement ps = con.prepareStatement(
    "SELECT room_no, bed FROM booking WHERE hostel_name=? AND floor=?"
);
ps.setString(1, hostel);
ps.setInt(2, floor);

ResultSet rs = ps.executeQuery();
Set<String> booked = new HashSet<>();

while(rs.next()){
    booked.add(rs.getInt("room_no") + "_" + rs.getString("bed"));
}
rs.close();
ps.close();
%>

<!DOCTYPE html>
<html>
<head>
<title>Room Booking | Hostel Hive</title>

<style>
body{
    margin:0;
    background:#4b0082;
    font-family:Segoe UI;
    color:white;
}
h2{padding:20px}

.msg{
    text-align:center;
    font-weight:bold;
    margin-bottom:10px;
}

.rooms{
    display:grid;
    grid-template-columns:repeat(5,1fr);
    gap:20px;
    padding:20px;
}

.room{
    background:#5d2b90;
    padding:15px;
    border-radius:12px;
    text-align:center;
}

.room h4{
    margin:0 0 10px;
    color:#ffd700;
}

.beds{
    display:flex;
    justify-content:center;
    gap:8px;
}

.bed{
    width:35px;
    height:35px;
    border:none;
    border-radius:8px;
    font-weight:bold;
    cursor:pointer;
}

.free{
    background:#3cff00;
}

.booked{
    background:#ff3b3b;
    cursor:not-allowed;
}
</style>
</head>

<body>

<h2><%=hostel%> ? Floor <%=floor%></h2>

<% if(!message.isEmpty()){ %>
    <div class="msg"><%=message%></div>
<% } %>

<div class="rooms">

<%
for(int room=1; room<=30; room++){
%>
    <div class="room">
        <h4>Room <%=room%></h4>
        <div class="beds">
        <%
        for(char bed='A'; bed<='C'; bed++){
            String key = room + "_" + bed;
            boolean isBooked = booked.contains(key);
        %>
            <form method="post" style="margin:0">
                <input type="hidden" name="hostel" value="<%=hostel%>">
                <input type="hidden" name="floor" value="<%=floor%>">
                <input type="hidden" name="room_no" value="<%=room%>">
                <input type="hidden" name="bed" value="<%=bed%>">

                <button class="bed <%=isBooked ? "booked" : "free"%>"
                        <%=isBooked ? "disabled" : ""%>>
                    <%=bed%>
                </button>
            </form>
        <%
        }
        %>
        </div>
    </div>
<%
}
con.close();
%>

</div>

</body>
</html>
