<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
<link rel="stylesheet" type="text/css" href="css/signin.css">
</head>
<body>
<%
	String logoutStatus = request.getParameter("logout");
	String status = request.getParameter("status");

%>
	<div id="outer">
		<h3>Stock Inventory System</h3>
		<div id="inner">
			<h3>SIGN IN</h3>
					<form action="Add?action=login" method="post">
				<table  style="width: 100%; overflow:hidden;">
				<%
				if(status!=null)
	{
		%>
		
				<tr><td style="color: red;">LOGIN FAILED</td></tr>
		<%
		
	}
	if(logoutStatus!=null)
	{
		%>
		
				<tr><td style="color: green;">Successfully Signed out</td></tr>
		<%
		
	}
			%>
	
				<tr>
					<td class = "textviews">Email Address</td>
				<tr>
				<tr  style="width: 100%;">
					<td   style="width: 100%;">	<input type="text" placeholder="Enter Email Id" name="username"   class= "edittext"></td>
				</tr>
				<tr>
					<td class = "textviews">Password</td>
				<tr>
				<tr  style="width: 100%;">
					<td  style="width: 100%;">	<input type="password" placeholder="Enter Password" name="password"  class= "edittext"></td>
				</tr>

								<tr>
					<td  align="center"  >	<input type="submit" name ="submit" value="SIGN IN" id="signin"  ></td>
				</tr>


			

				</table>
			</form>

		</div>

	</div>

				
</body>
</html>