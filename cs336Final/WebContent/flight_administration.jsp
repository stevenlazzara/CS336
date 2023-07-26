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
		  			<title>CS336 TMS - Flight Search</title>
		  			<meta name="description" content="Project for CS336">
		  			<link rel="stylesheet" href="styles.css">
				</head>
				<body>
					<h1 id="flights_header">Flights</h1>
					<div id="back_to_flight_search_container">
						<form id="back_to_flight_search_form">
							<input type="submit" value="Back To Flight Search" formaction="customer.jsp">
							<input type="submit" name="logout" value="Logout" formaction="site_access.jsp">
						</form>
					</div>
					<div id="flight_sort_container">
						<h5>Sort By:</h5>
						<select name="sortselect" form="flights_filter_form">
							<option>Price</option>
							<option>Departure-Time</option>
							<option>Arrival-Time</option>
						</select>
					</div>
					<div id="flights_filter_container">
						<h5>Filter By:</h5>
						<form id="flights_filter_form">
							<input type="text" name="price" placeholder="Maximum Price"><br> 
							<input type="text" name="numberofstops" placeholder="Number of Stops"><br>
							<input type="text" name="airline" placeholder="Airline"><br>
							<input type="submit" name="sortflights" value="SORT" formaction="flight_administration.jsp">
							<input type="submit" name="filterflights" value="FILTER" formaction="flight_administration.jsp">
						</form>
					</div>
					<table name="flightresults" border=2 align="center">
						<tr>
							<td>Airline ID</td>
							<td>Flight Number</td>
							<td>Seat Class</td>
							<td>Departure Time</td>
							<td>Arrival Time</td>
							<td>Departure Airport</td>
							<td>Destination Airport</td>
							<td>Number of Stops</td>
							<td>Price</td>
						</tr>
