<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
String message = "";

if("POST".equalsIgnoreCase(request.getMethod())){

    String newUsername = request.getParameter("username");
    String newPass = request.getParameter("password");
    String confirmPass = request.getParameter("confirm_password");
    String email = (String)session.getAttribute("email");

    if(!newPass.equals(confirmPass)){
        message = "<span class='error'>Passwords do not match!</span>";
    } else {
        Connection con = null;
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3307/hostelhive","root","");

            // Check if username already exists for another student
            PreparedStatement psCheckUsername = con.prepareStatement(
                "SELECT COUNT(*) FROM students WHERE username=? AND email<>?"
            );
            psCheckUsername.setString(1, newUsername);
            psCheckUsername.setString(2, email);
            ResultSet rs1 = psCheckUsername.executeQuery();
            rs1.next();
            if(rs1.getInt(1) > 0){
                message = "<span class='error'>Username already taken!</span>";
            } else {
                // Check if password is unique (optional, you may skip this if password can be same)
                PreparedStatement psCheckPass = con.prepareStatement(
                    "SELECT COUNT(*) FROM students WHERE password=? AND email<>?"
                );
                psCheckPass.setString(1, newPass);
                psCheckPass.setString(2, email);
                ResultSet rs2 = psCheckPass.executeQuery();
                rs2.next();
                if(rs2.getInt(1) > 0){
                    message = "<span class='error'>Password already in use by another student!</span>";
                } else {
                    // Update username and password
                    PreparedStatement psUpdate = con.prepareStatement(
                        "UPDATE students SET username=?, password=? WHERE email=?"
                    );
                    psUpdate.setString(1, newUsername);
                    psUpdate.setString(2, newPass);
                    psUpdate.setString(3, email);
                    psUpdate.executeUpdate();
                    message = "? Username and Password updated successfully! Please login again.";
                }
                rs2.close();
                psCheckPass.close();
            }
            rs1.close();
            psCheckUsername.close();
            con.close();
        } catch(Exception e){
            message = "<span class='error'>Error: " + e.getMessage() + "</span>";
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Reset Username & Password</title>
<style>
body{
    font-family: Arial, sans-serif;
    background: linear-gradient(to right, #667eea, #764ba2);
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
    margin:0;
}

.container{
    background:white;
    padding:40px;
    border-radius:10px;
    width:350px;
    box-shadow:0 8px 20px rgba(0,0,0,0.2);
    text-align:center;
}

h2{
    margin-bottom:20px;
    color:#333;
}

input[type="text"], input[type="password"]{
    width:100%;
    padding:10px;
    margin:10px 0;
    border-radius:5px;
    border:1px solid #ccc;
}

button{
    width:100%;
    padding:10px;
    margin-top:10px;
    border:none;
    border-radius:5px;
    background:#667eea;
    color:white;
    font-size:16px;
    cursor:pointer;
}

button:hover{
    background:#5a67d8;
}

.back-btn{
    background:#999;
    margin-top:10px;
}

.back-btn:hover{
    background:#777;
}

.message{
    margin-top:10px;
    font-weight:bold;
    color:green;
}

.error{
    color:red;
}
</style>
</head>

<body>
<div class="container">
    <h2>Reset Username & Password</h2>

    <form method="post">
        <input type="text" name="username" placeholder="Enter New Username" required>
        <input type="password" name="password" placeholder="Enter New Password" required>
        <input type="password" name="confirm_password" placeholder="Confirm Password" required>
        <button type="submit">Update</button>
    </form>

    <form action="studentlogin.jsp">
        <button type="submit" class="back-btn">Back to Login</button>
    </form>

    <div class="message">
        <%=message%>
    </div>
</div>
</body>
</html>