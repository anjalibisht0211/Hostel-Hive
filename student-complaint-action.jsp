<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>

<%
/* ================= SESSION CHECK ================= */
if(session.getAttribute("studentId") == null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

int studentId = (Integer)session.getAttribute("studentId");

/* ===== FETCH STUDENT NAME + HOSTEL FROM DB ===== */
String studentName = "";
String hostelName = "";

String url = "jdbc:mysql://localhost:3307/hostelhive";
String user = "root";
String pass = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url, user, pass);

    PreparedStatement psFetch = con.prepareStatement(
        "SELECT username, Hostel FROM students WHERE studentId=?"
    );
    psFetch.setInt(1, studentId);
    ResultSet rs = psFetch.executeQuery();

    if(rs.next()){
        studentName = rs.getString("username");
        hostelName = rs.getString("Hostel");
    }

    /* ===== GET FORM DATA ===== */
    String complaint = request.getParameter("complaint");
    String description = request.getParameter("description");

    if(description == null || description.trim().equals("")){
        description = null;
    }

    /* ===== INSERT COMPLAINT ===== */
    String sql = "INSERT INTO complaints " +
                 "(student_id, student_name, hostel_name, complaint, complaint_date, description, status) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?)";

    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, studentId);
    ps.setString(2, studentName);
    ps.setString(3, hostelName);
    ps.setString(4, complaint);
    ps.setDate(5, java.sql.Date.valueOf(LocalDate.now()));
    ps.setString(6, description);
    ps.setString(7, "Pending");

    ps.executeUpdate();
    con.close();

    response.sendRedirect("student-complaint.jsp?success=1");

} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
