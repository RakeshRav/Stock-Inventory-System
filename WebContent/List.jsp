<%@page import="java.util.Date"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="Utility.List"%>
<%@page import="Utility.DBUtil"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.eclipse.jdt.internal.compiler.flow.FinallyFlowContext"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>List</title>
<link rel = "stylesheet" type="text/css" href="css/sales.css" >
</head>
<body>
<%! 
	
%>

<%
	HttpSession session2;
	session2 = request.getSession();
	Boolean loginStatus = (Boolean) session2.getAttribute("loginStatus");
	if(loginStatus==null || !loginStatus)
	{
		response.sendRedirect("LoginCompany.jsp");
	}

	String view = request.getParameter("view");
	String v = request.getParameter("v");
	String type = request.getParameter("type");
	String company_name = request.getParameter("company_name");
	String c = type.charAt(0)+"";
	String str = c.toUpperCase()+type.substring(1,type.length());
	
	Date d = new Date();
	System.out.print(d.getDate());
	System.out.print(d.getMonth()+1);
	System.out.print(d.getYear()+1900);
	
	
%>
<div id="head">
	<div id="title">
	<%
		if(v.equals("today"))
		{
			%>
			<h1>Today's <%=str %></h1>
			<%		
		}
		else if(v.equals("history"))
		{
			%>
			<h1><%=str %> History</h1>
			<%		
			
		}
	
	%>
	</div>
	<div id="tags">
		<ul>
			<li><a href=DashBoard.jsp?company_name =<%=company_name %>>Home</a></li>
			
		</ul>
	</div>
</div>

	<%
		if(v.equals("history"))
		{
			
	%>
		<div style="padding: 10px;
	font-family: arial;
	background: rgba(58, 65, 94, 0.58);
	color: white; overflow: hidden;">
	
	<form action="List.jsp?company_name=rao&type=<%=type %>&v=history" method="post">
	<h3 style="float: left; padding-right: 30px;"><input type="radio" name="view" value="Week">This Week</h3>
	<h3 style="float: left; padding-right: 30px;"><input type="radio" name="view" value="Month">This Month</h3>
	<h3 style="float: left; padding-right: 30px;"><input type="submit" value ="Apply" id = "add"></h3>
	</form>
	</div>
	<%
	
	
		}
	%>
	
	<%
	if(view!=null)
	{
			
	%>
		<div style="padding: 10px;
	font-family: arial;
	background: rgb(2, 94, 129);
	color: white; overflow: hidden;">
	
	<h3>This <%=view %>'s History</h3>
	</div>



<%
	}
	
	
	List l = new List();

	if(l.getData(type, v, view,company_name))
	{
		
	
%>
<div id ="list" style="  margin: 100px; margin-top: 50px;">
	<table id = "table" border="1px" bordercolor="rgb(2, 94, 129)" cellpadding="5px" cellspacing="0" >
	
		<thead >
			<tr>
				<th>S.NO.</th>
				<th>Bill No.</th>
				<th>Customer Id</th>
				<th>Company Name</th>
				<th>Date</th>
			<!--  	<th>Delete</th>-->
			</tr>
		</thead>
		<tbody id="addlist">
		<%
			for(int i = 0; i< l.cuid.size(); i++)
			{
				String bid = l.bid.get(i)+"";
		%>
			
			<tr>
				<td><%=i+1 %></td>
				<td><a href="GenerateBill.jsp?bid=<%=bid %>&page=<%=type%>&company_name=<%=company_name%>"><%=l.bid.get(i) %></td>
				<td><%=l.cuid.get(i) %></td>
				<td><%=l.company_name.get(i) %></td>
				<td><%=l.date.get(i) %></td>
			</tr>
		
		<%

			}
		%>
		
		
		</tbody>
	
	</table>
	
</div>

<%
	}
	else
	{
		%>
		<div style="padding: 10px;
				font-family: arial;
				background: rgb(2, 94, 129);
				color: white; overflow: hidden;">
				
				<h3>No Data Found</h3>
				</div>
				<%

	}
%>


</body>
</html>