<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
/* ===============================
   1️⃣ LOGIN CHECK
=================================*/
if(session.getAttribute("student_id") == null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

int studentId = (Integer) session.getAttribute("student_id");
String hostel = (String) session.getAttribute("selected_hostel");

String room = request.getParameter("room");
String bed  = request.getParameter("bed");

String message = "";
boolean success = false;

/* ===============================
   2️⃣ BASIC VALIDATION
=================================*/
if(hostel == null){
    message = "❌ Hostel not selected.";
}
else if(room == null || room.isEmpty() || bed == null || bed.isEmpty()){
    message = "⚠️ Please select a room and a bed.";
}
else{
    Connection con = null;
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive",
            "root",""
        );

        con.setAutoCommit(false);

        /* ===============================
           3️⃣ CHECK IF STUDENT ALREADY BOOKED
        =================================*/
        PreparedStatement psStudent = con.prepareStatement(
            "SELECT * FROM bookings WHERE student_id=? AND hostel_name=?"
        );
        psStudent.setInt(1, studentId);
        psStudent.setString(2, hostel);
        ResultSet rsStudent = psStudent.executeQuery();

        if(rsStudent.next()){
            message = "⚠️ You have already booked a bed. One student can book only one bed!";
        }
        else{

            /* ===============================
               4️⃣ CHECK IF BED ALREADY BOOKED
            =================================*/
            PreparedStatement psBed = con.prepareStatement(
                "SELECT * FROM bookings WHERE hostel_name=? AND room_number=? AND bed=?"
            );
            psBed.setString(1, hostel);
            psBed.setInt(2, Integer.parseInt(room));
            psBed.setString(3, bed);

            ResultSet rsBed = psBed.executeQuery();

            if(rsBed.next()){
                message = "❌ This bed is already booked!";
            }
            else{

                /* ===============================
                   5️⃣ INSERT NEW BOOKING
                =================================*/
                PreparedStatement insertBooking = con.prepareStatement(
                    "INSERT INTO bookings(student_id, hostel_name, room_number, bed) VALUES (?,?,?,?)"
                );
                insertBooking.setInt(1, studentId);
                insertBooking.setString(2, hostel);
                insertBooking.setInt(3, Integer.parseInt(room));
                insertBooking.setString(4, bed);
                insertBooking.executeUpdate();
                insertBooking.close();

                /* Update students table */
                PreparedStatement updStudent = con.prepareStatement(
                    "UPDATE students SET room=? WHERE id=?"
                );
                updStudent.setString(1, room + bed);
                updStudent.setInt(2, studentId);
                updStudent.executeUpdate();
                updStudent.close();

                success = true;
                message = "✅ Booking confirmed successfully!";
            }
        }

        con.commit();
        con.setAutoCommit(true);
        con.close();
    }
    catch(Exception e){
        try{ if(con != null) con.rollback(); } catch(Exception ex){}
        message = "❌ Error: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Hostel Hive | Booking Status</title>

<style>
body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(120deg,#4B0082,#2E0854);
    font-family:Arial;
    color:white;
}
.container{
    background:rgba(255,255,255,0.12);
    padding:40px 50px;
    border-radius:20px;
    text-align:center;
    width:450px;
    backdrop-filter:blur(10px);
    box-shadow:0 8px 20px rgba(0,0,0,0.4);
}
h1{ color:#FFD700; }
.success{ color:#00ff7f; font-weight:bold; }
.error{ color:#ff6b6b; font-weight:bold; }
button{
    margin-top:25px;
    padding:12px 22px;
    background:#FFD700;
    color:#4B0082;
    border:none;
    border-radius:10px;
    cursor:pointer;
}
</style>
</head>

<body>
<div class="container">
<h1>🏠 Hostel Hive</h1>

<% if(success){ %>
    <div class="success"><%= message %></div>
    <p><b>Hostel:</b> <%= hostel %></p>
    <p><b>Room:</b> <%= room %></p>
    <p><b>Bed:</b> <%= bed %></p>
    <button onclick="location.href='student_dash.jsp'">Go to Dashboard</button>
<% } else { %>
    <div class="error"><%= message %></div>
    <button onclick="location.href='student_dash.jsp'">Go to Dashboard</button>
<% } %>

</div>
</body>
</html>
