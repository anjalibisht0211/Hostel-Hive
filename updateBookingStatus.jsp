<%@ page import="java.sql.*" %>
<%
String status = request.getParameter("status");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/hostelhive","root",""
    );

    PreparedStatement ps = con.prepareStatement(
        "UPDATE booking_status SET status=? WHERE id=1"
    );
    ps.setString(1, status);
    ps.executeUpdate();

    ps.close();
    con.close();

    out.print("Status updated successfully");
} catch(Exception e){
    out.print("Error: " + e.getMessage());
}
%>
