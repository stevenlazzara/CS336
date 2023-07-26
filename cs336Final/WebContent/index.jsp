<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	int min = 1; 
	int max = 2000000; 
	int sessionId = (int) (Math.random() * ((max-min) + 1)) + min; 
	session.setAttribute("sessionID", Integer.toString(sessionId)); 
	
	ArrayList<String> queries = new ArrayList<String>(); 
	session.setAttribute("queries", queries);
	
	ArrayList<String> reservationQueries = new ArrayList<String>(); 
	session.setAttribute("reservationQueries", reservationQueries);

%>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>CS336 Travel Management System</title>
  <meta name="description" content="Project for CS336">
  <meta name="author" content="">
  <link rel="stylesheet" href="styles.css">

</head>

<body>
  
  <div id="site_header_container">
  	<h1 class="site_header">CS336 Travel Management System</h1>
  </div>
  
  <div id="welcome_form_container">
  	<form id="welcome_form">
  		<input type="text" name="fullname" placeholder="Full Name"><br>
  		<input type="text" name="username" placeholder="Username"><br>
  		<input type="text" name="password" placeholder="Password"><br>
  		<input type="submit" name="createaccount" value="Create Account" formaction="site_access.jsp">
  		<input type="submit" name="login" value="Login" formaction="site_access.jsp">
  	</form>
  </div>   
</body>
</html>

