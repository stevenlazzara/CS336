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
  <title>CS336 TMS - Summaries and Reports</title>
  <meta name="description" content="Project for CS336">
  <meta name="author" content="">
  <link rel="stylesheet" href="styles.css">
</head>
<body>

	<div id="back_to_flight_search_container" style="margin-top: 50px;">
		<form id="back_to_flight_search_form">
			<input type="submit" value="Back To Admin Homepage" formaction="admin.jsp">
			<input type="submit" name="logout" value="Logout" formaction="site_access.jsp">
		</form>
	</div>

<%

	//get the option that was inputted by the user
	String option = (String) session.getAttribute("summaryReportOption");
	//create connection to the database 
	Connection connection = ApplicationDB.getConnection();
	//fetch the various reports / summaries 
	//sales report 
	if(option.equals("Sales Report")){
		out.print("<h1 style='text-align: center;'>Sales Report</h1>");
		//fetch the month that was selected to get a sales report for 
		String monthSelected = (String) request.getParameter("reportmonth"); 
		//get the month as an integer 
		int monthAsInt = -1; 
		Date date = new SimpleDateFormat("MMM").parse(monthSelected);
		Calendar cal = Calendar.getInstance();
		cal.setTime(date); 
		monthAsInt = cal.get(Calendar.MONTH)+1;
		//create statement 
		Statement getSalesReport = connection.createStatement(); 
		//create the query 
		String query = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where MONTH(t.issue_date) = "+monthAsInt+" and YEAR(t.issue_date) = 2019 and t.account_num != -1"; 
		//execute the query 
		getSalesReport.execute(query);
		//get the results 
		ResultSet rs = getSalesReport.getResultSet(); 
		//check if there are results 
		if(!rs.next()){
			out.print("<h2 style='text-align: center;'>No sales report available for selected month!</h2>");
		}
		else{
			//print the table
			out.print("<table border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
			rs.beforeFirst(); 
			double totalSales = 0;
			while(rs.next()){
				out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
				totalSales += Double.parseDouble(rs.getString("Price"));
			}
			out.print("</table>"); 
			//get the total spent for the month 
			out.print("<h2 style='text-align: center;'>Total Sales: "+totalSales+"</h2>");
		}
	}
	//Flight Reservations List 
	else if(option.equals("Flight Reservations List")){
		out.print("<h1 style='text-align: center;'>Flight Reservations</h1>");
		//fetch data
		String flightNumber = (String) request.getParameter("flightreservationsflightnumber");
		String customerName = (String) request.getParameter("flightreservationscustomername"); 
		boolean useFlightNumber = !flightNumber.equals("");
		boolean useCustomerName = !customerName.equals("");
		int accountNumber = -1; 
		//create the statement 
		Statement getFlightReservations = connection.createStatement(); 
		//create the query 
		String query = "";
		if(useFlightNumber && useCustomerName){
			out.print("<h2 style='text-align: center;'>Cannot get flight reservations based on flight number and customer name. Please choose 1!</h2>");
		}
		else if(useFlightNumber){
			//create the query 
			 query = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_number = "+flightNumber+" and t.account_num != -1"; 
			//execute the query 
			getFlightReservations.execute(query); 
			//get the results 
			ResultSet rs = getFlightReservations.getResultSet(); 
			//check if there are results 
			if(!rs.next()){
				out.print("<h2 style='text-align: center;'>No flight reservations found!</h2>");
			}
			else{
				rs.beforeFirst();
				out.print("<table border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
				}
				out.print("</table>");
			}
		}
		else {
			//get the account number from the customer name 
			Statement getAcctNum = connection.createStatement(); 
			getAcctNum.execute("select account_num from Person where name='"+customerName+"'");
			ResultSet rs0 = getAcctNum.getResultSet(); 
			if(rs0.next()){
				accountNumber = rs0.getInt("account_num");
			}
			query = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where t.account_num = "+accountNumber;
			//execute the query 
			getFlightReservations.execute(query); 
			//get the results 
			ResultSet rs = getFlightReservations.getResultSet(); 
			//check if there are results 
			if(!rs.next()){
				out.print("<h2 style='text-align: center;'>No flight reservations found!</h2>");
			}
			else{
				rs.beforeFirst();
				out.print("<table border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
				}
				out.print("</table>");
			}
		}
		
	}
	//Revenue summary 
	else if(option.equals("Revenue Summary")){
		out.print("<h1 style='text-align: center;'>Revenue Summary</h1>");
		//grab the data from the user 
		String flightNumber = (String) request.getParameter("revenuesummaryflightnumber"); 
		String airline = (String) request.getParameter("revenuesummaryairline"); 
		String customerName = (String) request.getParameter("revenuesummarycustomer"); 
		boolean useFlightNumber = !flightNumber.equals(""); 
		boolean useAirline = !airline.equals(""); 
		boolean useCustomerName = !customerName.equals("");
		
		//making sure only one field is used 
		if(useFlightNumber && useAirline && useCustomerName){
			out.print("<h2 style='text-align: center;'>Cannot get revenue summary for flight number, airline, and customer name. Please choose 1!</h2>");
		}
		else if(useFlightNumber && useAirline){
			out.print("<h2 style='text-align: center;'>Cannot get revenue summary for flight number and airline. Please choose 1!</h2>");
		}
		else if(useFlightNumber && useCustomerName){
			out.print("<h2 style='text-align: center;'>Cannot get revenue summary for flight number and customer name. Please choose 1!</h2>");
		}
		else if(useAirline && useCustomerName){
			out.print("<h2 style='text-align: center;'>Cannot get revenue summary for airline and customer name. Please choose 1!</h2>");
		}
		else if(useAirline){
			//create statement 
			Statement getAirlineRevenue = connection.createStatement(); 
			//create the query 
			String query = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.airline_id='"+airline+"' and t.account_num != -1";
			//execute the query 
			getAirlineRevenue.execute(query); 
			//get the results 
			ResultSet rs = getAirlineRevenue.getResultSet(); 
			//check for results 
			if(!rs.next()){
				out.print("<h2 style='text-align: center;'>No revenue summary can be provided!</h2>");
			}
			else{
				rs.beforeFirst();
				double totalRevenue = 0;
				out.print("<table border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
					totalRevenue += Double.parseDouble(rs.getString("Price"));
				}
				out.print("</table>");
				out.print("<h2 style='text-align: center;'>Total Revenue: "+totalRevenue+"</h2>");
			}
		}
		else if(useFlightNumber){
			//create statement 
			Statement getAirlineRevenue = connection.createStatement(); 
			//create the query 
			String query = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where fo.flight_number="+flightNumber+" and t.account_num != -1";
			//execute the query 
			getAirlineRevenue.execute(query); 
			//get the results 
			ResultSet rs = getAirlineRevenue.getResultSet(); 
			//check for results 
			if(!rs.next()){
				out.print("<h2 style='text-align: center;'>No revenue summary can be provided!</h2>");
			}
			else{
				rs.beforeFirst();
				double totalRevenue = 0;
				out.print("<table border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
					totalRevenue += Double.parseDouble(rs.getString("Price"));
				}
				out.print("</table>");
				out.print("<h2 style='text-align: center;'>Total Revenue: "+totalRevenue+"</h2>");
			}
		}
		else{
			//get the account number from the customer name 
			Statement getAcctNum = connection.createStatement(); 
			getAcctNum.execute("select account_num from Person where name='"+customerName+"'");
			ResultSet rs0 = getAcctNum.getResultSet(); 
			int accountNumber = -1;
			if(rs0.next()){
				accountNumber = rs0.getInt("account_num");
			}
			//create statement 
			Statement getAirlineRevenue = connection.createStatement(); 
			//create the query 
			String query = "select t.account_num, t.ticket_number, fo.airline_id, fo.flight_number, t.seat_class, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.num_stops, t.ticket_price as 'Price' from Flight_Operates fo JOIN Tickets t on fo.aircraft_id = t.aircraft_id and fo.airline_id = t.airline_id and fo.airport_id = t.airport_id and fo.flight_number = t.flight_number where t.account_num="+accountNumber;
			//execute the query 
			getAirlineRevenue.execute(query); 
			//get the results 
			ResultSet rs = getAirlineRevenue.getResultSet(); 
			//check for results 
			if(!rs.next()){
				out.print("<h2 style='text-align: center;'>No revenue summary can be provided!</h2>");
			}
			else{
				rs.beforeFirst();
				double totalRevenue = 0;
				out.print("<table border=2 align='center'><tr><td>Account Number</td><td>Ticket Number</td><td>Airline ID</td><td>Flight Number</td><td>Seat Class</td><td>Departure Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Number of Stops</td><td>Price</td></tr>");
				while(rs.next()){
					out.print("<tr><td>"+rs.getString("account_num")+"</td><td>"+rs.getString("ticket_number")+"</td><td>"+rs.getString("airline_id")+"</td><td>"+rs.getString("flight_number")+"</td><td>"+rs.getString("seat_class")+"</td><td>"+rs.getString("depart_time")+"</td><td>"+rs.getString("arrival_time")+"</td><td>"+rs.getString("departure_airport")+"</td><td>"+rs.getString("destination_airport")+"</td><td>"+rs.getString("num_stops")+"</td><td>"+rs.getString("Price")+"</td></tr>");
					totalRevenue += Double.parseDouble(rs.getString("Price"));
				}
				out.print("</table>");
				out.print("<h2 style='text-align: center;'>Total Revenue: "+totalRevenue+"</h2>");
			}
		}
	}
	//Customer - largest revenue 
	else if(option.equals("Customer - Largest Revenue")){
		out.print("<h1 style='text-align: center;'>Largest Customer Revenue</h1>");
		//create a statement 
		Statement largestRevenue = connection.createStatement(); 
		//create the query 
		String query = "SELECT  account_num FROM Tickets where account_num != -1 GROUP BY account_num ORDER BY count(account_num) DESC LIMIT 1";
		//execute the query 
		largestRevenue.execute(query);
		//get the results 
		ResultSet rs = largestRevenue.getResultSet(); 
		//check for results
		if(!rs.next()){
			out.print("<h2 style='text-align: center;'>No customers have made any reservations!</h2>");
		}
		else{
			rs.beforeFirst();
			String lRevenue = "";
			while(rs.next()){
				lRevenue = rs.getString("account_num");
			} 
			//create statement to get customer name from account number 
			Statement getName = connection.createStatement();      
			
			
			getName.execute("select name from Person where account_num="+lRevenue);
			ResultSet rs2 = getName.getResultSet(); 
			String person = "";
			while(rs2.next()){
				person = rs2.getString("name");
			}
			out.print("<h2 style='text-align: center;'>Largest customer revenue generated by: "+person+"</h2>");
		}
	}
	//Most Active Flights List 
	else if(option.equals("Most Active Flights List")){
		out.print("<h1 style='text-align: center;'>Most Active Flights</h1>");
		//create statement to fetch the most active flights 
		Statement mostActiveFlightNumbers = connection.createStatement(); 
		//create query 
		String query = "SELECT  flight_number, airline_id FROM Tickets where account_num != -1 GROUP BY flight_number ORDER BY count(flight_number) DESC";
		//execute the query 
		mostActiveFlightNumbers.execute(query);
		//get the results of the query 
		ResultSet rs = mostActiveFlightNumbers.getResultSet(); 
		if(!rs.next()){
			out.print("<h2 style='text-align: center;'>There are no active flights!</h2>");
		}
		else{
			rs.beforeFirst();
			//print the table 
			out.print("<table border=2 align='center'><tr><td>Flight Number</td><td>Airline ID</td><td>Airport ID</td><td>Flight Type</td><td>Depart Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Depart Date</td><td>Return Date</td></tr>");
			while(rs.next()){
				String flightNumber = rs.getString("flight_number");
				String airlineID = rs.getString("airline_id");
				//get the flight information for 
				Statement getFlightInfo = connection.createStatement(); 
				//execute the query 
				getFlightInfo.execute("select fo.flight_number, fo.airline_id, fo.airport_id, fo.flight_type, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.depart_date, fo.return_date from Flight_Operates fo where fo.flight_number="+flightNumber+" and fo.airline_id = '"+airlineID+"'");
				//get the information 
				ResultSet rs2 = getFlightInfo.getResultSet(); 
				//print the info 
				while(rs2.next()){
					out.print("<tr><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("airport_id")+"</td><td>"+rs2.getString("flight_type")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("depart_date")+"</td><td>"+rs2.getString("return_date")+"</td></tr>");
				}
			}	
			out.print("</table>");
		}
	}
	//Airport Flights List
	else if(option.equals("Airport Flights List")){
		out.print("<h1 style='text-align: center;'>Airport Flights</h1>");
		//create connection to the database 
		Statement getFlights = connection.createStatement(); 
		//fetch the airport id entered
		String airportID = (String) request.getParameter("airportflightslistairport");
		//create the query 
		String query = "select fo.flight_number, fo.airline_id, fo.airport_id, fo.flight_type, fo.depart_time, fo.arrival_time, fo.departure_airport, fo.destination_airport, fo.depart_date, fo.return_date from Flight_Operates fo where fo.airport_id='"+airportID+"'";
		//execute the query 
		getFlights.execute(query); 
		//get the results 
		ResultSet rs2 = getFlights.getResultSet();
		//check if there are results 
		if(!rs2.next()){
			out.print("<h2 style='text-align: center;'>There are no flights scheduled!</h2>");
		}
		else{
			rs2.beforeFirst();
			//print the table 
			out.print("<table border=2 align='center'><tr><td>Flight Number</td><td>Airline ID</td><td>Airport ID</td><td>Flight Type</td><td>Depart Time</td><td>Arrival Time</td><td>Departure Airport</td><td>Destination Airport</td><td>Depart Date</td><td>Return Date</td></tr>");
			//print the results
			while(rs2.next()){
				out.print("<tr><td>"+rs2.getString("flight_number")+"</td><td>"+rs2.getString("airline_id")+"</td><td>"+rs2.getString("airport_id")+"</td><td>"+rs2.getString("flight_type")+"</td><td>"+rs2.getString("depart_time")+"</td><td>"+rs2.getString("arrival_time")+"</td><td>"+rs2.getString("departure_airport")+"</td><td>"+rs2.getString("destination_airport")+"</td><td>"+rs2.getString("depart_date")+"</td><td>"+rs2.getString("return_date")+"</td></tr>");
			}
			out.print("</table>");
		}
	}

	//close the database connection 
	ApplicationDB.closeConnection(connection);	
	
%>

</body>
</html>