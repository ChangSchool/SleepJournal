<!doctype html>
<html>
<cfif isDefined("url.d")>
	<cfif not isDefined("cookie.sleepjournal.date")>
		<cfcookie name="sleepjournal.date" value="#url.d#">
	<cfelse>
		<cfset cookie.sleepjournal.date = url.d>
	</cfif>
<cfelseif not isDefined("cookie.sleepjournal.date")>
	<cfcookie name="sleepjournal.date" value="#int(now())#">	
</cfif>

<cfset today = now()>
<cfset current = cookie.sleepjournal.date>
<cfset first = createDate(year(current), month(current), 1)>
<cfset start = dateAdd("d", 1 - dayOfWeek(first), first)>
<cfset last = createDate(year(current), month(current), daysInMonth(current))>
<cfset end = dateAdd("d", ceiling(dateDiff("d", start, last) / 7) * 7 - 1, start)>

<cfset prevMonth = int(dateAdd("m", -1, first))>
<cfset nextMonth = int(dateAdd("m", 1, first))>

<cfobject name="slj" component="sleepjournal._.sleepjournal">
<cfinvoke component="#slj#" method="getMonthData" today="#today#" current="#cookie.sleepjournal.date#" returnvariable="q">

<head>
<title>Sleep Journal: <cfoutput>#dateFormat(current, "mmmm yyyy")#</cfoutput></title>
<cfinclude template="_/head.inc">
<script src="_/js/Tabs.js"></script>
<script src="_/js/Calendar.js"></script>
<script>
var tabs, calendar;
$(document).ready(function(e) {
	
	tabs = des.Tabs("myTabs");
	tabs = des.Calendar("myCalendar");
		
	$('a:not([href^="javascript"])').click(function(){
		self.location = $(this).attr('href');
		return false;
	});
	
});
</script>
</head>



<body>
<cfoutput>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article class="box content" role="application">
	<div class="monthnav">
		<button onclick="document.location.href = '?d=#prevMonth#'" aria-label="Go to #dateFormat(prevMonth, "mmmm yyyy")#">
			<img src="_/img/arrow-left@2x.png" width="18" height="24" border="0" alt="">
		</button>
		<button onclick="document.location.href = '?d=#int(today)#'" aria-label="Go to current month">
			Today
		</button>
		<button onclick="document.location.href = '?d=#nextMonth#'" aria-label="Go to #dateFormat(nextMonth, "mmmm yyyy")#">
			<img src="_/img/arrow-right@2x.png" width="18" height="24" border="0" alt="">
		</button>
	</div>
	<h2 id="monthlabel">#dateFormat(current, "mmmm yyyy")#</h2>
	<table id="myCalendar" width="100%" cellspacing="0" cellpadding="0" border="0" role="grid" aria-labelledby="monthlabel" class="cal">
		<thead>
			<tr>
			<cfloop from="1" to="7" index="i">
				<cfset w = dayOfWeekAsString(i)>
				<th id="weekday#i#" width="14.2%">
					#left(w,3)#
				</th>
			</cfloop>
			</tr>
		</thead>
		<tbody role="rowgroup">
			<tr role="row">
			<cfset n = 1>
			<cfloop from="#start#" to="#end#" index="d">
				<cfset styles = "date">
				<cfloop query="q">
					<cfif d eq q.date and q.tst gt "">
						<cfset styles = "hasdata">
					</cfif>
					<cfif d eq createDate(year(today), month(today), day(today))>
						<cfset styles = listAppend(styles, "today", " ")>
					</cfif>
				</cfloop>
				<cfif n gt 7>
					</tr><tr role="row">
					<cfset n = 1>
				</cfif>
				<cfif month(d) neq month(current)>
					<td role="gridcell" aria-label="#dateFormat(d, "dddd mmmm dd, yyyy")#" tabindex="-1" data-date="#d#">
				<cfelseif d eq current>
					<td role="gridcell" aria-label="#dateFormat(d, "dddd mmmm dd, yyyy")#" tabindex="0" aria-selected="true" data-date="#d#">	
				<cfelse>
					<td role="gridcell" aria-label="#dateFormat(d, "dddd mmmm dd, yyyy")#" tabindex="-1" aria-selected="false" data-date="#d#">
				</cfif>	
					
					<cfif month(d) neq month(current)>
						<div class="disabled" role="presentation">#dateFormat(d, "dd")#</div>	
					<cfelse>
						<div class="#styles#" role="presentation">#dateFormat(d, "dd")#</div>	
					</cfif>
				</td>
				<cfset n = n + 1>
			</cfloop>
			</tr>
		</tbody>
	</table>
	<div id="myTabs">
		<div title="Chart">
			<h3>Total Sleep Time (TST)</h3>
			<div class="graph">
				<cfchart format="png" style="_/sleepjournal_chart.xml"
					scaleto="8"
					backgroundcolor="##ffffff" 
					scalefrom="0"
					chartwidth="258" 
					chartheight="200"
					tipstyle="none">
					<cfchartseries type="line" query="q" valuecolumn="average" seriescolor="##ff0000" markerstyle="none">
					<cfchartseries type="bar" query="q" valuecolumn="tst" seriescolor="##33aaee">
				</cfchart>
			</div>
			<div class="graph_large">
				<cfchart format="png" style="_/sleepjournal_chart.xml" 
					scaleto="8"
					backgroundcolor="##ffffff" 
					scalefrom="0"
					chartwidth="412" 
					chartheight="280"
					tipstyle="none">
					<cfchartseries type="line" query="q" valuecolumn="average" seriescolor="##ff0000" markerstyle="none">
					<cfchartseries type="bar" query="q" valuecolumn="tst" seriescolor="##33aaee">
					
				</cfchart>
			</div>
		</div>
		<div title="Details">
			<table width="100%" height="100%" cellspacing="0" cellpadding="2" border="0">
				<thead>
					<tr>
						<th width="70">Date</th>
						<th> </th>
						<th width="70">TIB</th>
						<th width="70">TST</th>
						<th width="70">SE</th>
					</tr>
				</thead>
				<tbody>
				<cfloop query="q">
					<cfif tst gt "">
					<tr>
						<td align="center">#dateFormat(date,"MMM-DD")#</td>
						<td> </td>
						<td align="center">#tib#</td>
						<td align="center">#tst#</td>
						<td align="center">#numberFormat(tst/tib,"___.__")#</td>
					</tr>
					</cfif>
				</cfloop>
				</tbody>
			</table>
		</div>
	</div>
	<p class="download"><a href="export.cfm?d=#current#">Download Sleep Data</a></p>
</article>
<footer>
	<p><a href="admin.cfm">Admin</a> | <a href="profile.cfm">Edit Profile</a> | <a href="javascript:void(0);" onClick="userLogOut();">Logout #getAuthUser()#</a></p>
	<p>&copy;2014 The Chang School</p>
</footer>
<form name="frmLogout" action="" method="post">
	<input type="hidden" name="logout" value="1">
</form>
</cfoutput>
</body>
</html>