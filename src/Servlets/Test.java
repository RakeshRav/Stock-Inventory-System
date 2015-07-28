package Servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Utility.DBUtil;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;

/**
 * Servlet implementation class Test
 */
public class Test extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Test() {
        super();
        
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    PreparedStatement ps = null;
    
    String company_name = null;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		System.out.println("get");
		company_name  = request.getParameter("company_name");
		System.out.println(company_name);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	//	response.sendRedirect("DashBoard.jsp?company_name=admin");

		company_name  = request.getParameter("company_name");
		String cuid = request.getParameter("cuid");
		int bid = Integer.parseInt(request.getParameter("bid"));
		
		String page = request.getParameter("page");
		String table_name = page;
		System.out.println(bid);
		System.out.println(cuid);
		System.out.println(company_name);
		System.out.println("post");
		BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
		
		String json = "";
		String mainString,temp="";
		
		
		ArrayList<String> arr = new ArrayList<String>();
		ArrayList<String> product_names = new ArrayList<String>();
		ArrayList<Integer> qty = new ArrayList<Integer>();
		ArrayList<Double> ppu = new ArrayList<Double>();
		ArrayList<Double> total = new ArrayList<Double>();
		
		
		
		if(br != null)
		{
			json = br.readLine();
			System.out.println(json);
			
			JsonParser jsonParser = new JsonParser();
			
			JsonArray array = (JsonArray)jsonParser.parse(json);
			
			for(int i = 0; i < array.size(); i++)
			{
				int length = array.get(i).toString().length();
				arr.add(array.get(i).toString().substring(1, length-1));
				System.out.println(arr.get(i));
				
			}
			
			for (int i = 0; i < arr.size(); i++) 
			{
				int j = 0;
				mainString = arr.get(i).substring(1,arr.get(i).length());
				char c = mainString.charAt(j++);
				
				while(c != '"')
				{
					temp = temp+c;
					c= mainString.charAt(j++);
					
				}
				
				product_names.add(temp);
				temp = "";
				//System.out.println(j);
				j++;	// for skipping ','
				
				c = mainString.charAt(j++);
				while (c != ',')
				{
					temp = temp+c;
					c= mainString.charAt(j++);
				}
				qty.add(Integer.parseInt(temp));
				//System.out.println(j);
				
				temp="";
				
				

				c = mainString.charAt(j++);
				while (c != ',')
				{
					temp = temp+c;
					c= mainString.charAt(j++);
				}
				ppu.add(Double.parseDouble(temp));
				//System.out.println(j);
				
				temp="";

				temp = mainString.substring(j,mainString.length());
				total.add(Double.parseDouble(temp));
				//System.out.println(j);
				temp=""; 
			}
			
			for (int i = 0; i < product_names.size(); i++) {
				System.out.println(product_names.get(i));
				System.out.println(qty.get(i));
				System.out.println(ppu.get(i));
				System.out.println(total.get(i));
				
			}
			
			String date,date_value;
			
			Date d = new Date();
			//System.out.println(d.getYear());
			date = d.getDate()+" "+getMonth(d.getMonth())+","+(d.getYear()+1900);
			
			if(d.getDate() < 10)
			{
				date_value = "0"+d.getDate();
			}
			else
			{
				date_value = d.getDate()+"";
			}
			if((d.getMonth()+1) < 10)
			{
				date_value = date_value+"0"+(d.getMonth()+1)+(d.getYear()+1900);
				
			}
			else
			{
				date_value = date_value+(d.getMonth()+1)+""+(d.getYear()+1900);
			}	
			
			String d1="" ;
			char c;
			for (int i = date_value.length()-1; i >=0 ; i--)
			{
				c = date_value.charAt(i);
				d1 = d1+c;
			}
			int date1 = Integer.parseInt(d1);
			
			//System.out.println(date);
			
			//response.sendRedirect("GenerateBill.jsp");
			
			for (int i = 0; i < arr.size(); i++)
			{
			
				if (!product_names.get(i).equals(""))
				{
					
					try {
						con = DBUtil.getConnection();
						ps = con.prepareStatement("insert into "+table_name+" values(?,?,?,?,?,?,?,?,?)");
						ps.setInt(1, bid);
						ps.setString(2, cuid);
						ps.setString(3, company_name);
						ps.setString(4, product_names.get(i));
						ps.setInt(5, qty.get(i));
						ps.setDouble(6, ppu.get(i));
						ps.setDouble(7, total.get(i));
						ps.setString(8, date);
						ps.setInt(9, date1);
						
						ps.executeUpdate();					
						
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					finally
					{
						DBUtil.closeAll(rs, ps, con);
					}
				}
				
			}
			

			try {
				con = DBUtil.getConnection();
				ps = con.prepareStatement("insert into showlist values(?,?,?,?,?,?)");
				ps.setInt(1, bid);
				ps.setString(2, cuid);
				ps.setString(3, company_name);
				ps.setString(4, date);
				ps.setString(5, page);
				ps.setInt(6, date1);
				ps.executeUpdate();					
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			finally
			{
				DBUtil.closeAll(rs, ps, con);
			}
		
				
			
			
		}
	}

	public String getMonth(int m) 
	{
		// TODO Auto-generated method stub
		
		switch (m) {
		case 0:
			return "January";
		case 1:
			return "February";
		case 2:
			return "March";
		case 3:
			return "April";
		case 4:
			return "May";
		case 5:
			return "June";
		case 6:
			return "July";
		case 7:
			return "August";
		case 8:
			return "September";
		case 9:
			return "October";
		case 10:
			return "November";
		case 11:
			return "December";
		}
		return "";
	}

}
