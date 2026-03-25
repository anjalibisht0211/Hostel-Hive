<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
Integer studentId = (Integer) session.getAttribute("student_id");

if(studentId == null){
    response.sendRedirect("studentlogin.jsp");
    return;
}

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/hostelhive","root",""
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT hostel FROM students WHERE id=?"
    );
    ps.setInt(1, studentId);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        String hostel = rs.getString("hostel");

        // ? store hostel in session
        session.setAttribute("selected_hostel", hostel);

        // redirect directly to room booking page
        response.sendRedirect("room.jsp");
        return;
    }else{
        out.println("Student hostel not found.");
    }

    con.close();
}catch(Exception e){
    out.println(e);
}
%>
