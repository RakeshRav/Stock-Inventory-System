<%@page import="Utility.DMLUtil"%>
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
<title>Sales</title>

<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
<script  src="js/jquery.autocomplete.js"></script>

<script type="text/javascript">
jQuery(function()
			{
		$("#name").autocomplete("Search.jsp");
		
	});

var product_names = new Array();
var grandqty = new Array();
var grandtotal = new Array();
var details = new Array();
var i=0;
var j=0;
var k =0;
var m = 0;
var price = 100;

	
	function getCustomer()
	{
		var company_name = document.getElementById('company_name');
		var str = "Test?company_name=";
		var url = str.concat(company_name.value);
	
		$.ajax({
			
			url: url,
			type: 'GET',
			dataType: 'json',
			data: JSON.stringify(details),
			contentType: 'application/json',
			mimeType: 'application/json',
			success: function(data){
				
			}
		});
	}

	function proceed()
	{
		
		var pageName = document.getElementById('pageName');
		var bid = document.getElementById('bid');
		var cuid = document.getElementById('cuid');
		var company_name = document.getElementById('company_name');
		
		var str = "Test?company_name=";
		
		
		var url = str.concat(company_name.value,"&cuid=",cuid.value,"&bid=",bid.value,"&page=",pageName.value);
		var url1 = "GenerateBill.jsp?bid=".concat(bid.value,"&page=",pageName.value);
		alert(url);
		$.ajax({
			url: url,
			type: 'POST',
			dataType: 'json',
			data: JSON.stringify(details),
			contentType: 'application/json',
			mimeType: 'application/json',
			success: function(data){
				window.location.href = url1;
			}
		});
	}

	function show(index)
	{
		alert(index);
	//	alert(i+" "+j+" "+k);
		var iterate_total=0;
		var iterate_qty=0;
		for(var x = 0; x<i; x++)
			{
				if(x == index)
					{
					if((x == 0 && i==1) || (x == (i-1)))
						{
						
						details[x][0] = "";
						details[x][1] = 0;
						details[x][2] = 0;
						details[x][3] = 0;
						i--;
						j--;
						k--;
						m--;
						}
					
					else
						{
						while(x< (i-1))
						{
							details[x][0] = details[x+1][0];
							details[x][1] = details[x+1][1];
							details[x][2] = details[x+1][2];
							details[x][3] = details[x+1][3];
							
						//product_names[x] = product_names[x+1];
						//grandqty[x] = grandqty[x+1];
						//grandtotal[x] = grandtotal[x+1];
						x++;
						
						
						}
						
						details[x][0] = "";
						details[x][1] = 0;
						details[x][2] = 0;
						details[x][3] = 0;
						i--;
						j--;
						k--;
						m--;
						}
					
					
					}
				
			}
		for(var l=0; l<i ; l++)
		{
		iterate_qty = iterate_qty+parseInt(details[l][1]);
		iterate_total = iterate_total+details[l][3];
		}


		
		var grandTotalId = document.getElementById('grand_total');
		var tab = document.getElementById('table');
		

		tab.innerHTML = "<thead ><tr><th>S.NO.</th><th>Product Name</th><th>Quantity</th><th>Price Per Unit</th><th>Total Price</th><th>Delete</th></tr></thead><tbody id='addlist'></tbody>"
		grandTotalId.innerHTML = "";		
		
		if(index==0 && i==0)
			{
				//alert('index');
				var pay = document.getElementById('finish');
				//alert('index');
				pay.style.display = 'none';

				
			}
		
		var add = document.getElementById('addlist');
		for(var x = 0; x<i ;x++)
			{
			
			add.innerHTML+="<tr class = 'table_row' id='"+details[x][0]+"'><td>"+(x+1)+"</td><td>"+details[x][0]+"</td><td>"+details[x][1]+"</td><td>100</td><td>"+details[x][3]+"</td><td><input type='button' name='"+(x)+"' onclick='show("+(x)+")' class='delete'  value='Delete'></td></tr>";
			
			grandTotalId.innerHTML = "<table class = 'print_table' cellpadding='5px'><tr><td>Total Quantity</td><td>:</td><td class='bold_details'>"+iterate_qty+"</td></tr><tr><td>Grand Total</td><td>:</td><td class='bold_details'>"+iterate_total+"</td></tr></table>";		
		
			}
	/*	for(var x=0;x<i;x++)
			{
			alert(product_names[x++]);
			}
*/
		//alert(i+" "+j+" "+k);
		
		//alert("last");

	}
	
	
	function onlyNumbers()
	{
		var key = event.keyCode;
		
		if(key<48 || key>57)
			{
			return false;
			}
		return true;
	}
	
	function calculatePrice()
	{
		var qty = document.forms[0].quantity;
		var price = 100;
		var total = document.forms[0].totalprice;
		total.value = price*qty.value;
		
	}
	
	function addToList()
	{
	
		
		var iterate_total=0;
		var iterate_qty=0;

		var name = document.forms[0].name;
		var product_name = document.forms[0].product_name;
		var grandTotalId = document.getElementById('grand_total');
		var qty = document.forms[0].quantity;
		var qty_number = 1;
		if(name.value=="")
			{
			alert('Enter Name');
			return false;
			}
		else if(product_name.value=="")
			{
				alert('Enter a Product Name');
				return false;
			}
		
		jQuery("#finish").css('display','block');	
		
		if(!qty.value=="")
			{
				qty_number = qty.value;
			}
		
		
		
		var index=-1;
		
		if(i!=0)
			{
				for(var z=0; z<i; z++)
					{
						if(details[z][0]==product_name.value.toLowerCase())
							{
							
								var UpdateId = document.getElementById(product_name.value.toLowerCase());
								
								index = z;
								var prevQty = details[index][1];
								
								
								qty_number = parseInt(prevQty)+parseInt(qty_number);
								details[index][1] = qty_number;
								
								details[index][2] = 100;
								
								var total = qty_number*price;
								details[index][3] = total;
								
									for(var l=0; l<i ; l++)
										{
												iterate_qty = iterate_qty+parseInt(details[l][1]);
												iterate_total = iterate_total+details[l][3];
										}
										
								
								UpdateId.innerHTML = "<td>"+(z+1)+"</td><td>"+product_name.value.toLowerCase()+"</td><td>"+qty_number+"</td><td>"+price+"</td><td>"+total+"</td><td><input type='button' name='"+(z)+"' onclick='show("+(z)+")'  value='Delete'></td>";
								
								grandTotalId.innerHTML = "<table class = 'print_table' cellpadding='5px'><tr><td>Total Quantity</td><td>:</td><td class='bold_details'>"+iterate_qty+"</td></tr><tr><td>Grand Total</td><td>:</td><td class='bold_details'>"+iterate_total+"</td></tr></table>";
							}
					}
					if(index==-1)
					{
						//product_names[i++] = product_name.value;
						//grandqty[j++]=qty_number;
						details[i] = new Array(4);
						details[i++][0]  = product_name.value.toLowerCase();
						details[j++][1]	= qty_number;
						details[k++][2] = price;
							
							var total = qty_number*price;
							//grandtotal[k++] = total;
					
							details[m++][3] = total;
							
							//window.location.replace("Sales.jsp?name="+name.value);
							
							for(var l=0; l<i ; l++)
								{
								iterate_qty = iterate_qty+parseInt(details[l][1]);
								iterate_total = iterate_total+details[l][2];
								}
					
					var add = document.getElementById('addlist');
					
					add.innerHTML+="<tr class = 'table_row' id='"+product_name.value.toLowerCase()+"'><td>"+i+"</td><td>"+product_name.value.toLowerCase()+"</td><td>"+qty_number+"</td><td>"+price+"</td><td>"+total+"</td><td><input type='button' name='"+(i-1)+"' onclick='show("+(i-1)+")'  value='Delete'></td></tr>";
					
					grandTotalId.innerHTML = "<table class = 'print_table' cellpadding='5px'><tr><td>Total Quantity</td><td>:</td><td class='bold_details'>"+iterate_qty+"</td></tr><tr><td>Grand Total</td><td>:</td><td class='bold_details'>"+iterate_total+"</td></tr></table>";		
									
					}
				
					
			}
			else
			{
				details[i] = new Array(4);
				details[i++][0] = product_name.value.toLowerCase();
				details[j++][1]=qty_number;
				details[k++][2] = price;
				
				var total = qty_number*price;
				details[m++][3] = total;
		
				//window.location.replace("Sales.jsp?name="+name.value);
				for(var l=0; l<i ; l++)
					{
					iterate_qty = iterate_qty+parseInt(details[l][1]);
					iterate_total = iterate_total+details[l][2];
					}
		
		var add = document.getElementById('addlist');
		
		add.innerHTML+="<tr class = 'table_row' id='"+product_name.value.toLowerCase()+"'><td>"+i+"</td><td>"+product_name.value.toLowerCase()+"</td><td>"+qty_number+"</td><td>"+price+"</td><td>"+total+"</td><td><input type='button' name='"+(i-1)+"' onclick='show("+(i-1)+")' value='Delete'></td></tr>";
		
		grandTotalId.innerHTML = "<table class = 'print_table' cellpadding='5px'><tr><td>Total Quantity</td><td>:</td><td class='bold_details'>"+iterate_qty+"</td></tr><tr><td>Grand Total</td><td>:</td><td class='bold_details'>"+iterate_total+"</td></tr></table>";		
			}

		function del()
		{
			alert("hiii");
			/*
			var iterate_total=0;
			var iterate_qty=0;
			for(var x = 0; x<i; x++)
				{
					if(x == index)
						{
						while(x<i)
							{
							product_names[x] = product_names[x+1];
							grandqty[x] = grandqty[x+1];
							grandtotal[x] = grandtotal[x+1];
							x++;
							}
							i--;
							j--;
							k--;
						}
					
				}
			for(var l=0; l<i ; l++)
			{
			iterate_qty = iterate_qty+parseInt(grandqty[l]);
			iterate_total = iterate_total+grandtotal[l];
			}


			var add = document.getElementById('addlist');

			for(var x = 0; x<i ;x++)
				{
				
				add.innerHTML+="<tr class = 'table_row' id='"+product_name[x]+"'><td>"+x+"</td><td>"+product_name[x]+"</td><td>"+grandqty[x]+"</td><td>100</td><td>"+grandtotal[x]+"</td><td><input type='button' name='"+(x)+"' onclick='del("+(x)+")'  value='Delete'></td></tr>";
				
				grandTotalId.innerHTML = "<table class = 'print_table' cellpadding='5px'><tr><td>Total Quantity</td><td>:</td><td class='bold_details'>"+iterate_qty+"</td></tr><tr><td>Grand Total</td><td>:</td><td class='bold_details'>"+iterate_total+"</td></tr></table>";		
			
				}*/
		}
		
		
		
		
		<%
			int price = 0;
			//String name = request.getParameter("name");
			Connection con = null;
			Statement stmt = null;
			ResultSet rs = null;
			
			
			try
			{
				con = DBUtil.getConnection();
				stmt = con.createStatement();
				//rs = stmt.executeQuery("select price from product where name = '"+name+"'");
				
				//if(rs.next())
				//{
					//price = rs.getInt("price");
				//}
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
		
		
		
		
	}
</script>

<link rel = "stylesheet" type="text/css" href="css/sales.css" >

</head>
<body>

<%
	String company_name =request.getParameter("company_name");
	String name = request.getParameter("name");
	String subheading = "Customer Details";
	String cuid = "Customer Id";
	String addAction = "AddCompany.jsp?company_name="+company_name+"&table_id=4&page=sales";
	
	if(name!=null)
	{
		if(name.equals("purchase"))
		{
			subheading = "Vendor Details";
			cuid = "Vendor Id";
			addAction = "AddCompany.jsp?company_name="+company_name+"&table_id=3&page=purchase";
			
		}
		
	}
%>

<div id="head">
	<div id="title">
	<h1>Billing Details</h1>
	</div>
	<div id="tags">
		<ul>
			<li><a href="Sales.jsp?company_name=<%=company_name%>&name=sales">Sales</a></li>
			<li><a href="Sales.jsp?company_name=<%=company_name%>&name=purchase">Purchase</a></li>
		</ul>
	</div>
</div>
<form action="GenerateBill.jsp">
<div id = "panel">
<div id = "customer" class="border">
	
	<h3 class="subheading"><%=subheading %></h3>
	<table class="tab_pad">
		<tbody>
			<tr>
				<td><input type="text"  name="name" class="input_text" id = "name"  placeholder="Name" ></td>
				<td><input type="text" name="contact" class="input_text" id = "contact" onkeypress="return onlyNumbers()" placeholder="Conatct No." autocomplete="off"></td>
				<td><input type="text" name="cuid" class="input_text" id = "cuid" placeholder="<%=cuid %>"></td>
				<td><a href="<%=addAction %>"><img alt="add" src="images/add_button.png"></a></td>
				
			</tr>
		</tbody>
	</table>
</div>
<div id="product" class="border">
	<h3 class="subheading">Product Details</h3>
	<table class="tab_pad">
		<tbody>
			<tr></tr>
			<tr>
				<td><input type="text"  name="product_name" class="input_text" id="product_name"  placeholder="Product Name"></td>
				<td><input type="text" name="quantity" class="input_text"  onkeypress="return onlyNumbers()" onkeyup="calculatePrice()" placeholder="Enter Quantity"></td>
				<td><input type="text" name="totalprice" class="input_text"  onkeypress="return onlyNumbers()" placeholder="Price" ></td>
				<td><input type="button" value="Add to List" onclick="return addToList()" id="add"></td>
				<%
				if(name!=null)
				{
					if(name.equals("purchase"))
					{
						
						%>
						<td><a href="AddCompany.jsp?company_name=<%=company_name%>&table_id=1&page=purchase"><img alt="add" src="images/add_button.png"></a></td>
				
						<% 
					}
					
				}
				%>
				
				
			</tr>
		</tbody>
	</table>
</div>
<div id ="list">
	<table id = "table" border="1px" bordercolor="rgb(2, 94, 129)" cellpadding="5px" cellspacing="0" >
	
		<thead >
			<tr>
				<th>S.NO.</th>
				<th>Product Name</th>
				<th>Quantity</th>
				<th>Price Per Unit</th>
				<th>Total Price</th>
				<th>Delete</th>
			</tr>
		</thead>
		<tbody id="addlist">
		
		</tbody>
	
	</table>
	
</div>
</div>
<div id = "bill">
	
	<div id = "grand_total" class="details_div">
	
	</div>
	<div>
	<input type="button" value="Proceed To Pay" id="finish" onclick="proceed()">
	<input type="text" value="<%=company_name%>" id="company_name" style="display: none;">
	<input type="text" value="<%=name%>" id="pageName" style="display: none;">
	<%
		int bid = DMLUtil.generateId(name, "bid");
	%>
	<input type="text" value="<%=bid%>" id="bid" style="display: none;">
	</div>
</div>
</form>

</body>
</html>