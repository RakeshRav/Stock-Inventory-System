<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="java.util.ArrayList"%>
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
<script type="text/javascript">
function onlyNumbers()
{
	var key = event.keyCode;
	
	if(key<48 || key>57)
		{
		return false;
		}
	return true;
}
function  checkValues1()
{
	var getValues = document.forms[0].checkValues;
	var fieldsName= new Array();
	
	for(var i=0; i<getValues.length;i++)
		{
			fieldsName[i] = getValues[i].value;		
		}
	
	for(var i=0; i<fieldsName.length;i++)
	{
		var random = document.forms[0].fieldsName[i];
		if(random.value=="")
			{
				alert('Fill all the fields');
				random.focus();
				return false;
			}
	}
	return true;

}
	function checkPassword() 
	{
		
		var password = document.forms[0].password;
		var confirm = document.forms[0].confirm;
		
		if((password.value==""))
			{
				alert("Enter Password");
				password.focus();
				return false;
			}
		else if((confirm.value==""))
		{
			alert("Confirm Password");
			confirm.focus();
			return false;
		}
		else if(!(confirm.value==password.value))
		{

			alert("Password not matched");
			confirm.value="";
			password.value="";
			password.focus();
			return false;	
		}
				return true;
	}
	
</script>
<title>Dash Board</title>
</head>
<body>


<%!
	
	Connection con = null,con1 = null;
	Statement stmt = null,stmt1 = null;
	ResultSet rs = null, rs1 = null;
	String table_name;
	int table_id,i,count;
	
%>

