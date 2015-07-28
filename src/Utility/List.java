package Utility;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;

import Servlets.Test;

public class List
{
	
	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	public ArrayList<Integer> bid = new ArrayList<Integer>();
	public ArrayList<String> cuid = new ArrayList<>();
	public ArrayList<String> company_name = new ArrayList<>();
	public ArrayList<String> date = new ArrayList<>();
	
	public boolean getData(String type, String day , String view, String companyName) {
	
		
		String date1;
		Test t = new Test();
		Date d = new Date();
		//System.out.println(d.getYear());
		date1 = d.getDate()+" "+t.getMonth(d.getMonth())+","+(d.getYear()+1900);

		if(day.equals("today"))
		{
			
		
	
			try
			{
				con = DBUtil.getConnection();
				stmt = con.createStatement();
				
				if(companyName.equals("admin"))
				{
				rs = stmt.executeQuery("select * from showlist where type = '"+type+"' and date1 = '"+date1+"'");
				}
				else
				{
					rs = stmt.executeQuery("select * from showlist where type = '"+type+"' and company_name='"+companyName+"' and date1 = '"+date1+"'");
				}
				
				if (rs.next()) {
					
					do {
						
						bid.add(rs.getInt(1));
						cuid.add(rs.getString(2));
						company_name.add(rs.getString(3)); 
						date.add(rs.getString(4));
				
					}while (rs.next());
				
				return true;
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
		}
		else {
//				String date_value;
//				
//				Date d = new Date();
//			
//				if(d.getDate() < 10)
//				{
//					date_value = "0"+d.getDate();
//				}
//				else
//				{
//					date_value = d.getDate()+"";
//				}
//				if((d.getMonth()+1) < 10)
//				{
//					date_value = date_value+"0"+(d.getMonth()+1)+(d.getYear()+1900);
//					
//				}
//				else
//				{
//					date_value = date_value+(d.getMonth()+1)+""+(d.getYear()+1900);
//				}	
//				
//				String d1="" ;
//				char c;
//				for (int i = date_value.length(); i >=0 ; i--)
//				{
//					c = date_value.charAt(i);
//					d1 = d1+c;
//				}
//				int date1 = Integer.parseInt(d1);
//		
				
				try
				{
					con = DBUtil.getConnection();
					stmt = con.createStatement();
		
					if(companyName.equals("admin"))
					{
					rs = stmt.executeQuery("select * from showlist where type = '"+type+"'");
					}
					else
					{
						rs = stmt.executeQuery("select * from showlist where type = '"+type+"' and company_name='"+companyName+"'");
					}
			
					
					if (rs.next()) {
						
						do {
							
							bid.add(rs.getInt(1));
							cuid.add(rs.getString(2));
							company_name.add(rs.getString(3));
							date.add(rs.getString(4));
					
						}while (rs.next());
					
					return true;
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
			
		
		}
		return false;
	}
}
