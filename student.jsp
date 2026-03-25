<%
Integer studentId = (Integer) session.getAttribute("studentId");
if (studentId == null) {
  response.sendRedirect("studentlogin.jsp");
  return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>? Hostel Hive | Dashboard</title>
<style>
body { font-family:Arial; background:#2E0854; color:white; text-align:center; padding:30px; }
header { font-size:2rem; margin-bottom:30px; }
.dashboard { display:flex; justify-content:center; gap:30px; margin-bottom:30px; }
.card { background:#4B0082; padding:20px; border-radius:15px; width:180px; cursor:pointer; transition:0.3s; }
.card:hover { background:#6A0DAD; }
.card .emoji { font-size:3rem; margin-bottom:10px; }
.logout-btn { padding:12px 24px; border:none; border-radius:10px; background:#FFD700; color:#4B0082; cursor:pointer; }
.logout-btn:hover { background:#ffea61; }
</style>
</head>
<body>
<header>? Hostel Hive - Student Dashboard</header>
<div class="dashboard">
  <div class="card" onclick="window.location.href='hostel.jsp'">
      
    <div class="emoji">??</div>
    <div>Book Room</div>
  </div>
  <div class="card" onclick="window.location.href='student-complaint.jsp'">
    <div class="emoji">?</div>
    <div>Complaint</div>
  </div>
</div>
<button class="logout-btn" onclick="window.location.href='logout.jsp'">Logout</button>
</body>
</html>
