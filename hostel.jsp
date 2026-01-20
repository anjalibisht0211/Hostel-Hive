
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page session="true" %>
<%
    // Ensure the student is logged in
    if(session.getAttribute("student_id") == null) {
        response.sendRedirect("studentlogin.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String message = "";

    // Handle form submission
    String selectedHostel = request.getParameter("hostel");
    if(selectedHostel != null && !selectedHostel.trim().isEmpty()) {
        // Save hostel choice temporarily in session
        session.setAttribute("selected_hostel", selectedHostel);
        message = "✅ You selected: " + selectedHostel;

        // Redirect to room selection page after 1.5 seconds
        response.setHeader("Refresh", "1.5; URL=room.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hostel Hive | Book a Room</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Pacifico&family=Poppins:wght@400;600&display=swap');
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(120deg, #4B0082, #2E0854);
  font-family: 'Poppins', sans-serif;
  color: white;
}

.container {
  background: rgba(255, 255, 255, 0.1);
  padding: 40px 60px;
  border-radius: 20px;
  text-align: center;
  width: 450px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.3);
  backdrop-filter: blur(10px);
}

h1 {
  font-family: 'Pacifico', cursive;
  color: #FFD700;
  font-size: 2.8rem;
  text-shadow: 0 0 8px rgba(0,0,0,0.6);
  margin-bottom: 25px;
}

p {
  font-size: 1.1rem;
  margin-bottom: 20px;
}

label {
  font-size: 1.2rem;
  font-weight: 600;
  display: block;
  margin-bottom: 10px;
}

select {
  width: 100%;
  padding: 12px;
  border-radius: 10px;
  border: none;
  outline: none;
  font-size: 1rem;
  background: white;
  color: #4B0082;
  margin-bottom: 20px;
}

button {
  background: #FFD700;
  color: #4B0082;
  font-weight: bold;
  font-size: 1rem;
  padding: 12px 20px;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: 0.3s;
}

button:hover {
  background: #ffe75f;
  transform: translateY(-3px);
}

.footer {
  margin-top: 20px;
  font-size: 0.9rem;
  color: #ddd;
}

.alert {
  background: rgba(255,255,255,0.2);
  border-radius: 10px;
  padding: 10px;
  margin-top: 15px;
  font-weight: bold;
  color: #00ff7f;
}
</style>
</head>
<body>
<div class="container">
  <h1>🏠 Hostel Hive</h1>
  <p>Welcome, <%= username %>!</p>

  <form method="post">
    <label for="hostel">Choose Your Hostel:</label>
    <select id="hostel" name="hostel" required>
      <option value="">-- Select Hostel --</option>
      <option value="Bhuvnam">Bhuvnam</option>
      <option value="Vaasam">Vaasam</option>
      <option value="Nishantam">Nishantam</option>
      <option value="Aynam">Aynam</option>
      <option value="SADAM">Sadam</option>
      <option value="Uthjam">Uthjam</option>
      <option value="Puri">Puri</option>
    </select>

    <button type="submit">Next</button>
  </form>

  <% if(!message.isEmpty()) { %>
    <div class="alert"><%= message %></div>
  <% } %>

  <div class="footer">© 2025 Hostel Hive | Smart Hostel Management System</div>
</div>
</body>
</html>
