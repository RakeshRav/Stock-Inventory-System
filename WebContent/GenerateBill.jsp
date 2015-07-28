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
		<meta charset="utf-8">
		<title>Invoice</title>
		<link rel="stylesheet" href="css/bill.css">
		
		

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">


</head>
<body>
<%!
	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
%>

<%
	int bid = Integer.parseInt(request.getParameter("bid"));
	String pageName = request.getParameter("page");
	String company_name = "";
	double total = 0.0;
%>


		<header>
			<h1>Invoice</h1>
			<%
			String date = "";
			ArrayList<String> product_names = new ArrayList<String>();
			ArrayList<Integer> qty = new ArrayList<Integer>();
			ArrayList<Double> ppu = new ArrayList<Double>();
			ArrayList<Double> subtotal = new ArrayList<Double>();
			try
			{
				
				con = DBUtil.getConnection();
				stmt = con.createStatement();
				rs = stmt.executeQuery("select  * from "+pageName+" where bid = "+bid);
				
				while(rs.next())
				{
					company_name = rs.getString("company_name");
					date = rs.getString("date1");
					product_names.add(rs.getString("product_names"));
					qty.add(rs.getInt("quantity"));
					ppu.add(rs.getDouble("ppu"));
					subtotal.add(rs.getDouble("total"));
				}
				
				for(int i = 0; i<subtotal.size();i++)
				{
					total = total + subtotal.get(i);
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			finally
			{
				DBUtil.closeAll(rs, stmt, con);
			}
			String CoAddr ="";
			String CoContact = "";
			String CoEmail ="";
			try
			{
				
				con = DBUtil.getConnection();
				stmt = con.createStatement();
				rs = stmt.executeQuery("select * from company where name = '"+company_name+"'");
				
				if(rs.next())
				{
					CoAddr = rs.getString("address");
					CoContact = rs.getString("contact");
					CoEmail = rs.getString("email");
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			finally
			{
				DBUtil.closeAll(rs, stmt, con);
			}
			
			String cuid ="";
			
			try
			{
				
				con = DBUtil.getConnection();
				stmt = con.createStatement();
				rs = stmt.executeQuery("select cuid from "+pageName+" where bid = "+bid);
				
				if(rs.next())
				{
					cuid = rs.getString(1);
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			
			
			finally
			{
				DBUtil.closeAll(rs, stmt, con);
			}
			
			String CuAddr ="";
			String CuContact = "";
			String CuEmail ="";
			String cuname = "";
			
			
			String tabName = "customer";
			
			if(pageName.equals("purchase"))
			{
				tabName = "vendor";
			}
			try
			{
				
				con = DBUtil.getConnection();
				stmt = con.createStatement();
				rs = stmt.executeQuery("select * from "+tabName+" where id = "+cuid);
				
				if(rs.next())
				{
					cuname = rs.getString("name");
					CuAddr  = rs.getString("address");

					CuContact = rs.getString("contact");
					CuEmail = rs.getString("email");
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			finally
			{
				DBUtil.closeAll(rs, stmt, con);
			}
			%>
				<address contenteditable>
		
				<h2 style="font-size: 300%"><%=company_name %></h2>
				<p><%=CoAddr %></p><p><%=CoContact %></p>
				<p><%=CoEmail %></p>
			</address>
			<span><img alt="" src="logo.png"><input type="file" accept="image/*"></span>
		</header>
		<article>
			<address contenteditable>
		
				<h2 style="padding-bottom: 5px;" ><%=cuname %></h2>
				<p style="font-size: 80%; padding-bottom: 5px;"><%=CuAddr %></p><p style="font-size: 80%; padding-bottom: 5px;"><%=CuContact %></p>
				<p style="font-size: 80%;padding-bottom: 5px;"><%=CuEmail %></p>
			</address><table class="meta">
				<tr>
					<th><span contenteditable>Invoice #</span></th>
					<td><span contenteditable><%=bid %></span></td>
				</tr>
				<tr>
					<th><span contenteditable>Date</span></th>
					<td><span contenteditable><%=date %></span></td>
				</tr>
			</table>
			<table class="inventory">
				<thead>
					<tr>
						<th><span contenteditable>Item</span></th>
						<th><span contenteditable>Quantity</span></th>
						<th><span contenteditable>Rate</span></th>
						<th><span contenteditable>Price</span></th>
					</tr>
				</thead>
				<tbody>
				<%
				
				for(int i =0 ; i< product_names.size();i++)
				{
					
				%>
				
					<tr>
						<td><span contenteditable><%=product_names.get(i) %></span></td>
						
						<td><span data-prefix></span><span contenteditable><%=qty.get(i) %></span></td>
						<td><span contenteditable><%=ppu.get(i) %></span></td>
						<td><span data-prefix></span><span><%=subtotal.get(i) %></span></td>
					</tr>
					<%

				}
					
					%>
				</tbody>
			</table>
			<table class="balance">
				<tr>
					<th><span contenteditable>Total</span></th>
					<td><span data-prefix></span><span><%=total %></span></td>
				</tr>
				
			</table>
		</article>
		<div>
		<input type="button" onclick="print()" value="Print">
		</div>
	</body>
</html>
