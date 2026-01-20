<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin | Room Bookings</title>
    <style>
        body {
            background: linear-gradient(120deg,#2e0854,#4b0082);
            font-family: Arial;
            color: white;
            padding: 30px;
        }

        h1 {
            text-align: center;
            color: gold;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            color: #4b0082;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            text-align: center;
        }

        th {
            background: #4b0082;
            color: gold;
        }

        tr:nth-child(even) {
            background: #f2e9ff;
        }

        tr:hover {
            background: #ddd;
        }

        .back {
            display: inline-block;
            margin-bottom: 15px;
            background: gold;
            color: #4b0082;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>

<a href="admin-dashboard.html" class="back">? Back to Dashboard</a>

<h1>? Hostel Hive ? Room Bookings</h1>

<table>
    <tr>
        <th>Booking ID</th>
        <th>Student ID</th>
        <th>Name</th>
        <th>Hostel</th>
        <th>Floor</th>
        <th>Room</th>
        <th>Bed</th>
        <th>Date</th>
        <th>Status</th>
    </tr>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive",
            "root",
            ""
        );

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM room_booking");

        while(rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("booking_id") %></td>
        <td><%= rs.getInt("student_id") %></td>
        <td><%= rs.getString("student_name") %></td>
        <td><%= rs.getString("hostel_name") %></td>
        <td><%= rs.getString("floor") %></td>
        <td><%= rs.getInt("room_no") %></td>
        <td><%= rs.getString("bed") %></td>
        <td><%= rs.getDate("booking_date") %></td>
        <td><%= rs.getString("status") %></td>
    </tr>
<%
        }
        con.close();
    } catch(Exception e) {
        out.println(e);
    }
%>

</table>

</body>
</html>
