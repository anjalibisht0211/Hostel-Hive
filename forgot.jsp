
<%@ page import="java.util.*,javax.mail.*,javax.mail.internet.*" %>
<%@ page import="java.sql.*" %>

<%
String message="";

if("POST".equalsIgnoreCase(request.getMethod())){

    String email = request.getParameter("email");
    String otp = String.valueOf(new Random().nextInt(900000) + 100000);

    try{

        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hostelhive","root",""
        );

        PreparedStatement ps = con.prepareStatement(
            "SELECT id FROM students WHERE email=?"
        );

        ps.setString(1,email);

        ResultSet rs = ps.executeQuery();

        if(rs.next()){

            /* STORE OTP IN SESSION */
            session.setAttribute("otp", otp);
            session.setAttribute("email", email);

            /* EMAIL CONFIGURATION */

            String host="smtp.gmail.com";
            String user="haniibeee2004@gmail.com";
            String pass="cqyoopchctniaiot";

            Properties props=new Properties();

            props.put("mail.smtp.auth","true");
            props.put("mail.smtp.starttls.enable","true");
            props.put("mail.smtp.host",host);
            props.put("mail.smtp.port","587");

            Session mailSession=Session.getInstance(props,
                new javax.mail.Authenticator(){
                    protected PasswordAuthentication getPasswordAuthentication(){
                        return new PasswordAuthentication(user,pass);
                    }
                });

            Message msg=new MimeMessage(mailSession);

            msg.setFrom(new InternetAddress(user));

            msg.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(email)
            );

            msg.setSubject("Hostel Hive Password Reset OTP");

            /* EMAIL CONTENT (ONLY OTP) */

            String body =
            "Hello Student,\n\n"
            +"You requested to reset your Hostel Hive password.\n\n"
            +"Your OTP for verification is:\n\n"
            + otp +
            "\n\nThis OTP is valid for a short time."
            +"\nDo not share it with anyone.\n\n"
            +"Regards,\nHostel Hive Team";

            msg.setText(body);

            Transport.send(msg);

            response.sendRedirect("verify_otp.jsp");

        }else{

            message="Email not found!";

        }

        con.close();

    }catch(Exception e){

        message="Error: "+e.getMessage();

    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Send OTP</title>

<style>

body{
font-family: Arial, sans-serif;
background: linear-gradient(to right,#667eea,#764ba2);
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

input[type="email"]{
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
color:red;
}

</style>
</head>

<body>

<div class="container">

<h2>Send OTP</h2>

<form method="post">

<input type="email"
name="email"
placeholder="Enter your email"
required>

<button type="submit">
Send OTP
</button>

</form>

<form action="studentlogin.jsp">

<button type="submit"
class="back-btn">
Back to Login
</button>

</form>

<div class="message">
<%=message%>
</div>

</div>

</body>
</html>
