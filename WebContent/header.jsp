<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<link rel="stylesheet" type="text/css" href="css/style.css">

</head>
<body>
<div id="myDiv">
	

<%

	HttpSession session2 = request.getSession();
	Boolean loginStatus = (Boolean)session2.getAttribute("loginStatus");
	String company_name = request.getParameter("company_name");
	if(loginStatus==null||!loginStatus)
	{
		response.sendRedirect("LoginCompany.jsp");
		
	}
	else if(company_name==null)
	{
	%>
												
					</div>
					<div><h1>Entry Restricted</h1></div>
		
	<%	
	}
	else if(!company_name.equals("admin"))
	{
		%>
					<a href="DashBoard.jsp?company_name=<%=company_name%>" id="Cname"><%=company_name.toUpperCase() %></a>
					<ul id ="menu">			
					<li><a href="AddCompany.jsp?table_id=1&company_name=<%=company_name %>">Product</a></li>
					<li><a href="AddCompany.jsp?table_id=2&company_name=<%=company_name %>">Category</a></li>
					<li><a href="AddCompany.jsp?table_id=3&company_name=<%=company_name %>">Vendor</a></li>
					<li><a href="AddCompany.jsp?table_id=4&company_name=<%=company_name %>">Customer</a></li>
					<li><a href="Add?action=logout" style="color: white; background: black">Sign out</a></li>
					</ul>							
					</div>
					
		<%
	}
	else
	{
		%>
					<a href="DashBoard.jsp?company_name=<%=company_name%>" id="Cname"><%=company_name.toUpperCase() %></a>
					<ul id ="menu">
					<li><a href="AddCompany.jsp?table_id=1&company_name=<%=company_name %>">Product</a></li>
					<li><a href="AddCompany.jsp?table_id=2&company_name=<%=company_name %>">Category</a></li>
					<li><a href="AddCompany.jsp?table_id=3&company_name=<%=company_name %>">Vendor</a></li>
					<li><a href="AddCompany.jsp?table_id=4&company_name=<%=company_name %>">Customer</a></li>
					<li><a href="AddCompany.jsp?table_id=5&company_name=<%=company_name %>">Company</a></li>
					<li><a href="Add?action=logout" style="color: white; background: black;" >Sign out</a></li>
		</ul>
		</div>
		<%
	}
%>
	


</body>
</html>