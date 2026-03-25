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

/* ================= CHECK GLOBAL BOOKING STATUS ================= */
boolean bookingAllowed = true;
try{
    Statement stmtStatus = con.createStatement();
    ResultSet rsStatus = stmtStatus.executeQuery("SELECT status FROM booking_status WHERE id=1");
    if(rsStatus.next()){
        String status = rsStatus.getString("status");
        if("disabled".equalsIgnoreCase(status)){
            bookingAllowed = false;
        }
    }
    rsStatus.close();
    stmtStatus.close();
} catch(Exception e){
    bookingAllowed = false;
}

/* ================= HANDLE BOOKING ================= */
String message = "";

if("POST".equalsIgnoreCase(request.getMethod())){
    if(!bookingAllowed){
        // ? Booking globally disabled
        message = "? Room booking is currently closed!";
    } else {
        int room = Integer.parseInt(request.getParameter("room_no"));
        String bed = request.getParameter("bed");

        // ? Check if student already has a booking
        PreparedStatement checkStudent = con.prepareStatement(
            "SELECT * FROM booking WHERE student_id=?"
        );
        checkStudent.setInt(1, studentId);
        ResultSet rsStudent = checkStudent.executeQuery();

        if(rsStudent.next()){
            message = "? You have already booked a bed! Cannot book multiple.";
        } else {
            // ? Check if the bed is already booked
            PreparedStatement checkBed = con.prepareStatement(
                "SELECT booking_id FROM booking WHERE hostel_name=? AND floor=? AND room_no=? AND bed=?"
            );
            checkBed.setString(1, hostel);
            checkBed.setInt(2, floor);
            checkBed.setInt(3, room);
            checkBed.setString(4, bed);

            ResultSet rsBed = checkBed.executeQuery();

            if(rsBed.next()){
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
                ins.close();

                message = "? Room booked successfully!";
            }
            rsBed.close();
            checkBed.close();
        }
        rsStudent.close();
        checkStudent.close();
    }
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
