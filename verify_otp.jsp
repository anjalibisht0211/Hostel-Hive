<%
String message="";

if("POST".equalsIgnoreCase(request.getMethod())){

    String enteredOtp=request.getParameter("otp");
    String sessionOtp=(String)session.getAttribute("otp");

    if(enteredOtp.equals(sessionOtp)){
        response.sendRedirect("reset_password.jsp");
    }else{
        message="? Invalid OTP!";
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Verify OTP</title>
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

input[type="text"]{
    width:100%;
    padding:10px;
    margin:10px 0;
    border-radius:5px;
    border:1px solid #ccc;
    text-align:center;
    font-size:16px;
    letter-spacing:3px;
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
    color:red;
    font-weight:bold;
}
</style>
</head>

<body>

<div class="container">
    <h2>Verify OTP</h2>

    <form method="post">
        <input type="text" name="otp" placeholder="Enter 6-digit OTP" maxlength="6" required>
        <button type="submit">Verify OTP</button>
    </form>

    <form action="forgot.jsp">
        <button type="submit" class="back-btn">Back</button>
    </form>

    <div class="message">
        <%=message%>
    </div>
</div>

</body>
</html>