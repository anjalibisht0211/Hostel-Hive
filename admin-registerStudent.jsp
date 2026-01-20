<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // -------- INSERT STUDENT LOGIC --------
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String studentId = request.getParameter("studentId");
        String room = request.getParameter("room");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String hostel = request.getParameter("hostel");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/hostelhive",
                "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO students " +
                "(name, email, studentId, room, username, password, phone, gender, hostel) " +
                "VALUES (?,?,?,?,?,?,?,?,?)"
            );

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, studentId);
            ps.setString(4, room);
            ps.setString(5, username);
            ps.setString(6, password);
            ps.setString(7, phone);
            ps.setString(8, gender);
            ps.setString(9, hostel);

            ps.executeUpdate();
            con.close();
%>
            <script>
                alert("✅ Student Registered Successfully");
                window.location.href="admin-registeredStudents.jsp";
            </script>
<%
            return;
        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register Student · Hostel Hive</title>

    <style>
        body { font-family:"Segoe UI"; background:#f4f5ff; margin:0; }

        .sidebar {
            width:240px; background:#4e54c8; color:white;
            min-height:100vh; padding:25px 15px; position:fixed;
        }

        .nav a {
            margin:10px 0; display:block;
            text-decoration:none;
            color:white;
            background:rgba(255,255,255,0.15);
            padding:10px;
            border-radius:10px;
        }

        .nav a.active, .nav a:hover {
            background:white;
            color:#4e54c8;
        }

        .container {
            margin-left:260px;
            padding:25px;
        }

        .form-box {
            background:white;
            max-width:600px;
            padding:25px;
            border-radius:12px;
            box-shadow:0 3px 10px rgba(0,0,0,0.1);
        }

        h1 { color:#4e54c8; }

        label { font-weight:600; margin-top:12px; display:block; }

        input, select {
            width:100%;
            padding:10px;
            margin-top:6px;
            border-radius:8px;
            border:1px solid #ccc;
        }

        button {
            margin-top:20px;
            padding:12px;
            background:#4e54c8;
            color:white;
            border:none;
            border-radius:8px;
            font-size:16px;
            cursor:pointer;
        }

        button:hover {
            background:#3b40a4;
        }
    </style>
</head>

<body>

<!-- ============ SIDEBAR ============ -->
<div class="sidebar">
    <h2>HOSTEL HIVE</h2>
    <div class="nav">
        <a href="admin-complaintStudent.jsp">📊 Complaints</a>
        <a href="admin-registeredStudents.jsp">🧑‍🎓 Registered Students</a>
        <a href="admin-registerStudent.jsp" class="active">➕ Register Student</a>
        <a href="admin-roomBookingControl.jsp">🛏️ Room Booking</a>
        <a href="admin-warden.jsp">👮 Warden</a>
        <a href="user.html">🚪 Logout</a>
    </div>
</div>

<!-- ============ MAIN CONTENT ============ -->
<div class="container">
    <h1>Register New Student</h1>

    <div class="form-box">
        <form method="post">

            <label>Full Name</label>
            <input type="text" name="name" required>

            <label>Email</label>
            <input type="email" name="email" required>

            <label>Student ID</label>
            <input type="text" name="studentId" required>

            <label>Room</label>
            <input type="text" name="room" required>

            <label>Username</label>
            <input type="text" name="username" required>

            <label>Password</label>
            <input type="password" name="password" required>

            <label>Phone</label>
            <input type="text" name="phone" required>

            <label>Gender</label>
            <select name="gender" required>
                <option value="">Select</option>
                <option>Male</option>
                <option>Female</option>
            </select>

            <label>Hostel</label>
            <select name="hostel" required>
                <option>Bhuvnam</option>
                <option>Vaasam</option>
                <option>Nishantam</option>
                <option>Aynam</option>
                <option>Sadam</option>
                <option>Uthjam</option>
                <option>Puri</option>
            </select>

            <button type="submit">Register Student</button>
        </form>
    </div>
</div>

</body>
</html>
