<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <title>Room Booking Control · Hostel Hive</title>

    <style>
        body {
            font-family:
                system-ui,
                -apple-system,
                "Segoe UI Emoji",
                "Apple Color Emoji",
                "Noto Color Emoji",
                "Segoe UI",
                sans-serif;
            background: #f4f5ff;
            margin: 0;
        }

        .container {
            margin-left: 260px;
            padding: 20px;
        }

        .title {
            font-size: 26px;
            color: #4e54c8;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            max-width: 600px;
        }

        /* Sidebar */
        .sidebar {
            width: 240px;
            background: #4e54c8;
            color: white;
            min-height: 100vh;
            padding: 25px 15px;
            position: fixed;
        }

        .nav a {
            margin: 10px 0;
            display: block;
            text-decoration: none;
            color: white;
            background: rgba(255,255,255,0.15);
            padding: 10px;
            border-radius: 10px;
            transition: 0.3s;
        }

        .nav a:hover,
        .nav a.active {
            background: white;
            color: #4e54c8;
        }

        .logout {
            margin-top: 30px;
            background: rgba(0,0,0,0.25);
        }

        .logout:hover {
            background: #ff4d4d;
            color: white;
        }

        .status-enabled {
            color: #2ecc71;
            font-weight: 700;
        }

        .status-disabled {
            color: #e74c3c;
            font-weight: 700;
        }
    </style>
</head>

<body>

<div class="sidebar">
    <h2>HOSTEL HIVE</h2>

    <div class="nav">
        <a href="admin-complaintStudent.jsp">📊 Complaints</a>
        <a href="admin-registeredStudents.jsp">🧑‍🎓 Registered Students</a>
        <a href="admin-registerStudent.jsp">➕ Register Student</a>
        <a href="admin-roomBookingControl.jsp" class="active">🛏️ Room Booking</a>
       <a href="admin-warden.jsp">👮 Warden</a>
        <a href="user.html" class="logout">🚪 Logout</a>
    </div>
</div>

<div class="container">
    <h1 class="title">Room Booking Control</h1>

    <div class="card">
        <p style="font-size:18px;font-weight:600;">
            Enable or Disable room booking:
        </p>

        <p id="statusText" class="status-enabled">Enabled</p>

        <label style="display:flex;align-items:center;gap:10px;margin-top:10px;">
            <input type="checkbox" id="toggle" checked onchange="toggleStatus()">
            Toggle Booking
        </label>
    </div>
</div>

<script>
function toggleStatus() {
    const check = document.getElementById("toggle");
    const text = document.getElementById("statusText");

    if (check.checked) {
        text.textContent = "Enabled";
        text.className = "status-enabled";
    } else {
        text.textContent = "Disabled";
        text.className = "status-disabled";
    }
}
</script>

</body>
</html>
