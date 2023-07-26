<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<%
	//create account was clicked --> create account 
	if(request.getParameter("createaccount") != null){
		try{
			//create a connection with the database
			Connection connection = ApplicationDB.getConnection();
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
			//fetch full name, username, and password from form 
			String fullname = request.getParameter("fullname"); 
			String username = request.getParameter("username"); 
			String password = request.getParameter("password"); 
			Statement checkDupAcct = connection.createStatement();
			checkDupAcct.execute("SELECT username FROM Person WHERE username='"+username+"'");
			//check whether account already exists in database
			if(fullname.equals("") || username.equals("") || password.equals("")){
				out.print("<body style='background-color: #b4ccd9;'>");
				out.print("<h2 style='text-align: center;'>Please enter valid name, username, and password.</h2>");
				out.print("<div style='text-align: center'><form><input type='submit' value='Go Back To Login' formaction='index.jsp'></form></div>");
			}
			
			else if(checkDupAcct.getResultSet().next()){
				//account already exists, prompt user to login
				out.print("<body style='background-color: #b4ccd9;'>");
				out.print("<h2 style='text-align: center;'>Account already exists. Please go back and login.</h2>");
				out.print("<div style='text-align: center'><form><input type='submit' value='Go Back To Login' formaction='index.jsp'></form></div>");
			}
			else{
				//create the account
				Statement createAcct = connection.createStatement(); 
				String insertStatement = "INSERT INTO Person(username, password, name, account_num) VALUES("+"'"+username+"',"+"'"+password+"',"+"'"+fullname+"',"+"'"+accountNum+"'"+");";
				createAcct.executeUpdate(insertStatement);
				out.print("<!DOCTYPE html><html lang='en'><head><meta charset='utf-8'><title>CS336 Travel Management System</title><meta name='description' content='Project for CS336'><meta name='author' content=''><link rel='stylesheet' href='styles.css'></head><body><div id='site_header_container'><h1 class='site_header'>CS336 Travel Management System</h1></div><div id='welcome_form_container'><form id='welcome_form'><input type='text' name='fullname' placeholder='Full Name'><br><input type='text' name='username' placeholder='Username'><br><input type='text' name='password' placeholder='Password'><br><input type='submit' name='createaccount' value='Create Account' formaction='site_access.jsp'><input type='submit' name='login' value='Login' formaction='site_access.jsp'></form></div></body></html>");
				out.print("<h2 style='text-align: center;'>Account successfully created!</h2>");
			}
			ApplicationDB.closeConnection(connection);
		}
		catch(Exception e){
			out.print(e);
		}
	}
	//login was clicked --> check account type, and forward appropriately
	else if(request.getParameter("login") != null){
		//create a connection with the database 
		Connection connection = ApplicationDB.getConnection();
		//fetch inputted username and password 
		String inputtedUsername = request.getParameter("username"); 
		String inputtedPassword = request.getParameter("password");
		//create statement to get account type for credentials inputted 
		Statement fetchAcctType = connection.createStatement(); 
		fetchAcctType.execute("SELECT account_type FROM Person WHERE username='"+inputtedUsername+"' AND password='"+inputtedPassword+"'");
		//account exists within the database
		if(fetchAcctType.getResultSet().next()){
			//set the session ID 
			String sessionID = ""; 
			if(session.getAttribute("sessionID") != null){
				sessionID = (String) session.getAttribute("sessionID");
			}
			int sessID = Integer.parseInt(sessionID);
			Statement setSess = connection.createStatement();
			setSess.executeUpdate("UPDATE Person SET logged_in="+sessID+" WHERE username='"+inputtedUsername+"'");
			//redirect to the correct page according to the account type
			int acctType = fetchAcctType.getResultSet().getInt("account_type");
			if(acctType == 0){
				response.sendRedirect("customer.jsp");
			}
			else if(acctType == 1){
				response.sendRedirect("customer_rep.jsp"); 
			}
			else{
				response.sendRedirect("admin.jsp");
			}
		}
		//account does not exist or credentials were inputted incorrectly
		else{
			out.print("<!DOCTYPE html><html lang='en'><head><meta charset='utf-8'><title>CS336 Travel Management System</title><meta name='description' content='Project for CS336'><meta name='author' content=''><link rel='stylesheet' href='styles.css'></head><body><div id='site_header_container'><h1 class='site_header'>CS336 Travel Management System</h1></div><div id='welcome_form_container'><form id='welcome_form'><input type='text' name='fullname' placeholder='Full Name'><br><input type='text' name='username' placeholder='Username'><br><input type='text' name='password' placeholder='Password'><br><input type='submit' name='createaccount' value='Create Account' formaction='site_access.jsp'><input type='submit' name='login' value='Login' formaction='site_access.jsp'></form></div></body></html>");
			out.print("<h2 style='text-align: center;'>Account does not exist or incorrect credentials have been entered. Please try again.</h2>");
		}
		ApplicationDB.closeConnection(connection);
	}
	
	//logout
	else if(request.getParameter("logout") != null){
		//make connection for the query 
		Connection connection = ApplicationDB.getConnection(); 
		//create the statment 
		Statement logout = connection.createStatement(); 
		//get the session id 
		String sessionID = ""; 
		if(session.getAttribute("sessionID") != null){
			sessionID = (String) session.getAttribute("sessionID");
		}
		int sessID = Integer.parseInt(sessionID);
		//execute the query 
		logout.execute("update Person set logged_in = -1 where logged_in = "+sessID);
		response.sendRedirect("index.jsp");
		
	}
%>