<% 

	HttpSession session2 = request.getSession();
	Boolean loginStatus = (Boolean)session2.getAttribute("loginStatus");

	if(loginStatus==null||!loginStatus)
	{
		response.sendRedirect("LoginCompany.jsp");
	}
	
	ArrayList<String> table_headings =new  ArrayList<String>();
	ArrayList<String> column_name = new ArrayList<String>();
	ArrayList<String> isKeyList = new ArrayList<String>();
	ArrayList<String> column_type = new ArrayList<String>();
	ArrayList<String> Update_data = new ArrayList<String>();
	ArrayList<String> comboBoxNames =  new ArrayList<String>();
 	ArrayList<String> parentNames = new ArrayList<String>();
 	ArrayList<Integer> parentid = new ArrayList<Integer>();
	String label,input_type,name,isKey,col_type;
 	String edit_id;
	
 	String company_name = request.getParameter("company_name");
 	String table_id =  request.getParameter("table_id");
 	String page_name = request.getParameter("page");
 	String AddStatus = request.getParameter("addsuccess");
 	String DelStatus = request.getParameter("deletesuccess");
 	String updateStatus = request.getParameter("updatesuccess");
 	
 	
	
 	try
	{
		con = DBUtil.getConnection();
		stmt = con.createStatement();
		rs = stmt.executeQuery("select table_name from table_metadata where id= '"+table_id+"'");
		
		while(rs.next())
		{
			table_name = rs.getString(1);
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
	String action ="";
		action= "Add?action=addcompany&table_id="+table_id+"&company_name="+company_name;
			
	
	String submitValue = "Add";
	
	
	edit_id = request.getParameter("id");
	
	try
	{	
		
		con = DBUtil.getConnection();
		stmt = con.createStatement();
		rs = stmt.executeQuery("select * from column_metadata where table_id = "+table_id);

		
		while(rs.next())
		{
			isKey = rs.getString("iskey");
			col_type= rs.getString("column_type");
			String col_name= rs.getString("column_name");
			
			if(((isKey.equals("true"))||(col_name.equals("confirm"))))
			{
				
			}
			else 
			{
				column_type.add(col_type);
			}	
			
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
	
	if(edit_id!=null)
	{
			action = "Add?action=update&table_id="+table_id+"&id="+edit_id+"&company_name="+company_name;
				
		
		submitValue = "Update";
		
	//	String table_id1 = request.getParameter("table_id");
		
		try
		{
			con = DBUtil.getConnection();
			stmt = con.createStatement();
			rs = stmt.executeQuery("select table_name from  table_metadata where id = "+table_id);
			
			while (rs.next()) 
			{
				table_name = rs.getString("table_name");
			}
			
		}
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBUtil.closeAll(rs, stmt, con);
		}
		
		try
		{
			con = DBUtil.getConnection();
			stmt = con.createStatement();	
			rs = stmt.executeQuery("select * from "+table_name+" where id = "+edit_id);
			while(rs.next())
			{
				int x = 2;
				for(String temp : column_type)
				{
					if(temp.equals("number"))
					{
						String num = rs.getInt(x)+"";
						Update_data.add(num);
						x++;
					}
					else
					{
						Update_data.add(rs.getString(x));
						x++;
					}
				}
			}
		
		}		
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBUtil.closeAll(rs, stmt, con);
		}
	}
	
	if(page_name!=null)
	{
		action = action+"&page="+page_name;
	}
	
	if(table_name.equals("category"))
	{
		try
		{
			con = DBUtil.getConnection();
			stmt = con.createStatement();
			rs = stmt.executeQuery("select parentid from category");
			
			while(rs.next())
			{
				parentid.add(rs.getInt("parentid"));
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
		
		for(int temp : parentid)
		{
			String parentName = "None";
			try
			{
				con = DBUtil.getConnection();
				stmt = con.createStatement();
				rs = stmt.executeQuery("select name from "+table_name+" where id  = "+temp);
				
				if(rs.next())
				{
					parentName = rs.getString("name");
				}
				parentNames.add(parentName);
				
			}
			catch(SQLException e)
			{
				e.printStackTrace();
			}
			finally
			{
				DBUtil.closeAll(rs, stmt, con);
			}
			
		}
		

	}
	if(company_name!=null)
	{
		%>
			<jsp:include page="header.jsp?company_name=<%=company_name %>"></jsp:include>
			
		<%		
	}
	else
	{
		%>
				<jsp:include page="header.jsp"></jsp:include>
				
		<%
	}
	if(AddStatus!=null)
	{
		%>
		<div><h3>Successfully Added</h3></div>
		<%
	}
	if(DelStatus!=null)
	{
		%>
		<div><h3>Successfully Deleted</h3></div>
		<%
	}
	if(updateStatus!=null)
	{
		%>
		<div><h3>Successfully updated</h3></div>
		<%
	}
		
		%>

		
		
			
	
	
		
<form action=<%=action %> method="post">
<table>
		<%
		
		
		try
		{
			
			int i = 0;
			con = DBUtil.getConnection();
			stmt = con.createStatement();
			rs = stmt.executeQuery("select * from column_metadata where table_id = "+table_id);

			while(rs.next())
			{
				
				label = rs.getString("label");
				input_type = rs.getString("input_type");
				name = rs.getString("column_name");
				isKey = rs.getString("iskey");
				col_type= rs.getString("column_type");
				table_headings.add(label);
				column_name.add(name);
				isKeyList.add(isKey);
				
				if(isKey.equals("true"))
				{
					
				}
				else if(input_type.equals("text") || input_type.equals("password"))
				{
					%>
					<tr>
					<% if((!company_name.equals("admin"))&&(name.equals("company")))
					{
					%>
						
						<td><%=label %></td><td><input type="text" name="<%=name%>" value="<%=company_name %>" readonly="readonly"></td>
					<%
						
					}
					
					else if((Update_data.isEmpty()) && (name.equals("contact"))) 
					{
					%>
						
						<td><%=label %></td><td><input type="text" name="<%=name %>" onkeypress="return onlyNumbers()" ></td>
					<%
					
					}
					else if(Update_data.isEmpty()||name.equals("confirm")|| name.equals("password")) 
					{
					%>
						
						<td><%=label %></td><td><input type=<%=input_type %> name="<%=name %>" ></td>
					<%
					
					}
					else
					{
						if(name.equals("contact"))
						{
						%>
						<td><%=label %></td><td><input type="text" name="<%=name %>" onkeypress="return onlyNumbers()" value="<%=Update_data.get(i)%>"></td>
						<%
						i++;
						}
					
						else
						{
							%>
							<td><%=label %></td><td><input type="text" name="<%=name %>"  value="<%=Update_data.get(i)%>"></td>
							<%
							i++;	
						}
					}
					%>
					</tr>
					<% 
					
				}
				else if(input_type.equals("textarea"))
				{
					
					%>
					<tr>
					<% if(!Update_data.isEmpty()) 
					{
					%>
					<td><%=label %></td><td><textarea rows="5" cols="50" name="<%=name %>"><%=Update_data.get(i)%></textarea></td>
					
					<%
					i++;
					}
					else
					{
						%>
					<td><%=label %></td><td><textarea rows="5" cols="50" name="<%=name %>"></textarea></td>
					
					<%
					}
					%>
					</tr>
					<% 
					
					
				}
				else if(input_type.equals("comboBox"))
				{
								try
								{
									con1 = DBUtil.getConnection();
									stmt1  = con1.createStatement();
									rs1 = stmt1.executeQuery("select name from "+table_name);
									
									while(rs1.next())
									{
										comboBoxNames.add(rs1.getString("name"));
									}
								}
								catch(SQLException e)
								{
									e.printStackTrace();
								}
								finally
								{
									DBUtil.closeAll(rs1, stmt1, con1);
								}
								%>
								<tr>
								<td><%=label %></td><td> <select name="<%=name%>" >
								
								<%
								if(comboBoxNames.isEmpty())
								{
									%>
									<option>None</option>
									<%
								}
								else
								{ 
									if(!Update_data.isEmpty())
									{
										int upPid = Integer.parseInt(Update_data.get(i));
										i++;
										String upName = null;
										
										try
										{
											con1 = DBUtil.getConnection();
											stmt1 = con1.createStatement();
											rs1 = stmt1.executeQuery("select name from "+table_name+" where id = "+ upPid);
																
											if(rs1.next())
											{
												upName = rs1.getString("name");
											}
										}
										catch(SQLException e)
										{
											e.printStackTrace();
										}
										finally
										{
											DBUtil.closeAll(rs1, stmt1, con1);
										}
											%>
											<option>None</option>
											<%
										
											for(String temp : comboBoxNames)
											{
												if(temp.equals(upName))
												{
													%>
													<option selected="selected"><%=temp %></option>
													<%
												}
												else
												{
													%>
													<option ><%=temp %></option>
													<%	
												}
											}
									}
									else
									{

										%>
										<option>None</option>
										<%
										
										for(String temp : comboBoxNames)
										{
											%>
											<option><%=temp %></option>
											<%
										}
										
									}
										%>
									
									</select> </td>
									</tr>
									<%
			
									}
									
																
				}
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
		<tr style="display: none;">
		
		<%
	//	System.out.println(column_name.size());
		for(int i = 1 ; i< column_name.size() ; i++)
		{
			%>
				<td>
					<input type="radio" name="checkValues" value="<%=column_name.get(i)%>">a
				</td>
			<%
		}
		%>
		</tr>
		
		<tr>
		<%
			if(table_name.equals("company"))
			{
			
		%>
		<td></td><td><input type="submit" value="<%=submitValue%>" onclick="return checkValues1()" onclick="return checkPassword()"></td>
		<%
		
			}
			else
			{	
			%>
			<td></td><td><input type="submit" onclick="return checkValues1()" value="<%=submitValue%>"></td>
			<%
			
			}
			%> 
		</tr>
		</table>
		</form>
	
<%
	if(page_name==null)
	{
		
	
%>	
	
<table style="width: 100%; margin-top: 20px;" cellspacing="0" cellpadding="10" border="1">

<thead>
	<tr>
		<%
		for(int j = 0 ; j < table_headings.size() ; j++)
		{
			if(!isKeyList.get(j).equals("true"))
			{
				if((!table_headings.get(j).equals("Confirm Password")) && (!table_headings.get(j).equals("Password")))
				{
			
			
		%>
		<th><%=table_headings.get(j) %></th>
		<%
		count++;
				}
			}
		}
		%>
		<th>Edit</th>
		<th>Delete</th>
	</tr>
</thead>

<tbody>
	<%
	
	
	try
	{
		int i=0;
		con = DBUtil.getConnection();
		stmt =con.createStatement();
		if(!company_name.equals("admin"))
		{
			rs = stmt.executeQuery("select * from "+table_name+" where company='"+company_name+"'");
				
		}
		else
		{
			rs = stmt.executeQuery("select * from "+table_name);
			
		}
		while(rs.next())
		{
			%>
				<tr>
					<%
					for(String temp : column_name)
					{
						
						if(!temp.equals("id"))
						{
							if(!temp.equals("confirm"))
							{
								if(!temp.equals("password"))
								{
								
									if(!temp.equals("parentid"))
									{
									%>
									<td><%=rs.getString(temp) %></td>
									<%
									}
									else
									{
										%>
										<td><%=parentNames.get(i) %></td>
										<%
										i++;
									}
								}
							}
						}
					}
					
					%>	
						<td><a href="AddCompany.jsp?table_id=<%=table_id%>&id=<%=rs.getInt("id")%>&company_name=<%=company_name%>">Edit</a></td>
						<td><a href="Add?action=delete&table_id=<%=table_id %>&id=<%=rs.getInt("id")%>&company_name=<%=company_name%>">Delete</a></td>
					
				</tr>
			<%
						
					
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
			
	
	
</tbody>
</table>

<%
	}
%>

</body>
</html>