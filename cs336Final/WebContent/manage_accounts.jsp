<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>CS336 TMS - Manage Accounts</title>
  <meta name="description" content="Project for CS336">
  <meta name="author" content="">
  <link rel="stylesheet" href="styles.css">
</head>

<body>
	
	<div id="manage_accounts_page_header_container" style="text-align: center;">
		<h1 style="text-align: center;">Manage Accounts</h1>
	</div>
	<div id="back_to_flight_search_container">
		<form id="back_to_flight_search_form">
			<input type="submit" value="Back To Admin Homepage" formaction="admin.jsp">
			<input type="submit" name="logout" value="Logout" formaction="site_access.jsp">
		</form>
	</div>
	<div id="manage_accounts_select_action_container" style="text-align: center;">
		<h5>Select account option:</h5>
		<select id="manage_accounts_select_action" name="selectaction" form="manage_accounts_select_action_form">
			<option>Customer - Add Account</option>
			<option>Customer Rep - Add Account</option>
			<option>Modify Account</option>
			<option>Delete Account</option>
		</select>
		<form id="manage_accounts_select_action_form">
			<input type="submit" name="submitaccountaction" value="Select" formaction="manage_accounts.jsp">
		</form>
	</div>
	

	
	<%
		//select was clicked 
		if(request.getParameter("submitaccountaction") != null){
			//fetch the account action option from the user
			String optionSelected = (String) request.getParameter("selectaction"); 
			//save the option selected 
			session.setAttribute("accountAction", optionSelected);
			//display the correct form to the user 
			//add account 
			if(optionSelected.equals("Customer - Add Account") || optionSelected.equals("Customer Rep - Add Account")){
				out.print("<div id='manage_accounts_add_form_container' style='text-align: center; margin-top: 20px;'><form id='manage_accounts_add_form'><input type='text' name='fullname' placeholder='Full Name'><input type='text' name='username' placeholder='Username'><input type='text' name='password' placeholder='Password'><br><input type='submit' name='addaccount' value='Add Account' formaction='manage_accounts.jsp'></form></div>");
			}
			//modify account 
			else if(optionSelected.equals("Modify Account")){
				out.print("<div id='manage_accounts_modify_form_container' style='text-align: center; margin-top: 20px;'><form id='manage_accounts_modify_form'><input type='text' name='accountnumber' placeholder='Account Number'><input type='text' name='fullname' placeholder='Full Name'><input type='text' name='username' placeholder='Username'> <input type='text' name='password' placeholder='Password'><br><input type='submit' name='modifyaccount' value= 'Modify Account' formaction='manage_accounts.jsp'></form></div>");
			}
			//delete account 
			else{
				out.print("<div id='manage_accounts_delete_form_container' style='text-align: center; margin-top: 20px;'><form id='manage_accounts_delete_form'><input type='text' name='accountnumber' placeholder='Account Number'><br><input type='submit' name='deleteaccount' value= 'Delete Account' formaction='manage_accounts.jsp'></form></div>");
			}
		}
	
		//add account 
		else if(request.getParameter("addaccount") != null){
			//create database connection
			Connection connection = ApplicationDB.getConnection();
			//determine the option selected for customer or customer rep 
			String optionSelected = (String) session.getAttribute("accountAction"); 
			//fetch the data from the form 
			String name = (String) request.getParameter("fullname"); 
			String username = (String) request.getParameter("username"); 
			String password = (String) request.getParameter("password");
			//fetch the max account number 
			//create the sql statement for fetching max account number already in DB 
			Statement fetchMaxAcctNum = connection.createStatement(); 
			//get the largest account number already in the DB 
			fetchMaxAcctNum.execute("SELECT MAX(account_num) FROM Person");  
			int accountNum = -1; 
			if(fetchMaxAcctNum.getResultSet().next()){
				accountNum = fetchMaxAcctNum.getResultSet().getInt(1)+1; 
			}
			else{
				accountNum = 1;
			}
			String accountType = ""; 
			//determine account type 
			if(optionSelected.equals("Customer - Add Account")){
				accountType = "0";
			}
			else{
				accountType = "1";
			}
			//create statement to add account
			Statement addAccount = connection.createStatement(); 
			String insertStatement = "INSERT INTO Person(username, password, name, account_num, account_type) VALUES('"+username+"','"+password+"','"+name+"','"+accountNum+"','"+accountType+"')";
			//execute the query 
			addAccount.executeUpdate(insertStatement);
			out.print("<div id='manage_accounts_add_form_container' style='text-align: center; margin-top: 20px;'><form id='manage_accounts_add_form'><input type='text' name='fullname' placeholder='Full Name'><input type='text' name='username' placeholder='Username'><input type='text' name='password' placeholder='Password'><br><input type='submit' name='addaccount' value='Add Account' formaction='manage_accounts.jsp'></form></div>");
			out.print("<h3 style='text-align: center;'>Account has successfully been added!</h3>");
			//close the connection 
			ApplicationDB.closeConnection(connection);
		}
	
		//modify account
		else if(request.getParameter("modifyaccount") != null){
			//create database connection 
			Connection connection = ApplicationDB.getConnection(); 
			//fetch the data from the user 
			String accountNumber = (String) request.getParameter("accountnumber");
			String name = (String) request.getParameter("fullname"); 
			String username = (String) request.getParameter("username"); 
			String password = (String) request.getParameter("password");
			//create the sql statement to modify the account 
			Statement modifyAccount = connection.createStatement(); 
			//create the query 
			String query = "UPDATE Person set name='"+name+"', username='"+username+"', password='"+password+"' where account_num="+accountNumber;
			//execute the query 
			modifyAccount.executeUpdate(query); 
			//keep the form on the page 
			out.print("<div id='manage_accounts_modify_form_container' style='text-align: center; margin-top: 20px;'><form id='manage_accounts_modify_form'><input type='text' name='accountnumber' placeholder='Account Number'><input type='text' name='fullname' placeholder='Full Name'><input type='text' name='username' placeholder='Username'> <input type='text' name='password' placeholder='Password'><br><input type='submit' name='modifyaccount' value= 'Modify Account' formaction='manage_accounts.jsp'></form></div>");
			//print result message 
			out.print("<h3 style='text-align: center;'>Account "+accountNumber+" has been successfully modified!"+"</h3>");
			//close the database connection
		}
	
		//delete account 
		else if(request.getParameter("deleteaccount") != null){
			//create database connection 
			Connection connection = ApplicationDB.getConnection(); 
			//fetch the data from the user 
			String accountNumber = (String) request.getParameter("accountnumber");
			//create statement 
			Statement deleteAccount = connection.createStatement(); 
			//create query 
			String query = "delete from Person where account_num = "+accountNumber;
			//execute the query 
			deleteAccount.executeUpdate(query); 
			//print the form
			out.print("<div id='manage_accounts_delete_form_container' style='text-align: center; margin-top: 20px;'><form id='manage_accounts_delete_form'><input type='text' name='accountnumber' placeholder='Account Number'><br><input type='submit' name='deleteaccount' value= 'Delete Account' formaction='manage_accounts.jsp'></form></div>");
			//print result message
			out.print("<h3 style='text-align: center;'>Account "+accountNumber+" has been successfully deleted!"+"</h3>");
			//close the database connection
		}
	%>
		
</body>
</html>