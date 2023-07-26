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
					<h1 id="flights_header">Reservations</h1>
					<div id="back_to_flight_search_container">
						<form id="back_to_flight_search_form">
							<input type="submit" value="Back To Flight Search" formaction="customer.jsp">
							<input type="submit" name="logout" value="Logout" formaction="site_access.jsp">
						</form>
					</div>
					<div id="flight_sort_container">
						<h5>Filter By:</h5>
						<select name="filterselect" form="flights_filter_form">
							<option>Past-Reservations</option>
							<option>Future-Reservations</option>
						</select>
					</div>
					
					<div id="flights_filter_container">
						<form id="flights_filter_form">
							<input type="submit" name="filterreservations" value="FILTER" formaction="reservation_administration.jsp">
						</form>
					</div>
					
					<table name="flightresults" border=2 align="center">
						<tr>
							<td>Account Number</td>
							<td>Ticket Number</td>
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
	//get reservations whats clicked 
	if(request.getParameter("getmyreservations") != null){
		//create connection 
		Connection connection = ApplicationDB.getConnection(); 
		//create statement 
		Statement getAccountNum = connection.createStatement();
		// grab the account number to be used later on 
		String sessId = (String) session.getAttribute("sessionID");
		// create connection, statement and execute it 
		String getAccQuery = "select account_num from Person where logged_in = " + Integer.parseInt(sessId); 
		//execute the query 
		getAccountNum.execute(getAccQuery); 
		//get results of the query 
		ResultSet rs0 = getAccountNum.getResultSet(); 
		int accountNum = -1;
		if(rs0.next()){
			accountNum = rs0.getInt("account_num"); 
			session.setAttribute("accountnum", Integer.toString(accountNum));
		}
		//create query to fetch reservations 
		Statement fetchReservations = connection.createStatement(); 
		//build the query
		String fetchReservationsQuery = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where t.ticket_number in (select r.ticket_number from Reserves r where r.account_num = "+accountNum+")"; 
		//execute the query 
		fetchReservations.execute(fetchReservationsQuery); 
		//get the results 
		ResultSet rs = fetchReservations.getResultSet(); 
		//print the results 
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
	}

	//filtering reservations
	else if(request.getParameter("filterreservations")!=null){
		//fetch the original reservations query 
		String originalQuery = (String) session.getAttribute("reservationQuery"); 
		//get what to filter by 
		String filterParam = request.getParameter("filterselect");
		//get the current date 
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
		Calendar c = Calendar.getInstance(); 
		String currentDate = sdf.format(c.getTime());
		
		//get past reservations 
		if(filterParam.equals("Past-Reservations")){
			String filter = " and fo.depart_date <= '"+currentDate+"' and fo.return_date <= '"+currentDate+"'";
			originalQuery += filter;
		}
		//get future reservations
		else{
			String filter = " and fo.depart_date >= '"+currentDate+"' and fo.return_date >= '"+currentDate+"'";
			originalQuery += filter;
		}
		//create database connection 
		Connection connection = ApplicationDB.getConnection(); 
		//create statement 
		Statement filterReservations = connection.createStatement(); 
		filterReservations.execute(originalQuery); 
		//get the results 
		ResultSet rs = filterReservations.getResultSet(); 
		while(rs.next()){
			out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
		}
		
		ArrayList<String> q = (ArrayList<String>) session.getAttribute("reservationQueries");
		q.add(originalQuery); 
		session.setAttribute("reservationQueries", q);
		
		//close the connection 
		ApplicationDB.closeConnection(connection);
	}

	//canceling a reservation 
	else if(request.getParameter("cancelreservation")!=null){
		//create connection 
		Connection connection = ApplicationDB.getConnection(); 
		//create a statement 
		Statement getAccountNum = connection.createStatement();
		//get the ticket number 
		String ticketNumber = (String) request.getParameter("ticketnumber");
		// grab the account number to be used later on 
		String sessId = (String) session.getAttribute("sessionID");
		// create connection, statement and execute it 
		String getAccQuery = "select account_num from Person where logged_in = " + Integer.parseInt(sessId); 
		//execute the query 
		getAccountNum.execute(getAccQuery); 
		//get results of the query 
		ResultSet rs0 = getAccountNum.getResultSet(); 
		int accountNum = -1;
		if(rs0.next()){
			accountNum = rs0.getInt("account_num"); 
			session.setAttribute("accountnum", Integer.toString(accountNum));
		}
		//get the seat class
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
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
				}
			}
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
			while(rs.next()){
				out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
			}
			session.setAttribute("reservationQuery", remaining);
			
		}
		
		
	}




			
%>					
		</table>		
		
		<div id="cancel_reservation_container">
			<form id="cancel_reservation_form">
				<input type="text" name="ticketnumber" placeholder="Ticket Number"><br>
				<input type="submit" name="cancelreservation" value="Cancel Reservation" formaction="reservation_administration.jsp">
			</form>
		</div>
	</body>
</html>