<%
	//search flights button was clicked 
	if(request.getParameter("searchflights") != null){
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
		//loop through the results and print them out
		while(rs.next()){
			out.print("<tr><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
		}
		
		ArrayList<String> q = (ArrayList<String>) session.getAttribute("queries"); 
		q.add(query);
		session.setAttribute("queries", q);
		
		//close the DB connection
		ApplicationDB.closeConnection(connection);
	}

	//sorting flights 
	else if(request.getParameter("sortflights") != null){
		//grab the query was used to originally search for flights 
		String originalQuery = (String) session.getAttribute("query"); 
		//grab the value to sort by 
		String sortBy = request.getParameter("sortselect"); 
		//adjust the query to include sort by criteria 
		//SORT BY PRICE
		if(sortBy.equals("Price")){
			originalQuery += " order by t.ticket_price asc";
		}
		//SORT BY DEPARTURE TIME
		else if(sortBy.equals("Departure-Time")){
			originalQuery += " order by fo.depart_time asc"; 
		}
		//SORT BY ARRIVAL TIME
		else{
			originalQuery += " order by fo.arrival_time asc";
		}
		//create connection
		Connection connection = ApplicationDB.getConnection(); 
		//create query statement 
		Statement sortByPrice = connection.createStatement(); 
		//execute the query 
		sortByPrice.execute(originalQuery);
		//get the results of the query 
		ResultSet rs = sortByPrice.getResultSet(); 
		//print the results 
		while(rs.next()){
			out.print("<tr><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
		}
		
		//add latest query to arraylist 
		ArrayList<String> q = (ArrayList<String>) session.getAttribute("queries"); 
		q.add(originalQuery);
		session.setAttribute("queries", q);
		
		ApplicationDB.closeConnection(connection);
		
	}

	//filtering flights 
	else if(request.getParameter("filterflights") != null){
		//grab the original query that was used to originally search for flights 
		String originalQuery = (String) session.getAttribute("query"); 
		//grab the values to filter by 
		String priceFilter = request.getParameter("price"); 
		String stopsFilter = request.getParameter("numberofstops"); 
		String airlineFilter = request.getParameter("airline"); 
		boolean filterByPrice = !priceFilter.equals("");
		boolean filterByStops = !stopsFilter.equals("");
		boolean filterByAirline = !airlineFilter.equals("");
		//filter by price 
		if(filterByPrice && !filterByStops && !filterByAirline){
			String filter = " and t.ticket_price <="+priceFilter; 
			originalQuery += filter;
		}
		//filter by stops 
		else if(!filterByPrice && filterByStops && !filterByAirline){
			String filter = " and fo.num_stops <="+stopsFilter; 
			originalQuery += filter;
		}
		//filter by airline 
		else if(!filterByPrice && !filterByStops && filterByAirline){
			String filter = " and fo.airline_id='"+airlineFilter+"'"; 
			originalQuery += filter;
		}
		//filter by price and stops 
		else if(filterByPrice && filterByStops && !filterByAirline){
			String filter = " and t.ticket_price <="+priceFilter+" and fo.num_stops <="+stopsFilter; 
			originalQuery += filter;
		}
		//filter by price and airline 
		else if(filterByPrice && !filterByStops && filterByAirline){
			String filter = " and t.ticket_price <="+priceFilter+" and fo.airline_id='"+airlineFilter+"'"; 
			originalQuery += filter;
		}
		//filter by stops and airline 
		else if(!filterByPrice && filterByStops && filterByAirline){
			String filter = " and fo.num_stops <="+stopsFilter+" and fo.airline_id='"+airlineFilter+"'"; 
			originalQuery += filter;
		}
		//filter by all three
		else if(filterByPrice && filterByStops && filterByAirline){
			String filter = " and t.ticket_price <="+priceFilter+" and fo.num_stops <= "+stopsFilter+" and fo.airline_id='"+airlineFilter+"'"; 
			originalQuery += filter;
		}
		//create database connection
		Connection connection = ApplicationDB.getConnection(); 
		//create statement 
		Statement filterFlights = connection.createStatement(); 
		//execute the query 
		filterFlights.execute(originalQuery); 
		//get results 
		ResultSet rs = filterFlights.getResultSet();
		//check if there are results 
		if(!rs.next()){
			out.print("</table><h3 style='text-align: center'>No results found</h3>");
		}
		//else print the results 
		else{
			rs.beforeFirst(); 
			while(rs.next()){
				out.print("<tr><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
			}
		} 
		
		//add latest query to arraylist 
		ArrayList<String> q = (ArrayList<String>) session.getAttribute("queries"); 
		q.add(originalQuery);
		session.setAttribute("queries", q);
		
		//close connection
		ApplicationDB.closeConnection(connection);
	}

	//***RESERVE STUFF GOES HERE***
	else if(request.getParameter("reserve") != null){
	
		// grab the account number to be used later on 
		String sessId = (String) session.getAttribute("sessionID");
		// create connection, statement and execute it 
		String getAccQuery = "select account_num from Person where logged_in = " + Integer.parseInt(sessId); 
		Connection connection = ApplicationDB.getConnection(); 
		Statement getAccountNum = connection.createStatement(); 
		getAccountNum.execute(getAccQuery); 
		ResultSet rAcc = getAccountNum.getResultSet(); 
		int accountNum = -1; 
		if (rAcc.next()) {
			// now get an int of the resulting id, it should NEVER be null
			accountNum = rAcc.getInt("account_num"); 
			session.setAttribute("accountnum", Integer.toString(accountNum));
		}
		
		/* 
		let customers make flight reservations
		let customer enter the waiting list if the flight is full
		*/
		//grab the query was used to originally search for flights 
		String originalQuery = (String) session.getAttribute("query"); 
		// assign the inputs to the reserve 
		String flightNumber = request.getParameter("flightnumber"); 
		String airlineId = request.getParameter("airlineid");
		// build query for checking if the ticket they want is availible 
		String beforeTicketAvailible = originalQuery + " and t.account_num = -1 and t.flight_number = " + flightNumber + " and fo.airline_id = '" + airlineId + "'"; 
		//create query statement 
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
				while(rs2.next()){
					out.print("<tr><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("seat_class")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("num_stops")+"</td><td>"+rs2.getString("Price")+"</td></tr>");
				}
			}
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
			String updateTickets = "UPDATE Tickets set account_num = " + accountNum+ ",issue_date='"+todaysDate+"' where flight_number = " + flightNumber + " and airline_id = '" + airlineId + "' and ticket_number = " + ticketNumber; 
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
				while(rs2.next()){
					out.print("<tr><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("seat_class")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("num_stops")+"</td><td>"+rs2.getString("Price")+"</td></tr>");
				}
			}
			out.print("<h3 style='text-align: center;'>Ticket number "+ticketNumber+" has been successfully reserved!</h3>");
		}
		ApplicationDB.closeConnection(connection);
	} 
	
	//get added to the waitlist
	else if (request.getParameter("waitlist") != null) {
		// assign the inputs to the reserve (flight num, airline id and account num)
		String flightNumber = request.getParameter("flightnumber"); 
		String airlineId = request.getParameter("airlineid");
		String accountNum = (String) session.getAttribute("accountnum"); 

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
			while(rs2.next()){
				out.print("<tr><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("seat_class")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("num_stops")+"</td><td>"+rs2.getString("Price")+"</td></tr>");
			}
		}
		// print out result 
		out.print("<h3 style='text-align: center;'>You have successfully been added to the waitlist for flight number " + flightNumber+"</h3>"); 
		//close the DB connection
		ApplicationDB.closeConnection(connection);
	}
		

%>
		</table>
		
		<div id="flight_reserve_container">
			<form name="flight_reserve_form">
				<input type="text" name="flightnumber" placeholder="Flight Number"><br>
				<input type="text" name="airlineid" placeholder="Airline ID"><br>
				<input type="submit" name="reserve" value="Reserve" formaction="flight_administration.jsp">
				<input type="submit" name="waitlist" value="Waitlist" formaction="flight_administration.jsp">	
			</form>
		</div>
		
		
	</body>
</html>

		
		






