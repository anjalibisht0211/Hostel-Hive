<%@page session="true"%>
<%
    /* ===== PREVENT BROWSER CACHE ===== */
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

/* ===== SESSION CHECK ===== */
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("adminlogin.jsp");
    return;
}
    String status = request.getParameter("status");

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive",
            "root","");

        PreparedStatement ps = con.prepareStatement(
            "UPDATE booking_status SET status=? WHERE id=1");
        ps.setString(1, status);
        ps.executeUpdate();
        con.close();

        out.print("? Booking status updated to " + status);
    } catch(Exception e){
        out.print("? Error: " + e.getMessage());
    }
%>
