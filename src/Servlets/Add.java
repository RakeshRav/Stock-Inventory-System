package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import oracle.jdbc.util.Login;

//import com.sun.media.ui.ColumnList;

import Utility.DBUtil;
import Utility.DMLUtil;



public class Add extends HttpServlet 
{
	
	ArrayList<String> comapany_param_val;
	ArrayList<String> company_param;
	ArrayList<String> comapany_param_type;

	
	int query_length;
	
	Connection con = null;
	Statement stmt = null;
	ResultSet rs =  null;
	PreparedStatement ps = null;
	String query,sub_query,table_name;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		doWork(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		doWork(request, response);
	}
	
	protected void doWork(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		
		String action = request.getParameter("action");
		
		if (action.equals("addcompany")) 
		{
			add(request,response);
		}
		else if(action.equals("delete"))
		{
			delete(request,response);
		}
		else if (action.equals("update")) 
		{
			update(request,response);
		}
		else if(action.equals("login"))
		{
			login(request,response);
		}
		else if(action.equals("logout"))
		{
			logout(request,response);
		}
	}

	private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		session.invalidate();
		response.sendRedirect("LoginCompany.jsp?logout=success");
	}

	public void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String company_name;
		try 
		{
			con = DBUtil.getConnection();
			ps = con.prepareStatement("select name from company where email=? and password=?");
			ps.setString(1, username);
			ps.setString(2, password);
			rs = ps.executeQuery();
			if(rs.next())
			{
				HttpSession session = request.getSession();
				session.setAttribute("loginStatus", true);
				company_name=rs.getString("name");
				response.sendRedirect("DashBoard.jsp?company_name="+company_name+"");
			}
			else
			{
				response.sendRedirect("LoginCompany.jsp?status=failed");
			}
		}
		catch (SQLException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally
		{
			DBUtil.closeAll(rs, null, con);
			if (ps!=null) 
			{
				try {
					ps.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
	}

	public void add(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException 
	{
		int id =0;
		
		comapany_param_val = new ArrayList<String>();
		company_param = new ArrayList<String>();
		comapany_param_type = new ArrayList<String>();

		
		String company_name=request.getParameter("company_name");
		String table_id = request.getParameter("table_id");
		String page_name = request.getParameter("page");
		try 
		{
			con = DBUtil.getConnection();
			stmt=con.createStatement();
			rs = stmt.executeQuery("select table_name from table_metadata where id = "+table_id);
			
			while (rs.next())
			{
				table_name = rs.getString("table_name");
				System.out.println(table_name);
			}
			
			id = DMLUtil.generateId(table_name, "id");
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
			stmt=con.createStatement();

			rs = stmt.executeQuery("select * from column_metadata where table_id = "+table_id);
			
			while (rs.next()) 
			{
				if (!rs.getString("column_name").equals("id")) 
				{
					if (!rs.getString("column_name").equals("confirm")) 
					{
					
					company_param.add(rs.getString("column_name"));
					comapany_param_type.add(rs.getString("column_type"));
					}
				}
			}
			
			
			
			
			query = "insert into "+table_name+" values(?,";
			
			for (String temp : company_param) 
			{
				comapany_param_val.add(request.getParameter(temp));
				query = query+"?,";
				
				System.out.println(request.getParameter(temp));
			}
			
			
			
			query_length = query.length();
			
			sub_query = query.substring(0,query_length-1);
			
			sub_query = sub_query+")";
			
			
			System.out.println(sub_query);
			
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
			ps = con.prepareStatement(sub_query);
			
			for (int i = 0 ; i <=comapany_param_val.size() ; i++)
			{
				if (i == 0)
				{
					ps.setInt(i+1, id);
				}
				else 
				{
					if(comapany_param_type.get(i-1).equals("number") && company_param.get(i-1).equals("parentid") )
					{
						int pid = categoryComboBox(comapany_param_val.get(i-1));
						ps.setInt(i+1, pid);
					}
					else if (comapany_param_type.get(i-1).equals("number")) 
					{

						int num1 = Integer.parseInt(comapany_param_val.get(i-1));
						ps.setInt(i+1, num1);	
					}
					else
					{
						ps.setString(i+1, comapany_param_val.get(i-1) );
						
					}
				}
				
			}
			
			
			ps.executeUpdate();
		}
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBUtil.closeAll(null, null, con);
			if (ps!=null) 
			{
				try {
					ps.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		if(page_name!=null)
		{
			if(page_name.equals("sales"))
			{
				response.sendRedirect("Sales.jsp?company_name="+company_name+"&addsuccess=true&name=sales");
			}
			else if(page_name.equals("purchase"))
			{
				response.sendRedirect("Sales.jsp?company_name="+company_name+"&name=purchase&addsuccess=true");
			}
		}
		else
		{
				response.sendRedirect("AddCompany.jsp?addsuccess=true&table_id="+table_id+"&company_name="+company_name);	
			
			
		}
		
	}
	
	protected void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		String id = request.getParameter("id");
		String table_id = request.getParameter("table_id");
		String company_name = request.getParameter("company_name");
		
		try 
		{
			con = DBUtil.getConnection();
			stmt = con.createStatement();
			rs = stmt.executeQuery("select table_name from table_metadata where id = "+table_id);
			
			while (rs.next())
			{
				table_name = rs.getString("table_name");
			}
			
			stmt.executeUpdate("delete from "+table_name+" where id = "+id);
		}
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBUtil.closeAll(rs, stmt, con);
		}
			response.sendRedirect("AddCompany.jsp?deletesuccess=true&table_id="+table_id+"&company_name="+company_name);
			
		
		
		
		
	}

	protected void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		String table_id = request.getParameter("table_id");
		String id = request.getParameter("id");
		String company_name = request.getParameter("company_name");
		
		comapany_param_val = new ArrayList<String>();
		company_param = new ArrayList<String>();
		comapany_param_type = new ArrayList<String>();


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
			stmt=con.createStatement();	
			
			rs = stmt.executeQuery("select * from column_metadata where table_id = "+table_id);
			
			while (rs.next()) 
			{
				if (!rs.getString("column_name").equals("id")) 
				{
					if (!rs.getString("column_name").equals("confirm")) 
					{
					
					company_param.add(rs.getString("column_name"));
					comapany_param_type.add(rs.getString("column_type"));
					}
				}
			}
			
			
			
			query = "update "+table_name+" set ";
			
			int j = 0;
			for (String temp : company_param) 
			{
				comapany_param_val.add(request.getParameter(temp));
				query = query+company_param.get(j)+"=?,";
				j++;
				
			}
			
			
			
			query_length = query.length();
			
			sub_query = query.substring(0,query_length-1);
			
			sub_query = sub_query+" where id = ?";
			
			System.out.println(sub_query);
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
			int i;
			con = DBUtil.getConnection();
			ps = con.prepareStatement(sub_query);
			
			for (i = 0 ; i <comapany_param_val.size() ; i++)
			{

				if(comapany_param_type.get(i).equals("number") && company_param.get(i).equals("parentid") )
				{
					int pid = categoryComboBox(comapany_param_val.get(i));
					ps.setInt(i+1, pid);
				}
				else if (comapany_param_type.get(i).equals("number")) 
				{

					int num1 = Integer.parseInt(comapany_param_val.get(i));
					ps.setInt(i+1, num1);	
				}
				else
				{
					ps.setString(i+1, comapany_param_val.get(i));
					
				}

				
			}
			ps.setString(i+1, id);
			ps.executeUpdate();
		}
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		finally
		{
			DBUtil.closeAll(null, null, con);
			if (ps!=null) 
			{
				try {
					ps.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
			response.sendRedirect("AddCompany.jsp?updatesuccess=true&table_id="+table_id+"&company_name="+company_name);
			
		
		
	}
	
	public  int categoryComboBox(String comboStr)
	{
		int comboId=0;
		if (!comboStr.equals("None"))
		{
			try 
			{
				con = DBUtil.getConnection();
				stmt = con.createStatement();
				rs = stmt.executeQuery("select id from "+table_name+" where name = '"+comboStr+"'");
				
				if (rs.next())
				{
					comboId = rs.getInt("id");
				}
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			finally
			{
				DBUtil.closeAll(rs, stmt, con);
			}

		}
				return comboId;
	}

}
