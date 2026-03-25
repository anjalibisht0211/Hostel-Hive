<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");

/* Validate input */
if (username == null || password == null ||
    username.trim().isEmpty() || password.trim().isEmpty()) {
    response.sendRedirect("studentlogin.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/hostelhive",
        "root",
        ""
    );

    String sql = "SELECT id, username FROM students WHERE LOWER(username)=? AND password=?";
    ps = con.prepareStatement(sql);
    ps.setString(1, username.trim().toLowerCase());
    ps.setString(2, password.trim());

    rs = ps.executeQuery();

    if (rs.next()) {
        int studentId = rs.getInt("id");

        /* Store session data */
        session.setAttribute("student_id", studentId);
        session.setAttribute("username", rs.getString("username"));
        session.setMaxInactiveInterval(30 * 60); // 30 minutes

        response.sendRedirect("student.jsp");
    } else {
        response.sendRedirect("studentlogin.jsp?error=1");
    }

} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("studentlogin.jsp?error=db");
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}
%>
