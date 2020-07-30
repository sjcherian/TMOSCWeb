<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ page import="java.util.concurrent.ThreadLocalRandom"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilter"%>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilterOperator"%>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection"%>
<%@ page import="com.google.appengine.api.datastore.Cursor"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Date"%>
<%@ page import="java.util.TimeZone"%> 
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.io.PrintWriter,com.google.appengine.api.datastore.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Lectionary</title>

    <!-- Bootstrap -->
    <link href="/assets/css/bootstrap.min.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>	
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>
<body>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="/assets/js/bootstrap.min.js"></script>
      		<div class="container">
		
		<div class="page-header">
			<h2>Lectionary</h2>
			<ol class="breadcrumb">
				<li><a href="/">Back</a></li>
			</ol>
		</div>

<%
int PAGE_SIZE = 100000;

String category ="";
String date = "";
String title = ""; 
String type = "" ;
String time ="";
String order = "";

String verse= "";
String verseString = "";
long appKey;

String DISPLAY_DATEFORMAT = "dd-MMM-yyyy";

StringBuffer aRow = new StringBuffer();

DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

FetchOptions fetchOptions = FetchOptions.Builder
								.withLimit(PAGE_SIZE);

Date today = new Date();

SimpleDateFormat sdf = new SimpleDateFormat(DISPLAY_DATEFORMAT);
String filterDate = "";

String altDate = request.getParameter("AltDate");

Filter dateFilter ;

if(altDate == null)
{
	//System.out.println("Alt Date is null. Using Today");
	filterDate = sdf.format(today);
/* 	dateFilter =
			  new FilterPredicate("Date",
			                      FilterOperator.GREATER_THAN_OR_EQUAL,
			                      filterDate);
 */
}
else
{
	//System.out.println("Alt Date:"+altDate);
	filterDate = altDate;

	
}


//System.out.println("Filter Date:"+filterDate);
//String filterDate ; // = "25-Mar-2016"; 
	dateFilter =
			  new FilterPredicate("Date",
			                      FilterOperator.EQUAL,
			                      filterDate);

		
// Use class Query to assemble a query
Query q = new Query("Lectionary");
 
q.setFilter(dateFilter);
//q.addSort("Date");
q.addSort("CreatedDate");
//q.addSort("Order");
PreparedQuery pq = datastore.prepare(q);
				
						
QueryResultList<Entity> results = pq
		.asQueryResultList(fetchOptions);

int resultSize = results.size() ; 

if(resultSize!=0)
{
	boolean firstTime = true;
								
	for (Entity dailyVerse : results) {
	
		title = (String) dailyVerse.getProperty("Title");
		
		if(firstTime)
		{
			aRow.append("<H4>");
			aRow.append(filterDate);
			aRow.append(" - ");
			aRow.append(title);
			aRow.append(" ");
			//aRow.append("<button class=\"btn btn-danger btn-large\" type=\"button\">Change Date</button>");
			aRow.append("<a href=\"\\lectionary.jsp?AltDate=01-Jan-2000\" button class=\"btn btn-danger btn-large\">Change Date</a>");

			aRow.append("</H4>");
			aRow.append("<div><table class=\"table table-condensed\" >");

//			aRow.append("<tr><td>");
//			aRow.append("Time");
//			aRow.append("</td><td>");
//			aRow.append("Order");
//			aRow.append("</td><th>");
//			aRow.append("Verse");
//			aRow.append("</td><th>");
//			aRow.append("Reading");
			aRow.append("</td></tr>");
					
			firstTime=false;
		}
		verse = (String) dailyVerse.getProperty("Verse");								
		date   = (String) dailyVerse.getProperty("Date");
		time   = (String) dailyVerse.getProperty("Time");
		order   = (String) dailyVerse.getProperty("Order");
		
		Object tmp = dailyVerse.getProperty("VerseText") ;
							
		if (tmp instanceof Text)
	        verseString  = ((Text)tmp).getValue();
	    else
	        System.out.println("Unexpected datatype"
	            );
								
										
		appKey = dailyVerse.getKey().getId();

		aRow.append("<tr><td><b>");
										
		aRow.append(time);							
		aRow.append("</b></td><td><b>");
			
		//aRow.append(order);							
		//aRow.append("</td><td>");
									
		aRow.append(verse);
		aRow.append("</b></td><td>");
		aRow.append(verseString);

		aRow.append("</td></tr>");
									
	}// Loop End
						
	aRow.append("</table></div>");
	out.println(aRow.toString());

}else
{
	//out.println("<h4>No readings for : "+filterDate+"</h4>");

	
	Query dates = new Query("Lectionary");
	//dates.addProjection(new PropertyProjection("Date", String.class));
	dates.addProjection(new PropertyProjection("Date", String.class));
	dates.addProjection(new PropertyProjection("Title", String.class));
	dates.addProjection(new PropertyProjection("CreatedDate", Date.class));
	
	dates.setDistinct(true);
	//dates.se
	//dates.setFilter(dateFilter);

	dates.addSort("CreatedDate",SortDirection.ASCENDING);
	//dates.addSort("Title");
	
	
	PreparedQuery pqDates = datastore.prepare(dates);
					
	FetchOptions fetchOptionsDates = FetchOptions.Builder.withLimit(PAGE_SIZE);
							
	QueryResultList<Entity> resultsDates = pqDates.asQueryResultList(fetchOptionsDates);

	int resultsDatesSize = resultsDates.size() ; 

	Date createdDate = null; 
	if(resultsDatesSize!=0)
	{
		//out.println("Got results:"+resultsDatesSize);
		out.println("<H4>Please select a day from the following: </H4><BR>");

		LinkedHashMap<String,String> lhm = new LinkedHashMap<String,String>();	
		
		for (Entity readingDates : resultsDates) {
							
			date   = (String) readingDates.getProperty("Date");
			title   = (String) readingDates.getProperty("Title");
			createdDate   = (Date)readingDates.getProperty("CreatedDate");
			
			lhm.put(date, title);
			//out.println(date+" - "+title+" created:"+createdDate+"<BR>");
		}
		
        Iterator it = lhm.entrySet().iterator();


        while(it.hasNext())
        {
            Map.Entry me = (Map.Entry)it.next();

            date = (String)me.getKey();
            title = ((String)me.getValue()).toString();
			out.println("<a href=\"\\lectionary.jsp?AltDate="+date+"\" button class=\"btn btn-danger btn-large\" >"+date+"</a> - " +title+ "<BR>");

        }

		
	}
	else
	{
		out.println("** Lectionary - Data Update in progress . Please check back after a few hours. ***");
		
	}
}
	

	

					



%>

	</div>
</body>
</html>