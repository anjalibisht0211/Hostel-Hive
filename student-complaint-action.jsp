<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>

<%
    int studentId = Integer.parseInt(request.getParameter("student_id"));
    String studentName = request.getParameter("student_name");
    String complaint = request.getParameter("complaint");

    String url = "jdbc:mysql://localhost:3307/hostelhive";
    String user = "root";
    String pass = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(url, user, pass);

        String sql = "INSERT INTO complaints " +
                     "(student_id, student_name, complaint, complaint_date, status) " +
                     "VALUES (?, ?, ?, ?, ?)";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, studentId);
        ps.setString(2, studentName);
        ps.setString(3, complaint);
        ps.setDate(4, java.sql.Date.valueOf(LocalDate.now()));
        ps.setString(5, "Pending");

        ps.executeUpdate();
        con.close();

        response.sendRedirect("student-complaint.jsp");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
