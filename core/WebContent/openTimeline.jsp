<%@page import="com.resource.Document"%>
<%@page import="com.irwebapp.pkg.ProcessSearchResult"%>
<%@page import="com.irwebapp.pkg.MyServlet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/openTimeline.css">
	<link rel="stylesheet"
		href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
		integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"
		crossorigin="anonymous">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.1/css/font-awesome.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Search Results</title>
	<script src="js/openTimeline.js" type="text/javascript"></script>
</head>
<body>
	<nav class="navbar navbar-default" style="background-color:#7E619F;">
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="#" style="color: white;">SearchEngine</a>
		</div>
		<ul class="nav navbar-nav">
			<li class="active"><a href="#" style="color: black;">Home</a></li>
		</ul>
	</div>
	</nav>

	<div class="container" style="color: black;">
		<form role="form" action="MyServlet">
			<div class="form-group">
				<label for="email"><b>ENTER SEARCH QUERY:</b></label> <input
					type="text" name="search" class="form-control" id="search">
			</div>
			<button type="submit" class="btn btn-default">Submit</button>
		</form>
	</div>
	<br>
	<br>

	<%@ page import="org.json.*"%>
	<%@ page import="java.util.*"%>
	<%
		String content = (String) request.getAttribute("content");
		String search = (String) request.getAttribute("search");
		String yr = (String) request.getAttribute("year");
		HashMap<String, Object> parsedContent = ProcessSearchResult.getContenForTimeTimeLine(content);
		String numOfResponse = (String)parsedContent.get("numOfResponse");
		String time = (String)parsedContent.get("respones_time_in_millisecond");
		Map<String, List<Document>> year_docidMap = (TreeMap<String, List<Document>>)parsedContent.get("year_docMap");
		Map<String, List<Document>> map = (TreeMap<String, List<Document>>) session.getAttribute("data");
		List<Document> yearData = map.get(yr);
	%>
	<%
		session.setAttribute("data", year_docidMap);
	%>
	<div class="container" id="leftTimeline">
		<div id="innerTimeline">
			<div class="page-header">
				<!--<h3 id="timeline"><span style="color:red;">TIMELINE</span></h3>-->
				<br>
			</div>
			<ul class="timeline">
				<%
					int i=0;
			  		for (String year : year_docidMap.keySet()) {
			  			String url = "OpenFileServlet?year="+year+"&search="+search;
				%>
				<%
					if(i%2==0) {
				%>
				<li><a id="dateLink" href=<%=url%>><div
							class="timeline-badge info"><%=year%></div></a>
					<div class="timeline-panel">
						<div class="timeline-heading">
							<p class="timeline-title"><%=year_docidMap.get(year).size()%>
							News Articles
							</p>
							<!--<p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>-->
						</div>
						<div class="timeline-body">
							
						</div>
					</div></li>
				<%
					} 
				else{
				%>
				<li class="timeline-inverted"><a id="dateLink" href=<%=url%>><div
							class="timeline-badge warning"><%=year%></div></a>
					<div class="timeline-panel">
						<div class="timeline-heading">
							<p class="timeline-title"><%=year_docidMap.get(year).size()%>
							News Articles	
							</p>
							<!--<p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>-->
						</div>
						<div class="timeline-body">
							
						</div>
					</div></li>
				<%
					}
				%>
				<%
					i++;
			  											  		}
				%>
			</ul>
		</div>
	</div>
	<div id="searchResult">
		<h3>Showing results for <span style="color:red;"><%= search %></span> based on year <span style="color:red;"><%= yr %></span></h3>
		<br>
		<hr style="width:60%; border-top:2px solid #eee; margin-left:15px;" align="left" size="3px">
		<%
			int maxIteration = 0;
			if(yearData.size()<10)
				maxIteration = yearData.size();
			else
				maxIteration = 10;
			for(int j=0; j<maxIteration; j++){ 
				String headline = yearData.get(j).getDocAsJSON().getJSONArray("headline").getString(0);
				String lead_para = yearData.get(j).getDocAsJSON().getJSONArray("lead_paragraph").getString(0);
				Document passData = yearData.get(j);
				headline = headline.replaceAll("'","");
				lead_para = lead_para.replaceAll("'","");
		%>
		<div class="article parentNode">
			<i class="fa fa-newspaper-o fa-lg fa-pull-left fa-border" aria-hidden="true"></i>
			<h4 style="margin-bottom:20px;"><a href="javascript:show('<%= headline %>','<%= lead_para %>')"><%=headline%></a></h4>
			<!--<h4 style="margin-bottom:20px;"><a onclick="show('<%= headline %>','<%= lead_para %>')"; href="#myModal" data-toggle="modal"><%=headline%></a></h4>-->
			<!--<i class="fa fa-paragraph fa-pull-left fa-border" aria-hidden="true"></i>
			<p style="margin-bottom:20px;"><%=lead_para %></p>-->
			<i class="fa fa-star fa-pull-left fa-border" aria-hidden="true"></i>
			<p>Rating:
		</div>
		<br>
		<hr style="width:60%; border-top:2px solid #eee; margin-left:15px;" align="left" size="3px">
		<br>
		<%
			}
		%>
	</div>
	
	<div id="childNode">
		<div id="insideChild" class="container">
			<i class="fa fa-newspaper-o fa-lg fa-pull-left fa-border" aria-hidden="true"></i>
			<h4 style="margin-bottom:20px;"><a id="headline"></a></h4>
			<div id="leadparaDiv">
				<i class="fa fa-paragraph fa-pull-left fa-border" aria-hidden="true"></i>
				<p id="leadpara" style="margin-bottom:20px;"></p>
			</div>
			<i class="fa fa-star fa-pull-left fa-border" aria-hidden="true"></i>
			<p>User Ratings:</p>
			<table>
				<tr>
					<td>5 Stars</td>
					<td><div id="stars-5" data-rating="5"><input type="hidden" name="rating"/></div></td>
					<td>(5 Users)</td>
				</tr>
				<tr>
					<td>4 Stars</td>
					<td><div id="stars-4" data-rating="4"><input type="hidden" name="rating"/></div></td>
					<td>(5 Users)</td>
				</tr>
				<tr>
					<td>3 Stars</td>
					<td><div id="stars-3" data-rating="3"><input type="hidden" name="rating"/></div></td>
					<td>(5 Users)</td>
				</tr>
				<tr>
					<td>2 Stars</td>
					<td><div id="stars-2" data-rating="2"><input type="hidden" name="rating"/></div></td>
					<td>(5 Users)</td>
				</tr>
				<tr>
					<td>1 Stars</td>
					<td><div id="stars-1" data-rating="1"><input type="hidden" name="rating"/></div></td>
					<td>(5 Users)</td>
				</tr>
			</table>
				
			
			<p>Provide Rating:</p>
			<form action="#">
				<span class="rating">
				        <input type="radio" class="rating-input" id="rating-input-1-5" name="rating-input-1"/>
				        <label for="rating-input-1-5" class="rating-star"></label>
				        <input type="radio" class="rating-input" id="rating-input-1-4" name="rating-input-1"/>
				        <label for="rating-input-1-4" class="rating-star"></label>
				        <input type="radio" class="rating-input"
				                id="rating-input-1-3" name="rating-input-1"/>
				        <label for="rating-input-1-3" class="rating-star"></label>
				        <input type="radio" class="rating-input"
				                id="rating-input-1-2" name="rating-input-1"/>
				        <label for="rating-input-1-2" class="rating-star"></label>
				        <input type="radio" class="rating-input"
				                id="rating-input-1-1" name="rating-input-1"/>
				        <label for="rating-input-1-1" class="rating-star"></label>
				</span>
				<a></a>
			</form>
			<!--
			<div class="container">
		    <div class="row lead">
		        <div id="stars" class="starrr"></div>
		        You gave a rating of <span id="count">0</span> star(s)
			</div>
		    
		    <div class="row lead">
		        <p>Also you can give a default rating by adding attribute data-rating</p>
		        <div id="stars-existing" class="starrr" data-rating='4'></div>
		        You gave a rating of <span id="count-existing">4</span> star(s)
		    </div>
		    -->
</div>
			<button align="center" class="btn btn-lg btn-danger" onclick="hide()">Close</button>
		</div>
	</div>
	<script type="text/javascript">
		function show(headline,leadpara){
			document.getElementById("childNode").style.visibility = "visible";
			//var div1 = document.getElementById("modal-title");
			//var div2 = document.getElementById("modal-body");
			var div1 = document.getElementById("headline");
			var div2 = document.getElementById("leadpara");
			div1.innerHTML = "";
			div2.innerHTML = "";
			var headlineText = document.createTextNode(headline);
			var leadparaText = document.createTextNode(leadpara);
			div1.appendChild(headlineText);
			div2.appendChild(leadparaText);
			$("#stars-5").rating();
			$("#stars-4").rating();
			$("#stars-3").rating();
			$("#stars-2").rating();
			$("#stars-1").rating();
		}
		function hide() {
			document.getElementById("childNode").style.visibility = "hidden";
		}
	</script>

</body>
</html>