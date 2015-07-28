package Utility;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DMLUtil 
{
	static Connection con;
	static Statement stmt;
	static ResultSet rs;
	static PreparedStatement ps;
	
	public static int generateId(String table, String col)
	{
		int id = 1;
		
		try
		{
			con = DBUtil.getConnection();
			stmt = con.createStatement();
			rs = stmt.executeQuery("select max(" + col + ") from " + table);
			
			if(rs.next())
			{
				id = rs.getInt(1) + 1;
			}
			System.out.println(id);
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		finally
		{
			DBUtil.closeAll(rs, stmt, con);
		}
		
		return id;
	}
	
	
	public static boolean executeUpdate(String qry)
	{
		try
		{
			con = DBUtil.getConnection();
			stmt = con.createStatement();
			stmt.executeUpdate(qry);
			
			return true;
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		finally
		{
			DBUtil.closeAll(null, stmt, con);
		}
		return false;
	}
}
