<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
Integer studentId = (Integer) session.getAttribute("studentid");
if(studentId==null){
    out.println("<span style='color:red'>You must log in first!</span>");
    return;
}

String hostel = request.getParameter("hostel_name");
int floor = Integer.parseInt(request.getParameter("floor"));
int room_no = Integer.parseInt(request.getParameter("room_no"));
String bed = request.getParameter("bed");

/* DB Connection */
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3307/hostelhive","root","");

/* Check if already booked */
PreparedStatement check = con.prepareStatement(
    "SELECT * FROM booking WHERE hostel_name=? AND floor=? AND room_no=? AND bed=?");
check.setString(1,hostel);
check.setInt(2,floor);
check.setInt(3,room_no);
check.setString(4,bed);
ResultSet rs = check.executeQuery();
if(rs.next()){
    out.println("<span style='color:red'>Bed "+bed+" in Room "+room_no+" is already booked!</span>");
    rs.close(); check.close(); con.close(); return;
}
rs.close(); check.close();

/* Insert booking */
PreparedStatement ps = con.prepareStatement(
    "INSERT INTO booking(hostel_name,floor,room_no,bed,student_id) VALUES(?,?,?,?,?)");
ps.setString(1,hostel);
ps.setInt(2,floor);
ps.setInt(3,room_no);
ps.setString(4,bed);
ps.setInt(5,studentId);

int inserted = ps.executeUpdate();
if(inserted>0){
    out.println("<span style='color:green'>Bed "+bed+" in Room "+room_no+" booked successfully!</span>");
}else{
    out.println("<span style='color:red'>Failed to book bed. Try again!</span>");
}

ps.close(); con.close();
%>
