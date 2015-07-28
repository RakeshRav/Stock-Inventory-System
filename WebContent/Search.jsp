<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
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
<title>Searching....</title>
</head>
<body>
<%
	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	
	
	try
	{
		String query = request.getParameter("q"); //q is default parameter
		
		
		ArrayList<Object[]> info = new ArrayList<Object[]>();
		
		con = DBUtil.getConnection();
		stmt = con.createStatement();
		rs = stmt.executeQuery("select id,name,contact from customer where name like '"+query+"%'");
		
		while(rs.next())
		{
			info.add(new Object[]{rs.getInt("id"), rs.getString("name"), rs.getString("contact")} );
		}
		
		
		
		
		int count = 0;
		
		for(int i=0; i<info.size() ;i++)
		{
				out.println(info.get(i)[1]);
				
				if(count==5)
					break;
				
				count++;
			
		}
		
	}
	catch(SQLException e )
	{
		e.printStackTrace();
		
	}
	finally
	{
		DBUtil.closeAll(rs, stmt, con);
	}
	
	
	
	
	
%>
</body>
</html>