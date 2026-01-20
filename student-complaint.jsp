<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register Complaint | Hostel Hive</title>

    <style>
        body {
            margin: 0;
            height: 100vh;
            background: #3f46c8;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: "Segoe UI", sans-serif;
        }

        .card {
            background: #4e54c8;
            width: 360px;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
            color: white;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #ffd700;
        }

        label {
            font-size: 14px;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            margin-bottom: 15px;
            border-radius: 8px;
            border: none;
            outline: none;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background: #ffd700;
            color: #3f46c8;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn:hover {
            background: #ffea61;
        }

        .back {
            margin-top: 15px;
            text-align: center;
        }

        .back a {
            text-decoration: none;
            background: #eee;
            color: #3f46c8;
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 13px;
        }
    </style>
</head>

<body>

<%
/* ===================== FORM SUBMISSION LOGIC ===================== */
if ("POST".equalsIgnoreCase(request.getMethod())) {

    int studentId = Integer.parseInt(request.getParameter("student_id"));
    String studentName = request.getParameter("student_name");
    String hostelName = request.getParameter("hostel_name");
    String complaint = request.getParameter("complaint");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive",
            "root",
            ""
        );

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO complaints " +
            "(student_id, student_name, hostel_name, complaint, complaint_date, status) " +
            "VALUES (?, ?, ?, ?, CURDATE(), 'Pending')"
        );

        ps.setInt(1, studentId);
        ps.setString(2, studentName);
        ps.setString(3, hostelName);
        ps.setString(4, complaint);
        ps.executeUpdate();

        con.close();
%>
        <script>
            alert("? Complaint submitted successfully!");
            window.location.href = "student-complaint.jsp";
        </script>
<%
        return;
    } catch(Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
    }
}
%>

<div class="card">
    <h2>Register Complaint</h2>

    <form method="post">

        <label>Student ID</label>
        <input type="number" name="student_id" required>

        <label>Student Name</label>
        <input type="text" name="student_name" required>

        <!-- ? HOSTEL DROPDOWN (FIXED LIST) -->
        <label>Hostel Name</label>
        <select name="hostel_name" required>
            <option value="">-- Select Hostel --</option>
            <option value="Bhuvnam">Bhuvnam</option>
            <option value="Vaasam">Vaasam</option>
            <option value="Nishantam">Nishantam</option>
            <option value="Aynam">Aynam</option>
            <option value="Sadam">Sadam</option>
            <option value="Uthjam Puri">Uthjam Puri</option>
        </select>

        <!-- ? COMPLAINT TYPE -->
        <label>Complaint Type</label>
        <select name="complaint" required>
            <option value="">-- Select Complaint --</option>
            <option value="Electricity Issue">Electricity</option>
            <option value="Water Supply Issue">Water</option>
            <option value="Room Cleaning Issue">Room Cleaning</option>
            <option value="Internet Issue">Internet</option>
            <option value="Furniture Issue">Furniture</option>
            <option value="Other Issue">Other</option>
        </select>

        <button type="submit" class="btn">Submit Complaint</button>
    </form>

    <div class="back">
        <a href="student_dash.jsp">? Back to Dashboard</a>
    </div>
</div>

</body>
</html>