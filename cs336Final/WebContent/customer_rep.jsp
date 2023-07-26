<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>CS336 TMS - Customer_Rep</title>
  <meta name="description" content="Project for CS336">
  <link rel="stylesheet" href="styles.css">
</head>
<body>
	
	<div id="make_resrvations_header_container">
		<h1 id="make_reservations_header" style="text-align: center;">Customer Information</h1>
	</div>
	<div id="back_to_flight_search_container">
		<form id="back_to_flight_search_form">
			<input type="submit" name="logout" value="Logout" formaction="site_access.jsp">
		</form>
	</div>
	
	<div id="customer_information_dropdown_container" style="text-align: center">
		<h5>Select an option on behalf of the customers:</h5>
		<select id="customer_info" name="customerinfo" form="customer_rep_select_action_form">
			<option>Make Reservation For A Customer</option>
			<option>Edit Reservation For A Customer </option>
			<option>View Waitlist For A Flight</option>
			<option>Add, Edit, Delete - Aircraft</option>
			<option>Add, Edit, Delete - Airport</option>
			<option>Add - Flights</option>
			<option>Edit - Flights</option>
			<option>Delete - Flights</option>
		</select>
		<br>
		<form id="customer_rep_select_action_form">
			<input type="submit" name="submitcustomerrepaction" 
			value="Select" formaction="customer_rep.jsp">
		</form>
	</div>
	
	<%
		// if select was clicked
		if (request.getParameter("submitcustomerrepaction") != null) {
			// get the option selected and set it as the select action attribute
			String optionSelected = (String) request.getParameter("customerinfo"); 
			session.setAttribute("accountAction", optionSelected); 
			
			// Make Reservation For A Customer
			if (optionSelected.equals("Make Reservation For A Customer")) {
				// print out the information to query flights
				out.print("<div id='flight_search_dropdown_container'><select name='flighttype' form='flight_search_form'><option>One-Way</option><option>Round-Trip</option></select><select name='seatclass' form='flight_search_form'><option>Economy</option><option>Business</option><option>First- Class</option></select><select name='flexibility' form='flight_search_form'><option>Flexible</option><option>Not-Flexible</option></select></div><div id='flight_search_text_container'><form id='flight_search_form'><input type='text' name='departureairport' placeholder='Departure Airport'><input type='text' name='destinationairport' placeholder='Destination Airport'><input type='text' name='departuredate' placeholder='YYYY-MM-DD Depart'><input type='text' name='returndate' placeholder='YYYY-MM-DD Return'><br><input type='submit' name='searchflights' value='Search Flights' formaction='customer_rep.jsp'></form></div>");
				//out.print("<div id='flight_search_dropdown_container'><select name='flighttype' form='flight_search_form'><option>One-Way</option><option>Round-Trip</option></select><select name='seatclass' form='flight_search_form'><option>Economy</option><option>Business</option><option>First- Class</option></select><select name='flexibility' form='flight_search_form'><option>Flexible</option><option>Not-Flexible</option></select></div><div id='flight_search_text_container'><form id='flight_search_form'><input type='text' name='departureairport' placeholder='Departure Airport'><input type='text' name='destinationairport' placeholder='Destination Airport'><input type='text' name='departuredate' placeholder='YYYY-MM-DD Depart'><input type='text' name='returndate' placeholder='YYYY-MM-DD Return'><br><input type='submit' name='searchflights' value='Search Flights' formaction='customer_rep.jsp'></form></div>");
	
			// Edit Reservation For A Customer
			} else if (optionSelected.equals("Edit Reservation For A Customer")) {
				// gives user information to query their own reservations
				out.print("<div id='my_reservations_header_container'><h1 id='my_reservations_header'>My Reservations</h1></div><div id='my_reservations_form_container'><form id='my_reservations_form'><input type='text' name='accountnum' placeholder='Account Number'><br><input type='submit' name='getmyreservations' value='Get Reservations' formaction='customer_rep.jsp'></form></div>"); 
				
			// View Waitlist For A Flight
			} else if (optionSelected.equals("View Waitlist For A Flight")){
				// gives inputs for user to enter
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Waitlist</h1></div><div id='my_waitlist_form_container' style='text-align: center;'><form id='my_waitlist_form'><input type='text' name='flightnumber' placeholder='Flight Number'><br><input type='submit' name='searchwaitlist' value='Search Waitlist' formaction='customer_rep.jsp'></form></div>"); 
		
			} else if (optionSelected.equals("Add, Edit, Delete - Aircraft")) {
				// gives inputs for user to enter
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Add, Edit, Delete - Aircraft</h1></div><div id='my_waitlist_form_container' style='text-align: center;'><form id='my_waitlist_form'><input type='text' name='aircraftid' placeholder='Aircraft ID'><br><input type='submit' name='addaircraft' value='Add Aircraft' formaction='customer_rep.jsp'><input type='submit' name='editaircraft' value='Edit Aircraft' formaction='customer_rep.jsp'><input type='submit' name='deleteaircraft' value='Delete Aircraft' formaction='customer_rep.jsp'></form></div>"); 
				// display the new table
				Connection connection = ApplicationDB.getConnection(); 
				Statement searchAircrafts = connection.createStatement();
				searchAircrafts.execute("SELECT * from Aircraft"); 
				ResultSet rs = searchAircrafts.getResultSet();
				//print the results and print the table again
				out.print("<table name='insertAircraftresults' border=2 align='center'><tr><td>Aircraft ID</td></tr>");
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("aircraft_id")+"</td></tr>");
				}
						
			} else if (optionSelected.equals("Add, Edit, Delete - Airport")) {
				// gives inputs for user to enter
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Add, Edit, Delete - Airport</h1></div><div id='my_waitlist_form_container' style='text-align: center;'><form id='my_waitlist_form'><input type='text' name='airportid' placeholder='Airport ID'><br><input type='submit' name='addairport' value='Add Airport' formaction='customer_rep.jsp'><input type='submit' name='editairport' value='Edit Airport' formaction='customer_rep.jsp'><input type='submit' name='deleteairport' value='Delete Airport' formaction='customer_rep.jsp'></form></div>"); 
				// display the new table
				Connection connection = ApplicationDB.getConnection(); 
				Statement searchAirports = connection.createStatement();
				searchAirports.execute("SELECT * from Airport"); 
				ResultSet rs = searchAirports.getResultSet();
				//print the results and print the table again
				out.print("<table name='insertAirportResults' border=2 align='center'><tr><td>Airport ID</td></tr>");
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("airport_id")+"</td></tr>");
				}
						
			} else if (optionSelected.equals("Add - Flights")) {
				// gives inputs for user to enter
				out.print("<div id='flight_search_dropdown_container'><select name='flighttype' form='flight_search_form'><option>One-Way</option><option>Round-Trip</option></select></div><div id='flight_search_text_container'><form id='flight_search_form'><input type='text' name='aircraftid' placeholder='Aircraft ID'><input type='text' name='airlineid' placeholder='Airline ID'><input type='text' name='airportid' placeholder='Airport ID'><input type='text' name='flightnumber' placeholder='Flight Number'><br><input type='text' name='numstops' placeholder='Number of Stops'><input type='text' name='departtime' placeholder='Depart Time'><input type='text' name='arrivaltime' placeholder='Arrival Time'><br><input type='text' name='farefirst' placeholder='First Class Fare'><input type='text' name='farebusiness' placeholder='Business Class Fare'><input type='text' name='fareeconomy' placeholder='Economy Fare'><br><input type='text' name='departureairport' placeholder='Departure Airport'><input type='text' name='destinationairport' placeholder='Destination Airport'><input type='text' name='departuredate' placeholder='YYYY-MM-DD Depart'><input type='text' name='returndate' placeholder='YYYY-MM-DD Return'><br><input type='submit' name='addflight' value='Add Flight' formaction='customer_rep.jsp'></form></div>");
			} else if (optionSelected.equals("Edit - Flights")) {
				Connection connection = ApplicationDB.getConnection();
				Statement getAllFlights = connection.createStatement(); 
				getAllFlights.execute("SELECT * from Flight_Operates"); 
				ResultSet rs2 = getAllFlights.getResultSet(); 
				//print the table again
				out.print("<table name='flightresults' border=2 align='center'><tr><td>Aircraft ID</td><td>Airline ID</td><td>Airport ID</td><td>Flight Number</td><td>Flight Type</td><td>Depart Time</td><td>Arrival Time</td><td>Fare Economy</td><td>Fare First Class</td><td>Fare Business</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Depart Date</td><td>Return Date</td></tr>");
				while(rs2.next()){
					out.print("<tr><td>"+rs2.getString("aircraft_id")+"</td><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("airport_id")+"</td><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("flight_type")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("fare_economy")+"</td><td>"+rs2.getString("fare_first")+"</td><td>"+rs2.getString("fare_business")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("num_stops")+"</td><td>"+rs2.getString("depart_date")+"</td><td>"+rs2.getString("return_date")+"</td></tr>");
				}
				// gives inputs for user to enter
				out.print("<div id='flight_search_text_container'><form id='flight_search_form'><br><input type='text' name='flightnumber' placeholder='Flight Number'><input type='text' name='airlineid' placeholder='Airline ID'><br><h9>Input the flight number and airline id of the flight that you would like to edit</h9><br><div id='flight_search_dropdown_container'><select name='flighttype' form='flight_search_form'><option>One-Way</option><option>Round-Trip</option></select></div><input type='text' name='numstops' placeholder='Number of Stops'><input type='text' name='departtime' placeholder='Depart Time'><input type='text' name='arivaltime' placeholder='Arival Time'><br><input type='text' name='farefirst' placeholder='First Class Fare'><input type='text' name='farebusiness' placeholder='Business Class Fare'><input type='text' name='fareeconomy' placeholder='Economy Fare'><br><input type='text' name='departuredate' placeholder='YYYY-MM-DD Depart'><input type='text' name='returndate' placeholder='YYYY-MM-DD Return'><br><input type='submit' name='editflight' value='Edit Flight' formaction='customer_rep.jsp'></form></div>");
			 }else if (optionSelected.equals("Delete - Flights")) {
				Connection connection = ApplicationDB.getConnection();
				Statement getAllFlights = connection.createStatement(); 
				getAllFlights.execute("SELECT * from Flight_Operates"); 
				ResultSet rs2 = getAllFlights.getResultSet(); 
				//print the table again
				out.print("<table name='flightresults' border=2 align='center'><tr><td>Aircraft ID</td><td>Airline ID</td><td>Airport ID</td><td>Flight Number</td><td>Flight Type</td><td>Depart Time</td><td>Arrival Time</td><td>Fare Economy</td><td>Fare First Class</td><td>Fare Business</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Depart Date</td><td>Return Date</td></tr>");					while(rs2.next()){
					out.print("<tr><td>"+rs2.getString("aircraft_id")+"</td><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("airport_id")+"</td><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("flight_type")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("fare_economy")+"</td><td>"+rs2.getString("fare_first")+"</td><td>"+rs2.getString("fare_business")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("num_stops")+"</td><td>"+rs2.getString("depart_date")+"</td><td>"+rs2.getString("return_date")+"</td></tr>");
				}
				// gives inputs for user to enter
				out.print("<div id='flight_search_text_container'><form id='flight_search_form'><br><input type='text' name='flightnumber' placeholder='Flight Number'><input type='text' name='airlineid' placeholder='Airline ID'><br><input type='submit' name='deleteflight' value='Delete Flight' formaction='customer_rep.jsp'></form></div>");
			}
		
		} else if (request.getParameter("searchflights") != null) {
			//get the parameters of the form 
			String flightType = request.getParameter("flighttype"); 
			//adjust to match db format
			if(flightType.equals("Round-Trip")){
				flightType = "r";
			}
			else{
				flightType = "o";
			}
			String seatClass = request.getParameter("seatclass"); 
			//adjust to match db format 
			if(seatClass.equals("Economy")){
				seatClass = "e";
			}
			else if(seatClass.equals("Business")){
				seatClass = "b"; 
			}
			else{
				seatClass = "f";
			}
			String flexibility = request.getParameter("flexibility"); 
			String dptAirport = request.getParameter("departureairport"); 
			String dstAirport = request.getParameter("destinationairport");
			String dptDate = request.getParameter("departuredate"); 
			String rtnDate = request.getParameter("returndate"); 
			//create connection with the database 
			Connection connection = ApplicationDB.getConnection(); 
			//create query statement 
			Statement searchFlights = connection.createStatement();
			//create the query itself 
			String query = ""; 
			String ticketA = ""; 
			//round trip flight
			if(flightType.equals("r")){
				//flexible round trip 
				if(flexibility.equals("Flexible")){
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
					Calendar c = Calendar.getInstance(); 
					c.setTime(sdf.parse(dptDate));
					//depart date - 3 days 
					c.add(c.DAY_OF_MONTH, -3); 
					//save lower bound 
					String dptDateLowerBound = sdf.format(c.getTime());
					//depart date + 3 
					c.add(c.DAY_OF_MONTH, 6);
					//save upper bound 
					String dptDateUpperBound = sdf.format(c.getTime());
					c.setTime(sdf.parse(rtnDate));
					//return date -3 days 
					c.add(c.DAY_OF_MONTH, -3);
					String rtnDateLowerBound = sdf.format(c.getTime());
					//return date +3 days 
					c.add(c.DAY_OF_MONTH, 6);
					String rtnDateUpperBound = sdf.format(c.getTime());
					//build query		
					query = "select distinct fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo join Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_type = '"+flightType+"' and t.seat_class = '"+seatClass+"' and fo.departure_airport = '"+dptAirport+"' and fo.destination_airport = '"+dstAirport+"' and fo.depart_date between '"+dptDateLowerBound+"' and '"+dptDateUpperBound+"' and fo.return_date between '"+rtnDateLowerBound+"' and '"+rtnDateUpperBound+"'";
					ticketA = "select distinct fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price', t.ticket_number from Flight_Operates fo join Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_type = '"+flightType+"' and t.seat_class = '"+seatClass+"' and fo.departure_airport = '"+dptAirport+"' and fo.destination_airport = '"+dstAirport+"' and fo.depart_date between '"+dptDateLowerBound+"' and '"+dptDateUpperBound+"' and fo.return_date between '"+rtnDateLowerBound+"' and '"+rtnDateUpperBound+"'";
				}
				else{
					//not-flexible round trip
					query = "select distinct fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo join Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_type = '"+flightType+"' and t.seat_class = '"+seatClass+"' and fo.departure_airport = '"+dptAirport+"' and fo.destination_airport = '"+dstAirport+"' and fo.depart_date = '"+dptDate+"' and fo.return_date = '"+rtnDate+"'";
					ticketA = "select distinct fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price', t.ticket_number from Flight_Operates fo join Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_type = '"+flightType+"' and t.seat_class = '"+seatClass+"' and fo.departure_airport = '"+dptAirport+"' and fo.destination_airport = '"+dstAirport+"' and fo.depart_date = '"+dptDate+"' and fo.return_date = '"+rtnDate+"'";
				}
			}
			//one way
			else{
				//one way flexible
				if(flexibility.equals("Flexible")){
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
					Calendar c = Calendar.getInstance(); 
					c.setTime(sdf.parse(dptDate));
					//dpt date -3 
					c.add(c.DAY_OF_MONTH, -3); 
					String dptDateLowerBound = sdf.format(c.getTime());
					//dpt date + 3 
					c.add(c.DAY_OF_MONTH, 6); 
					String dptDateUpperBound = sdf.format(c.getTime()); 
					query = "select distinct fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo join Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_type = '"+flightType+"' and t.seat_class = '"+seatClass+"' and fo.departure_airport = '"+dptAirport+"' and fo.destination_airport = '"+dstAirport+"' and fo.depart_date between '"+dptDateLowerBound+"' and '"+dptDateUpperBound+"'";
					ticketA = "select distinct fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price', t.ticket_number from Flight_Operates fo join Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_type = '"+flightType+"' and t.seat_class = '"+seatClass+"' and fo.departure_airport = '"+dptAirport+"' and fo.destination_airport = '"+dstAirport+"' and fo.depart_date between '"+dptDateLowerBound+"' and '"+dptDateUpperBound+"'";
				}
				//one way not flexible
				else{
					query = "select distinct fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo join Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_type = '"+flightType+"' and t.seat_class = '"+seatClass+"' and fo.departure_airport = '"+dptAirport+"' and fo.destination_airport = '"+dstAirport+"' and fo.depart_date = '"+dptDate+"'";
					ticketA = "select distinct fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price', t.ticket_number from Flight_Operates fo join Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_type = '"+flightType+"' and t.seat_class = '"+seatClass+"' and fo.departure_airport = '"+dptAirport+"' and fo.destination_airport = '"+dstAirport+"' and fo.depart_date = '"+dptDate+"'";
				}
			}
			// **** OTHER attribute needed for reserve, the ticketAvailible query ****
			session.setAttribute("ticketavailible", ticketA);
			
			//set query as session attribute
			session.setAttribute("query", query);
			//execute the query
			searchFlights.execute(query);
			//get the results of the query
			ResultSet rs = searchFlights.getResultSet();
			//print the table again
			out.print("<table name='flightresults' border=2 align='center'><tr><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
			//loop through the results and print them out
			//out.print("<table name='flightresults' border=2 align='center'><tr><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>"); 
			while(rs.next()){
				out.print("<tr><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
			}
			
			ArrayList<String> q = (ArrayList<String>) session.getAttribute("queries"); 
			q.add(query);
			session.setAttribute("queries", q);
			//close the DB connection
			ApplicationDB.closeConnection(connection);
			// this allows them to reserve a flight 
			out.print("<div id='manage_customerrep_add_container' style='text-align: center; margin-top: 20px;'><form id='manage_customerrep_add_form'><input type='text' name='accountnum' placeholder='Account Number'><input type='text' name='flightnumber' placeholder='Flight Number'><input type='text' name='airlineid' placeholder='Airline ID'><br><input type='submit' name='reserve' value='Reserve' formaction='customer_rep.jsp'><input type='submit' name='waitlist' value='Waitlist' formaction='customer_rep.jsp'></form></div>"); 
	
		// gets user's 'My Account Tab' 
		} else if (request.getParameter("getmyreservations") != null) {
			// get 'my account' 
			String accountNum = (String) request.getParameter("accountnum");
			//create connection 
			Connection connection = ApplicationDB.getConnection();
			//create query to fetch reservations 
			Statement fetchReservations = connection.createStatement(); 
			//build the query
			String fetchReservationsQuery = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where t.ticket_number in (select r.ticket_number from Reserves r where r.account_num = "+accountNum+")"; 
			//execute the query 
			fetchReservations.execute(fetchReservationsQuery); 
			//get the results 
			ResultSet rs = fetchReservations.getResultSet(); 
			//print the results and print the table again
			out.print("<table name='flightresults' border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
			while(rs.next()){
				out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
			}
			//set as session variable 
			session.setAttribute("reservationQuery", fetchReservationsQuery); 
			
			ArrayList<String> q = (ArrayList<String>) session.getAttribute("reservationQueries");
			q.add(fetchReservationsQuery); 
			session.setAttribute("reservationQueries", q);
			
			//close the connection 
			ApplicationDB.closeConnection(connection);
			
			// this allows them to then go and cancel a flight
			out.print("<div id='manage_customerrep_edit_container' style='text-align: center; margin-top: 20px;'><form id='manage_customerrep_edit_form'><input type='text' name='ticketnumber' placeholder='Ticket Number'><input type='text' name='accountnum' placeholder='Account Number'><br><input type='submit' name='edit' value='Edit (Cancel)' formaction='customer_rep.jsp'></form></div>");  

		
		} else if (request.getParameter("reserve") != null) {
			// assign the inputs to the reserve 
			String flightNumber = request.getParameter("flightnumber"); 
			String airlineId = request.getParameter("airlineid");
			String accountNum = (String) request.getParameter("accountnum");
			//grab the query was used to originally search for flights 
			String originalQuery = (String) session.getAttribute("query"); 
			
			// build query for checking if the ticket they want is availible 
			String beforeTicketAvailible = originalQuery + " and t.account_num = -1 and t.flight_number = " + flightNumber + " and fo.airline_id = '" + airlineId + "'"; 
			//create query statement 
			Connection connection = ApplicationDB.getConnection(); 
			Statement tAvailibleQuery = connection.createStatement(); 
			//execute the query 
			tAvailibleQuery.execute(beforeTicketAvailible);
			//get the results of the query 
			ResultSet rs = tAvailibleQuery.getResultSet(); 
			// if the result set is null, there are no tickets availible 
			if (!rs.next()) {
				//get arraylist of queries
				ArrayList<String> q = (ArrayList<String>) session.getAttribute("queries"); 
				//execute latest query and reprint the results 
				if(q.size() > 0){
					Statement lastQuery = connection.createStatement(); 
					lastQuery.execute(q.get(q.size()-1)); 
					ResultSet rs2 = lastQuery.getResultSet();
					//print the table again
					out.print("<table name='flightresults' border=2 align='center'><tr><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
					while(rs2.next()){
						out.print("<tr><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("seat_class")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("num_stops")+"</td><td>"+rs2.getString("Price")+"</td></tr>");
					}
				}
				// this allows them to reserve a flight 
				out.print("<div id='manage_customerrep_add_container' style='text-align: center; margin-top: 20px;'><form id='manage_customerrep_add_form'><input type='text' name='accountnum' placeholder='Account Number'><input type='text' name='flightnumber' placeholder='Flight Number'><input type='text' name='airlineid' placeholder='Airline ID'><br><input type='submit' name='reserve' value='Reserve' formaction='customer_rep.jsp'><input type='submit' name='waitlist' value='Waitlist' formaction='customer_rep.jsp'></form></div>"); 
				// ask user to be added to the waitlist
				out.print("<h3 style='text-align: center;'>Flight Number "+flightNumber+" is full, if you would like to be added to the waitlist, please insert the information for the flight and select 'Waitlist' </h3>");
			} else { // if it is not null, do the reserving  
				// get ticket number first
				String ticketAvailible = (String) session.getAttribute("ticketavailible"); 
				String getTicketNum = "select MIN(ticket_number) as 'ticket_num' from ( " + ticketAvailible + " and t.account_num = -1 and t.flight_number = " + flightNumber + " and fo.airline_id = '" + airlineId + "')" + " as temp3"; 
				// create connection, statement, execute and we don't need the result set 
				Statement getTQuery = connection.createStatement(); 
				getTQuery.execute(getTicketNum); 
				ResultSet rgetT = getTQuery.getResultSet(); 
				int ticketNumber = -1; 
				if (rgetT.next()) {
					ticketNumber = rgetT.getInt("ticket_num"); 
				}
				
				//get the current date 
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
				Calendar cal = Calendar.getInstance(); 
				String todaysDate = sdf.format(cal.getTime());
				
				// update the ticket account number column 
				String updateTickets = "UPDATE Tickets set account_num = " + accountNum + ", issue_date = '" + todaysDate + "' where flight_number = " + flightNumber + " and airline_id = '" + airlineId + "' and ticket_number = " + ticketNumber; 
				// create connection, statement, execute and we don't need the result set
				Statement updateTQuery = connection.createStatement(); 
				updateTQuery.execute(updateTickets);  
				
				// insert into the Reserve 
				String insertReserve = "INSERT INTO Reserves(ticket_number, account_num) VALUES (" + ticketNumber  + ", " + accountNum + ")" ; 
				// create connection, statement, execute and we don't need the result set
				Statement reserveQuery = connection.createStatement(); 
				reserveQuery.execute(insertReserve); 
				
				//get arraylist of queries
				ArrayList<String> q = (ArrayList<String>) session.getAttribute("queries"); 
				//execute latest query and reprint the results 
				if(q.size() > 0){
					Statement lastQuery = connection.createStatement(); 
					lastQuery.execute(q.get(q.size()-1)); 
					ResultSet rs2 = lastQuery.getResultSet();
					//print the table again
					out.print("<table name='flightresults' border=2 align='center'><tr><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
					while(rs2.next()){
						out.print("<tr><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("seat_class")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("num_stops")+"</td><td>"+rs2.getString("Price")+"</td></tr>");
					}
				}
				// this allows them to reserve a flight 
				out.print("<div id='manage_customerrep_add_container' style='text-align: center; margin-top: 20px;'><form id='manage_customerrep_add_form'><input type='text' name='accountnum' placeholder='Account Number'><input type='text' name='flightnumber' placeholder='Flight Number'><input type='text' name='airlineid' placeholder='Airline ID'><br><input type='submit' name='reserve' value='Reserve' formaction='customer_rep.jsp'><input type='submit' name='waitlist' value='Waitlist' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>Ticket number "+ticketNumber+" has been successfully reserved!</h3>");
			}
			ApplicationDB.closeConnection(connection);
				
		} else if (request.getParameter("waitlist") != null) {
			// assign the inputs to the reserve (flight num, airline id and account num)
			String flightNumber = request.getParameter("flightnumber"); 
			String airlineId = request.getParameter("airlineid");
			String accountNum = request.getParameter("accountnum"); 

			// create the insert query for the waitlist
			String waitlist = "INSERT INTO Waitlist(flight_number, airline_id, account_num) VALUES (" + flightNumber + ", '" + airlineId + "', " + Integer.parseInt(accountNum) + ")"; 
			System.out.println(waitlist); 
			Connection connection = ApplicationDB.getConnection(); 
			Statement waitQuery = connection.createStatement(); 
			waitQuery.execute(waitlist); 
			//get arraylist of queries
			ArrayList<String> q = (ArrayList<String>) session.getAttribute("queries"); 
			//execute latest query and reprint the results 
			if(q.size() > 0){
				Statement lastQuery = connection.createStatement(); 
				lastQuery.execute(q.get(q.size()-1)); 
				ResultSet rs2 = lastQuery.getResultSet();
				//print the table again
				out.print("<table name='flightresults' border=2 align='center'><tr><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
				while(rs2.next()){
					out.print("<tr><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("seat_class")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("num_stops")+"</td><td>"+rs2.getString("Price")+"</td></tr>");
				}
			}
			// print out result 
			// this allows them to reserve a flight 
			out.print("<div id='manage_customerrep_add_container' style='text-align: center; margin-top: 20px;'><form id='manage_customerrep_add_form'><input type='text' name='accountnum' placeholder='Account Number'><input type='text' name='flightnumber' placeholder='Flight Number'><input type='text' name='airlineid' placeholder='Airline ID'><br><input type='submit' name='reserve' value='Reserve' formaction='customer_rep.jsp'><input type='submit' name='waitlist' value='Waitlist' formaction='customer_rep.jsp'></form></div>"); 
			out.print("<h3 style='text-align: center;'>You have successfully been added to the waitlist for flight number " + flightNumber+"</h3>"); 
			//close the DB connection
			ApplicationDB.closeConnection(connection);
			
			
		} else if (request.getParameter("edit") != null) { 
			String accountNum = (String) request.getParameter("accountnum");
			String ticketNumber = (String) request.getParameter("ticketnumber");
			
			//get the seat class
			Connection connection = ApplicationDB.getConnection(); 
			Statement getSeatClass = connection.createStatement(); 
			getSeatClass.execute("select seat_class from Tickets where ticket_number="+ticketNumber+" and account_num="+accountNum);
			String seatClass = ""; 
			if(getSeatClass.getResultSet().next()){
				seatClass = getSeatClass.getResultSet().getString("seat_class");
			}
			if(seatClass.equals("e")){
				out.print("<h3 style='text-align: center;'>You cannot cancel an economy reservation!</h3>");	
				ArrayList<String> q = (ArrayList<String>) session.getAttribute("reservationQueries");
				if(q.size() > 0){
					Statement lastQuery = connection.createStatement(); 
					lastQuery.execute(q.get(q.size()-1)); 
					ResultSet rs = lastQuery.getResultSet();
					//print the results and print the table again
					out.print("<table name='flightresults' border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
					while(rs.next()){
						out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
					}
				}
				// this allows them to then go and cancel a flight
				out.print("<div id='manage_customerrep_edit_container' style='text-align: center; margin-top: 20px;'><form id='manage_customerrep_edit_form'><input type='text' name='ticketnumber' placeholder='Ticket Number'><input type='text' name='accountnum' placeholder='Account Number'><br><input type='submit' name='edit' value='Edit (Cancel)' formaction='customer_rep.jsp'></form></div>");  
			}
			else{
				//create query statement 
				Statement cancelReservation = connection.createStatement(); 
				//execute the query 
				cancelReservation.execute("delete from Reserves where account_num="+accountNum+" and ticket_number="+ticketNumber);
				//create query statement 
				Statement cancelReservation2 = connection.createStatement(); 
				cancelReservation2.execute("update Tickets set account_num = -1, issue_date='9999-12-31' where ticket_number ="+ticketNumber+" and account_num ="+accountNum);
				out.print("<h3 style='text-align: center;'>You have successfully canceled your reservation!</h3>");
				
				Statement getRemainingReservations = connection.createStatement(); 
				String remaining = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where t.ticket_number in (select r.ticket_number from Reserves r where r.account_num = "+accountNum+") and t.ticket_number != "+ticketNumber; 
				getRemainingReservations.execute(remaining); 
				ResultSet rs = getRemainingReservations.getResultSet(); 
				//print the results and print the table again
				out.print("<table name='flightresults' border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
				}
				session.setAttribute("reservationQuery", remaining);
				// this allows them to then go and cancel a flight
				out.print("<div id='manage_customerrep_edit_container' style='text-align: center; margin-top: 20px;'><form id='manage_customerrep_edit_form'><input type='text' name='ticketnumber' placeholder='Ticket Number'><input type='text' name='accountnum' placeholder='Account Number'><br><input type='submit' name='edit' value='Edit (Cancel)' formaction='customer_rep.jsp'></form></div>");  
			}
			//close the DB connection
			ApplicationDB.closeConnection(connection);
				
		} else if (request.getParameter("searchwaitlist") != null) {
			// get the flight number
			String flightNumber = (String) request.getParameter("flightnumber"); 
			//create query statement 
			Connection connection = ApplicationDB.getConnection(); 
			Statement searchwaitlist = connection.createStatement(); 
			searchwaitlist.execute("select name, username from Person where account_num in (select account_num from Waitlist where flight_number = " + flightNumber + ")"); 
			ResultSet rs = searchwaitlist.getResultSet();
			//print the results and print the table again
			out.print("<table name='waitlistsearchresults' border=2 align='center'><tr><td>Name</td><td>Username</td></tr>");
			while(rs.next()){
				out.print("<tr><td>"+rs.getString("name")+"</td><td>"+rs.getString("username")+"</td></tr>");
			}
			session.setAttribute("reservationQuery", searchwaitlist);
			// gives inputs for user to enter
			out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Waitlist</h1></div><div id='my_waitlist_form_container' style='text-align: center;'><form id='my_waitlist_form'><input type='text' name='flightnumber' placeholder='Flight Number'><br><input type='submit' name='searchwaitlist' value='Search Waitlist' formaction='customer_rep.jsp'></form></div>"); 
			//close the DB connection
			ApplicationDB.closeConnection(connection);
					
		} else if ((request.getParameter("addaircraft") != null) || (request.getParameter("editaircraft") != null) || (request.getParameter("deleteaircraft") != null)){
			// get the aircraft id
			String aircraftId = (String) request.getParameter("aircraftid");
			//create query statement 
			Connection connection = ApplicationDB.getConnection(); 
			if (aircraftId.equals("")) {
				//print the results and print the table again and gives inputs for user to enter (if they choose, again)
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Add, Edit, Delete - Aircraft</h1></div><div id='my_waitlist_form_container'><form id='my_waitlist_form'><input type='text' name='aircraftid' placeholder='Aircraft ID'><br><input type='submit' name='addaircraft' value='Add Aircraft' formaction='customer_rep.jsp'><input type='submit' name='editaircraft' value='Edit Aircraft' formaction='customer_rep.jsp'><input type='submit' name='deleteaircraft' value='Delete Aircraft' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>Please enter a valid Aircraft ID</h3>"); 
			
				// now check parameters
		 	} else if (request.getParameter("addaircraft") != null) { 
				//create query statement 
				Statement addToAircraft = connection.createStatement();
				addToAircraft.execute("INSERT into Aircraft (aircraft_id) values( "+ aircraftId + ")"); 
				//print the results and print the table again and gives inputs for user to enter (if they choose, again)
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Add, Edit, Delete - Aircraft</h1></div><div id='my_waitlist_form_container' style='text-align: center;'><form id='my_waitlist_form'><input type='text' name='aircraftid' placeholder='Aircraft ID'><br><input type='submit' name='addaircraft' value='Add Aircraft' formaction='customer_rep.jsp'><input type='submit' name='editaircraft' value='Edit Aircraft' formaction='customer_rep.jsp'><input type='submit' name='deleteaircraft' value='Delete Aircraft' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>You have successfully added Aircraft ID " + aircraftId+"</h3>"); 
			
			} else if (request.getParameter("editaircraft") != null){
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Add, Edit, Delete - Aircraft</h1></div><div id='my_waitlist_form_container'><form id='my_waitlist_form'><input type='text' name='aircraftid' placeholder='Aircraft ID'><br><input type='submit' name='addaircraft' value='Add Aircraft' formaction='customer_rep.jsp'><input type='submit' name='editaircraft' value='Edit Aircraft' formaction='customer_rep.jsp'><input type='submit' name='deleteaircraft' value='Delete Aircraft' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>In order to edit, please delete aircraft " + aircraftId+" and add a new aircraft with the Aircraft ID of your choice</h3>"); 
				
				
			} else if (request.getParameter("deleteaircraft") != null){
				//create query statement 
				Statement deleteAircraft = connection.createStatement();
				deleteAircraft.execute("DELETE from Aircraft where aircraft_id = " + aircraftId); 
				//print the results and print the table again and gives inputs for user to enter (if they choose, again)
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Add, Edit, Delete - Aircraft</h1></div><div id='my_waitlist_form_container'><form id='my_waitlist_form'><input type='text' name='aircraftid' placeholder='Aircraft ID'><br><input type='submit' name='addaircraft' value='Add Aircraft' formaction='customer_rep.jsp'><input type='submit' name='editaircraft' value='Edit Aircraft' formaction='customer_rep.jsp'><input type='submit' name='deleteaircraft' value='Delete Aircraft' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>You have successfully deleted Aircraft ID " + aircraftId+"</h3>"); 
			
			}
			// display the new table
			Statement searchAircrafts = connection.createStatement();
			searchAircrafts.execute("SELECT * from Aircraft"); 
			ResultSet rs = searchAircrafts.getResultSet();
			//print the results and print the table again
			out.print("<table name='insertAircraftresults' border=2 align='center'><tr><td>Aircraft ID</td></tr>");
			while(rs.next()){
				out.print("<tr><td>"+rs.getString("aircraft_id")+"</td></tr>");
			}
			//close the DB connection
			ApplicationDB.closeConnection(connection);
				
		} else if ((request.getParameter("addairport") != null) || (request.getParameter("editairport") != null) || (request.getParameter("deleteairport") != null)) {
			// get the aircraft id
			String airportId = (String) request.getParameter("airportid");
			//create query statement 
			Connection connection = ApplicationDB.getConnection(); 
			if (airportId.equals("")){
				//print the results and print the table again and gives inputs for user to enter (if they choose, again)
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header' style='text-align: center;'>Add, Edit, Delete - Airport</h1></div><div id='my_waitlist_form_container' style='text-align: center;'><form id='my_waitlist_form'><input type='text' name='airportid' placeholder='Airport ID'><br><input type='submit' name='addairport' value='Add Airport' formaction='customer_rep.jsp'><input type='submit' name='editairport' value='Edit Airport' formaction='customer_rep.jsp'><input type='submit' name='deleteairport' value='Delete Airport' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>Please enter a valid Airport ID</h3>"); 
			
			// now check parameters
			} else if (request.getParameter("addairport") != null) { 
				//create query statement 
				Statement addToAirport = connection.createStatement();
				addToAirport.execute("INSERT into Airport (airport_id) values( '"+ airportId + "')"); 
				//print the results and print the table again and gives inputs for user to enter (if they choose, again)
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header'>Add, Edit, Delete - Airport</h1></div><div id='my_waitlist_form_container'><form id='my_waitlist_form'><input type='text' name='airportid' placeholder='Airport ID'><br><input type='submit' name='addairport' value='Add Airport' formaction='customer_rep.jsp'><input type='submit' name='editairport' value='Edit Airport' formaction='customer_rep.jsp'><input type='submit' name='deleteairport' value='Delete Airport' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>You have successfully added Airport ID " + airportId+"</h3>"); 
			
			} else if (request.getParameter("editairport") != null){
				//print the results and print the table again and gives inputs for user to enter (if they choose, again)
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header'>Add, Edit, Delete - Airport</h1></div><div id='my_waitlist_form_container'><form id='my_waitlist_form'><input type='text' name='airportid' placeholder='Airport ID'><br><input type='submit' name='addairport' value='Add Airport' formaction='customer_rep.jsp'><input type='submit' name='editairport' value='Edit Airport' formaction='customer_rep.jsp'><input type='submit' name='deleteairport' value='Delete Airport' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>In order to edit, please delete airport " + airportId+" and add a new airport with the Airport ID of your choice</h3>"); 
				
				
			} else if (request.getParameter("deleteairport") != null){
				//create query statement 
				Statement deleteAirport = connection.createStatement();
				deleteAirport.execute("DELETE from Airport where airport_id = '" + airportId + "'"); 
				//print the results and print the table again and gives inputs for user to enter (if they choose, again)
				out.print("<div id='my_waitlist_header_container'><h1 id='my_waitlist_header'>Add, Edit, Delete - Airport</h1></div><div id='my_waitlist_form_container'><form id='my_waitlist_form'><input type='text' name='airportid' placeholder='Airport ID'><br><input type='submit' name='addairport' value='Add Airport' formaction='customer_rep.jsp'><input type='submit' name='editairport' value='Edit Airport' formaction='customer_rep.jsp'><input type='submit' name='deleteairport' value='Delete Airport' formaction='customer_rep.jsp'></form></div>"); 
				out.print("<h3 style='text-align: center;'>You have successfully deleted Airport ID " + airportId+"</h3>"); 
			
			}
			// display the new table
			Statement searchAirports = connection.createStatement();
			searchAirports.execute("SELECT * from Airport"); 
			ResultSet rs = searchAirports.getResultSet();
			//print the results and print the table again
			out.print("<table name='insertAircraftresults' border=2 align='center'><tr><td>Airport ID</td></tr>");
			while(rs.next()){
				out.print("<tr><td>"+rs.getString("airport_id")+"</td></tr>");
			}
			//close the DB connection
			ApplicationDB.closeConnection(connection);
			
		} else if (request.getParameter("addflight") != null){
			String aircraft_id = request.getParameter("aircraftid");  
			String airline_id = request.getParameter("airlineid"); 
			String airport_id = request.getParameter("airportid"); 
			String flight_number = request.getParameter("flightnumber"); 
			String flight_type = request.getParameter("flighttype");
			String depart_time = request.getParameter("departtime"); 
			String arrival_time = request.getParameter("arrivaltime");
			String fare_first = request.getParameter("farefirst");
			String fare_economy = request.getParameter("fareeconomy");
			String departure_airport = request.getParameter("departureairport");
			String destination_airport = request.getParameter("destinationairport"); 
			String fare_business = request.getParameter("farebusiness"); 
			String num_stops = request.getParameter("numstops");
			String depart_date = request.getParameter("departuredate"); 
			String return_date = request.getParameter("returndate");
			
			// create a connection
			Connection connection = ApplicationDB.getConnection();
			Statement addflight = connection.createStatement();
			if (flight_type.equals("One-Way")) {
				flight_type = "o"; 
				String addf = "insert into Flight_Operates(aircraft_id, airline_id, airport_id, flight_number, flight_type, depart_time, arrival_time, fare_first, fare_economy, departure_airport, destination_airport, fare_business, num_stops, depart_date, return_date) Values (" + aircraft_id + ",'"+ airline_id + "','" + airport_id + "'," + flight_number + ",'" + flight_type + "','" + depart_time + "','" + arrival_time + "'," + fare_first + "," + fare_economy + ",'" + departure_airport + "','" + destination_airport + "'," + fare_business + "," + num_stops + ",'" + depart_date + "','9999-12-31')";  
				addflight.execute(addf);
				
			} else if (flight_type.equals("Round-Trip")) {
				flight_type = "r";
				String addf = "insert into Flight_Operates(aircraft_id, airline_id, airport_id, flight_number, flight_type, depart_time, arrival_time, fare_first, fare_economy, departure_airport, destination_airport, fare_business, num_stops, depart_date, return_date) Values (" + aircraft_id + ",'"+ airline_id + "','" + airport_id + "'," + flight_number + ",'" + flight_type + "','" + depart_time + "','" + arrival_time + "'," + fare_first + "," + fare_economy + ",'" + departure_airport + "','" + destination_airport + "'," + fare_business + "," + num_stops + ",'" + depart_date + "','" + return_date  +"')";  
				addflight.execute(addf);
				
			} 
			//close the DB connection
			ApplicationDB.closeConnection(connection);
			out.print("<h3 style='text-align: center;'>You have successfully added a flight</h3>"); 

		} else if (request.getParameter("editflight") != null){
			// create connection
			Connection connection = ApplicationDB.getConnection();
			// get the specific flight vars
			String flight_number = request.getParameter("flightnumber"); 
			String airline_id = request.getParameter("airlineid"); 
			// get edit variables 
			String depart_time = request.getParameter("departtime"); 
			String arrival_time = request.getParameter("arrivaltime");
			String fare_first = request.getParameter("farefirst");
			String fare_economy = request.getParameter("fareeconomy");
			String departure_airport = request.getParameter("departureairport");
			String destination_airport = request.getParameter("destinationairport"); 
			String fare_business = request.getParameter("farebusiness"); 
			String num_stops = request.getParameter("numstops");
			String depart_date = request.getParameter("departuredate"); 
			String return_date = request.getParameter("returndate");
			String flight_type = request.getParameter("flighttype");
			
			ArrayList<String> inputlist = new ArrayList<String>(); 
			inputlist.add(return_date); //0
			inputlist.add(depart_time);  //1
			inputlist.add(arrival_time); //2
			inputlist.add(fare_first); //3
			inputlist.add(fare_economy); //4
			inputlist.add(departure_airport); //5
			inputlist.add(destination_airport); //6
			inputlist.add(num_stops); //7
			inputlist.add(depart_date); //8
			inputlist.add(flight_type); // 9
			 
			int count = 0; 
			for (int i = 0; i < inputlist.size(); i++) {
				if (inputlist.get(i) == null){ 
					continue; 					
				// if there is an inputted value, update based on that value  
				} else if (inputlist.get(i).equals("")){
					continue; 
				} else {
					if (i == 0) { // return date
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set return_date = '" + return_date + "' where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 1) { // depart time
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set depart_time = '" + depart_time + "' where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 2) { // arrival_time
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set arrival_time = '" + arrival_time + "' where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 3) { // fare_first
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set fare_first = " + fare_first + " where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 4) { // fare_economy
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set fare_economy = " + fare_economy + " where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 5) { // departure_airport
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set departure_airport = '" + departure_airport + "' where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 6) { // destination_airport
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set destination_airport = '" + destination_airport + "' where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 7) { // num_stops
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set num_stops = " + num_stops + " where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 8) { // depart_date
						// create statement, execute query 
						Statement updateReturnDate = connection.createStatement();
						updateReturnDate.execute("UPDATE Flight_Operates set depart_date = '" + depart_date + "' where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 
						count++; 
						
					} else if (i == 9) { // One-Way or Round-Trip, flight_type 
						if (flight_type.equals("One-Way")) {
							// create statement, execute query 
							Statement updateFlightType = connection.createStatement();
							updateFlightType.execute("UPDATE Flight_Operates set flight_type = 'o', return_date = '9999-12-31' where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 

						} else if (flight_type.equals("Round-Trip")) {
							// create statement, execute query 
							Statement updateFlightType = connection.createStatement();
							updateFlightType.execute("UPDATE Flight_Operates set flight_type = 'r', return_date = '" + return_date + "' where airline_id = '" + airline_id + "' and flight_number = " + flight_number); 

						}
						count++;
					}
				} 
			} 
			
			//close the DB connection
			ApplicationDB.closeConnection(connection);
			out.print("<h3 style='text-align: center;'>You have successfully edited " + count + " elements from flight number " + flight_number + "</h3>"); 
		
		} else if (request.getParameter("deleteflight") != null){
			String flightnumber = request.getParameter("flightnumber"); 
			String airlineid = request.getParameter("airlineid"); 
			
			// create a connection
			Connection connection = ApplicationDB.getConnection();
			Statement deleteFlight = connection.createStatement();
			String deletef = "Delete from Flight_Operates where flight_number = " + flightnumber + " and airline_id = '" + airlineid + "'"; 
			deleteFlight.execute(deletef); 
			
			out.print("<h3 style='text-align: center;'>You have successfully deleted a flight</h3>"); 
		}

	
	
	
	
	%>
	</table>
</body>
</html>