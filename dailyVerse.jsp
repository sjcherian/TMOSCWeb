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
<%@ page import="java.util.*,java.io.PrintWriter,com.google.appengine.api.datastore.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Daily Verse</title>

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
			<h2>Daily Verse</h2>
			<ol class="breadcrumb">
				<li><a href="/">Back</a></li>
			</ol>
		</div>

<%
int PAGE_SIZE = 2;
String verse= "";
String verseText = "";
long appKey;

int min=0;
int max=410;
StringBuffer aRow = new StringBuffer();

						DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

						Filter statusFilter = null;
						Filter gradeFilter = null;

						
						FetchOptions fetchOptions = FetchOptions.Builder
								.withLimit(PAGE_SIZE);
						
						
			
						int offset = ThreadLocalRandom.current().nextInt(min, max + 1);
						out.println("<!-- Offset:" + offset+ "-->");
						
						fetchOptions.offset(offset);
						// If this servlet is passed a cursor parameter, let's use it
						

						// Use class Query to assemble a query
						Query q = new Query("DailyVerse");
						 
						
						q.addSort("Verse");
		
						PreparedQuery pq = datastore.prepare(q);

						int resultsCount = pq.countEntities(FetchOptions.Builder
								.withLimit(1));
						
						
						
						QueryResultList<Entity> results = pq
								.asQueryResultList(fetchOptions);
						
						aRow.append("<h4>");
						for (Entity dailyVerse : results) {

							verse = (String) dailyVerse.getProperty("Verse");
							verseText = (String) dailyVerse.getProperty("VerseText");
														

							
							appKey = dailyVerse.getKey().getId();


							aRow.append(verse);
							aRow.append("</h4>");
							aRow.append("<br>");
							aRow.append(verseText);
							
							out.println(aRow.toString());

							aRow.setLength(0);
							
							break;

						}// Loop End
	
						
%>

	</div>
</body>
</html>