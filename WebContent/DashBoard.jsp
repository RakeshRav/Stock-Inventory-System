<%@page import="java.sql.SQLException"%>
<%@page import="Utility.DBUtil"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="css/DashBoard.css">
<title>DashBoard</title>
</head>
<body>

<%!
	Connection con =null;
	Statement stmt = null;
	ResultSet rs = null;
	HttpSession session2 ;

%>
<%
	session2 = request.getSession();
	Boolean loginStatus = (Boolean) session2.getAttribute("loginStatus");
	if(loginStatus==null || !loginStatus)
	{
		response.sendRedirect("LoginCompany.jsp");
	}
	
	String company_name = request.getParameter("company_name");
	

%>

<%

	try
	{
			con = DBUtil.getConnection();
			stmt = con.createStatement();
			rs = stmt.executeQuery("select id from company where name ='"+company_name+"'");
			if(!rs.next())
			{
				session2.invalidate();
				response.sendRedirect("LoginCompany.jsp");
			}
			
	}
	catch(SQLException e)
	{
		e.printStackTrace();
	}
	finally
	{
		DBUtil.closeAll(rs, stmt, con);
	}

	
		%>
		<jsp:include page="header.jsp"></jsp:include>
	
	
	<div id="label">
		<h2 style="margin: 0px 10px;">DashBoard</h2>
	</div>
	
		<div class="dashboard">
			<div class="saleProduct">
				<a href=Sales.jsp?name=sales&company_name=<%=company_name %> class="textDec">
				<div class="button" id="sales">
					Sales	
				</div>
				</a>
			</div>
			
			<div class="purchase">
			<a href=Sales.jsp?company_name=<%=company_name %>&name=purchase class="textDec">
				<div class="button" id="purchase">
					Purchase	
				</div>
				</a>
			</div>
		</div>
		
		<div class="dashboard" style="margin-top: 0px;">
			<div id="outOfStock">
			<a href=# class="textDec">
				<div class="button" id="outStocks">
					Out Of Stocks	
				</div>

			</a>
			</div>
		</div>
		
		<div class="dashboard">
			<div class="saleProduct">
				<a href=List.jsp?company_name=<%=company_name %>&type=sales&v=today class="textDec">
				<div class="button" id="todaySale">
					Today's Sale	
				</div>
				</a>
			</div>
			
			<div class="purchase">
			<a href=List.jsp?company_name=<%=company_name %>&type=purchase&v=today class="textDec">
				<div class="button" id="todayPurchase">
					Today's Purchase	
				</div>
				</a>
			</div>
		</div>
				
		<div class="dashboard">
			<div class="saleProduct">
				<a href=List.jsp?company_name=<%=company_name %>&type=sales&v=history class="textDec">
				<div class="button" id="saleHistory">
					Sales History	
				</div>
				</a>
			</div>
			
			<div class="purchase">
			<a href=List.jsp?company_name=<%=company_name %>&type=purchase&v=history class="textDec">
				<div class="button" id="historyPurchase">
					Purchase History	
				</div>
				</a>
			</div>
		</div>
		
			
		
		<%
	
	
%>


</body>
</html>