<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // ---------- UPDATE LOGIC ----------
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int wardenId = Integer.parseInt(request.getParameter("warden_id"));
        String wardenName = request.getParameter("warden_name");
        String wardenNo = request.getParameter("warden_no");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/hostelhive",
                "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                "UPDATE warden SET warden_name=?, warden_no=? WHERE warden_id=?"
            );
            ps.setString(1, wardenName);
            ps.setString(2, wardenNo);
            ps.setInt(3, wardenId);
            ps.executeUpdate();

            con.close();
        } catch (Exception e) {
            out.println(e);
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard · Hostel Hive</title>

    <style>
        body { font-family:"Segoe UI"; background:#f4f5ff; margin:0; }

        .sidebar {
            width:240px; background:#4e54c8; color:white;
            min-height:100vh; padding:25px 15px; position:fixed;
        }

        .nav a {
            margin:10px 0; display:block; text-decoration:none;
            color:white; background:rgba(255,255,255,0.15);
            padding:10px; border-radius:10px; transition:.3s;
        }

        .nav a:hover, .nav a.active {
            background:white; color:#4e54c8;
        }

        .container {
            margin-left:260px;
            padding:20px;
        }

        h1 { color:#4e54c8; }

        table {
            width:100%;
            border-collapse:collapse;
            background:white;
            border-radius:10px;
            overflow:hidden;
            box-shadow:0 3px 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding:12px;
            border-bottom:1px solid #ddd;
        }

        th {
            background:#4e54c8;
            color:white;
        }

        input {
            padding:6px;
            width:130px;
        }

        button {
            padding:6px 12px;
            background:#4e54c8;
            color:white;
            border:none;
            border-radius:6px;
            cursor:pointer;
        }

        button:hover {
            background:#3b40a4;
        }
    </style>
</head>

<body>

<!-- ================= SIDEBAR ================= -->
<div class="sidebar">
    <h2>HOSTEL HIVE</h2>
    <div class="nav">
        <a href="admin-complaintStudent.jsp">📊 Complaints</a>
        <a href="admin-registeredStudents.jsp">🧑‍🎓 Registered Students</a>
        <a href="admin-registerStudent.jsp">➕ Register Student</a>
        <a href="admin-roomBookingControl.jsp">🛏️ Room Booking</a>
          <a href="#" class="active">👮 Warden</a>
        <a href="user.html">🚪 Logout</a>
    </div>
</div>

<!-- ================= MAIN CONTENT ================= -->
<div class="container">
    <h1>Warden Details (All Hostels)</h1>

    <table>
        <tr>
            <th>Warden ID</th>
            <th>Warden Name</th>
            <th>Phone Number</th>
            <th>Hostel Name</th>
            <th>Action</th>
        </tr>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/hostelhive",
                    "root", ""
                );

                String sql =
                    "SELECT w.warden_id, w.warden_name, w.warden_no, h.hostel_name " +
                    "FROM warden w JOIN hostel h ON w.hostel_id = h.hostel_id";

                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(sql);

                while (rs.next()) {
        %>
        <tr>
            <form method="post">
                <td><%= rs.getInt("warden_id") %></td>

                <td>
                    <input type="text" name="warden_name"
                           value="<%= rs.getString("warden_name") %>" required>
                </td>

                <td>
                    <input type="text" name="warden_no"
                           value="<%= rs.getString("warden_no") %>" required>
                </td>

                <td><%= rs.getString("hostel_name") %></td>

                <td>
                    <input type="hidden" name="warden_id"
                           value="<%= rs.getInt("warden_id") %>">
                    <button type="submit">Update</button>
                </td>
            </form>
        </tr>
        <%
                }
                con.close();
            } catch (Exception e) {
        %>
        <tr>
            <td colspan="5">Error loading data</td>
        </tr>
        <%
            }
        %>
    </table>
</div>

</body>
</html>
