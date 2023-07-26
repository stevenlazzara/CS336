<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>CS336 TMS - Admin</title>
  <meta name="description" content="Project for CS336">
  <meta name="author" content="">
  <link rel="stylesheet" href="styles.css">
</head>

<body>
	<div id="back_to_flight_search_container" style="margin-top: 50px;">
		<form id="back_to_flight_search_form">
			<input type="submit" name="logout" value="Logout" formaction="site_access.jsp">
		</form>
	</div>
	<div id="manage_accounts_header_container" style="text-align: center;">
		<h1 id="manage_accounts_header">Manage Accounts</h1>
	</div>

	<div id="manage_accounts_form_container" style="text-align: center;">
		<form id="manage_accounts_form">
			<input type="submit" name="manageaccounts" value="Manage Accounts" formaction="manage_accounts.jsp">
		</form>
	</div>
	
	<div id="summaries_reports_header_container" style="text-align: center;">
		<h1>Summaries and Reports</h1>
	</div>
	<div id="summaries_reports_container" style="text-align: center;">
		<select name="summariesreports" form="summaries_reports_form">
			<option>Sales Report</option>
			<option>Flight Reservations List</option>
			<option>Revenue Summary</option>
			<option>Customer - Largest Revenue</option>
			<option>Most Active Flights List</option>
			<option>Airport Flights List</option>
		</select>
		<form id="summaries_reports_form">
			<input type="submit" name="getsummaryorreport" value="Select" formaction="admin.jsp">
		</form>
	</div>	
	
	<%
		//if the admin selects Sales Report 
		if(request.getParameter("getsummaryorreport") != null){
			//get the option selected 
			String option = (String) request.getParameter("summariesreports"); 
			//set it as a session attribute 
			session.setAttribute("summaryReportOption", option);	
			//get the sales report for a particular month
			if(option.equals("Sales Report")){
				out.print("<h5 style='text-align: center;'>Option Selected: "+option+"</h5>");
				out.print("<div id='sales_report_month_select_container' style='text-align: center; margin-top: 20px;'><select name='reportmonth' form='fetch'><option>January</option><option>February</option><option>March</option><option>April</option><option>May</option><option>June</option><option>July</option><option>August</option><option>September</option><option>October</option><option>November</option><option>December</option></select></div>");
				out.print("	<div id='fetch_form_container' style='text-align: center;'><form id='fetch'><input type='submit' name='fetch' value='Fetch' formaction='summaries_reports.jsp'></form></div>");
			}
			//get flight reservations list 
			else if(option.equals("Flight Reservations List")){
				out.print("<h5 style='text-align: center;'>Option Selected: "+option+"</h5>");
				out.print("<div id='fetch_form_container' style='text-align: center; margin-top: 20px;'><form id='fetch'><input type='text' name='flightreservationsflightnumber' placeholder='Flight Number'><span>or</span><input type='text' name='flightreservationscustomername' placeholder='Customer Name'><br><input type='submit' name='fetch' value='Fetch' formaction='summaries_reports.jsp'></form></div>");
			}
			//get revenue summary 
			else if(option.equals("Revenue Summary")){
				out.print("<h5 style='text-align: center;'>Option Selected: "+option+"</h5>");
				out.print("<div id='fetch_form_container' style='text-align: center; margin-top: 20px;'><form id='fetch'><input type='text' name='revenuesummaryflightnumber' placeholder='Flight Number'><span>or</span><input type='text' name='revenuesummaryairline' placeholder='Airline ID'><span>or</span><input type='text' name='revenuesummarycustomer' placeholder='Customer Name'><br><input type='submit' name='fetch' value='Fetch' formaction='summaries_reports.jsp'></form></div>");
			}
			//get customer with largest revenue 
			else if(option.equals("Customer - Largest Revenue")){
				out.print("<h5 style='text-align: center;'>Option Selected: "+option+"</h5>");
				out.print("	<div id='fetch_form_container' style='text-align: center; margin-top: 20px;'><form id='fetch'><input type='submit' name='fetch' value='Fetch' formaction='summaries_reports.jsp'></form></div>");
			}
			//most active flights list 
			else if(option.equals("Most Active Flights List")){
				out.print("<h5 style='text-align: center;'>Option Selected: "+option+"</h5>");
				out.print("	<div id='fetch_form_container' style='text-align: center; margin-top: 20px;'><form id='fetch'><input type='submit' name='fetch' value='Fetch' formaction='summaries_reports.jsp'></form></div>");
			}
			else if(option.equals("Airport Flights List")){
				out.print("<h5 style='text-align: center;'>Option Selected: "+option+"</h5>");
				out.print("<div id='fetch_form_container' style='text-align: center; margin-top: 20px;'><form id='fetch'><input type='text' name='airportflightslistairport' placeholder='Airport ID'><br><input type='submit' name='fetch' value='Fetch' formaction='summaries_reports.jsp'></form></div>");
			}
		}
	%>
	
	
	

</body>
</html>