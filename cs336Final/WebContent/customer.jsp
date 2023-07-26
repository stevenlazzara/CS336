<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
    
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>CS336 TMS - Customer</title>
  <meta name="description" content="Project for CS336">
  <link rel="stylesheet" href="styles.css">
</head>
<body>
	
	<div id="flight_search_header_container">
		<h1 id="flight_search_header">Search Flights</h1>
	</div>
	<div id="back_to_flight_search_container">
		<form id="back_to_flight_search_form">
			<input type="submit" name="logout" value="Logout" formaction="site_access.jsp">
		</form>
	</div>
	
	<div id="flight_search_dropdown_container">
		<select name="flighttype" form="flight_search_form">
			<option>One-Way</option>
			<option>Round-Trip</option>
		</select>
		<select name="seatclass" form="flight_search_form">
			<option>Economy</option>
			<option>Business</option>
			<option>First- Class</option>
		</select>
		<select name="flexibility" form="flight_search_form">
			<option>Flexible</option>
			<option>Not-Flexible</option>
		</select>
	</div>
	
	<div id="flight_search_text_container">
		<form id="flight_search_form">
			<input type="text" name="departureairport" placeholder="Departure Airport">
			<input type="text" name="destinationairport" placeholder="Destination Airport">
			<input type="text" name="departuredate" placeholder="YYYY-MM-DD Depart">
			<input type="text" name="returndate" placeholder="YYYY-MM-DD Return"><br>
			<input type="submit" name="searchflights" value="Search Flights" formaction="flight_administration.jsp">
		</form>
	</div>
	
	<div id="my_reservations_header_container">
		<h1 id="my_reservations_header">My Reservations</h1>
	</div>
	
	<div id="my_reservations_form_container">
		<form id="my_reservations_form">
			<input type="submit" name="getmyreservations" value="Get Reservations" formaction="reservation_administration.jsp">
		</form>
	</div>
	
</body>
</html>

