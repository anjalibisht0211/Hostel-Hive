<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

session.invalidate();   // destroy session
response.sendRedirect("user.jsp");  // redirect to home/login page
%>
