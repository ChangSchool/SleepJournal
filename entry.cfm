<!doctype html>
<html>

<cfparam name="url.d" default="">

<cftry>
	<cfset userid = decrypt(cookie.sleepjournal.user, application.key)>
	<cfcatch type="any">
		<cfset userid = 0>
	</cfcatch>
</cftry>

<cfif not isDefined("cookie.sleepjournal.date")>
	<cfcookie name="sleepjournal.date" value="#url.d#">
<cfelse>
	<cfset cookie.sleepjournal.date = url.d>
</cfif>

<cfquery name="q"  datasource="sleepjournal">
	SELECT * FROM user_entries
	WHERE user_id = <cfqueryparam value="#userid#" cfsqltype="cf_sql_integer">
		AND entry_date = <cfqueryparam value="#dateFormat(cookie.sleepjournal.date, "mm/dd/yyyy")#" cfsqltype="cf_sql_datetime">
</cfquery>

<cfif isDefined("form.entry_date") and userid gt 0>
	<cfif q.recordCount gt 0>
		<cfquery name="qUpdate"  datasource="sleepjournal">
			UPDATE user_entries
			SET in_bed=<cfqueryparam value="#form._in_bed#" cfsqltype="cf_sql_datetime">, 
				try_to_sleep=<cfqueryparam value="#form._try_to_sleep#" cfsqltype="cf_sql_datetime">, 
				minutes_to_sleep=<cfqueryparam value="#form.minutes_to_sleep#" cfsqltype="cf_sql_integer">, 
				number_of_wakeups=<cfqueryparam value="#form.number_of_wakeups#" cfsqltype="cf_sql_integer">, 
				minutes_awake=<cfqueryparam value="#form.minutes_awake#" cfsqltype="cf_sql_integer">,
				final_awakening=<cfqueryparam value="#form._final_awakening#" cfsqltype="cf_sql_datetime">,
				out_of_bed=<cfqueryparam value="#form._out_of_bed#" cfsqltype="cf_sql_datetime">,
				sleep_quality=<cfqueryparam value="#form.sleep_quality#" cfsqltype="cf_sql_integer">,
				comments=<cfqueryparam value="#form.comments#" cfsqltype="cf_sql_varchar">
			WHERE user_id = <cfqueryparam value="#userid#" cfsqltype="cf_sql_integer">
				AND entry_date = <cfqueryparam value="#dateFormat(form.entry_date, "mm/dd/yyyy")#" cfsqltype="cf_sql_datetime">
		</cfquery>
	<cfelse>
		<cfquery name="qCreate"  datasource="sleepjournal">
			INSERT INTO user_entries (
				user_id,
				entry_date,
				in_bed, 
				try_to_sleep, 
				minutes_to_sleep, 
				number_of_wakeups, 
				minutes_awake,
				final_awakening,
				out_of_bed,
				sleep_quality,
				comments) 
			VALUES (
				<cfqueryparam value="#userid#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#dateFormat(form.entry_date, "mm/dd/yyyy")#" cfsqltype="cf_sql_datetime">,
				<cfqueryparam value="#form._in_bed#" cfsqltype="cf_sql_datetime">,
				<cfqueryparam value="#form._try_to_sleep#" cfsqltype="cf_sql_datetime">,
				<cfqueryparam value="#form.minutes_to_sleep#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#form.number_of_wakeups#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#form.minutes_awake#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#form._final_awakening#" cfsqltype="cf_sql_datetime">,
				<cfqueryparam value="#form._out_of_bed#" cfsqltype="cf_sql_datetime">,
				<cfqueryparam value="#form.sleep_quality#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#form.comments#" cfsqltype="cf_sql_varchar">)
		</cfquery> 
	</cfif>
	<!---
	<cfset theURL = getPageContext().getRequest().GetRequestUrl().toString()>
	<cfif len( CGI.query_string )><cfset theURL = theURL & "?" & CGI.query_string></cfif>
	--->
	<cfset theURL = "index.cfm">
	<cflocation addtoken="no" url="#theURL#">
</cfif>

<head>
<title>Sleep Journal: <cfif isNumeric(url.d)><cfoutput>#dateFormat(url.d, "mmmm dd, yyyy")#</cfoutput><cfelse>Error</cfif></title>
<cfinclude template="_/head.inc">
<script src="_/js/DateTime.js"></script>
<script>
var cfdate = new Date("<cfoutput>#getHttpTimeString(dateConvert("local2utc", url.d))#</cfoutput>");
	
cfdate.setHours(0);
cfdate.setMinutes(0);

$(document).ready(function() {
	
	$(".datetime").each(function(){
		var d;
		$this = $(this);
		d = new Date($this.data("date"));
		d = (d != "Invalid Date") ? d : cfdate
		$this.DateTime({currentDate: cfdate, selectedDate: d});
	});
	
	$(window).on("keydown", function(e) {
		if (e.keyCode == 27) {
			e.preventDefault();
			cancelAndReturn();
		}
	});
});

function cancelAndReturn() {
	if (confirm("Attention! Any changes you might have made will not be saved.\n\nAre you sure you want to proceed?")) location.href='index.cfm';
}
</script>
</head>

<body>
<cfoutput>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article class="box content">
	<cfif isNumeric(url.d)>
		<form name="frmRecord" action="" method="post">
		<input type="hidden" name="entry_date" value="#dateFormat(url.d, "mmmm dd, yyyy")#">
		<h2>The night of #dateFormat(url.d, "mmmm d, yyyy")#</h2>
		<p class="attention">Note: All times must be entered in 12-hour format, e.g. 12:00 AM for midnight, or 12:00 PM for noon.</p>
		<p class="row">What time did you get into bed?<br>
			<div class="datetime" id="in_bed" <cfif isDate(q.in_bed)> 
					data-date="#dateFormat(q.in_bed,"mm/dd/yyyy")# #timeFormat(q.in_bed,"HH:mm")#"</cfif>> </div>
		</p>
		<p class="row alt">What time did you try to go to sleep?<br>
			<div class="datetime" id="try_to_sleep" <cfif isDate(q.try_to_sleep)> 
					data-date="#dateFormat(q.try_to_sleep,"mm/dd/yyyy")# #timeFormat(q.try_to_sleep,"HH:mm")#"</cfif>></div>
		</p>
		<p class="row"><label for="minutes_to_sleep">How long did it take to fall asleep (in minutes)?</label><br>
			<input name="minutes_to_sleep" id="minutes_to_sleep" type="number" class="number" min="0" step="1" value="#q.minutes_to_sleep#">
		</p>
		<p class="row alt"><label for="number_of_wakeups">How many times did you wake up (not counting the final awakening)?</label><br>
			<input name="number_of_wakeups" id="number_of_wakeups" type="number" class="number" min="0" step="1" value="#q.number_of_wakeups#">
		</p>
		<p class="row"><label for="minutes_awake">In total, how long did these awakenings last (in minutes)?</label><br>
			<input name="minutes_awake" id="minutes_awake" type="number" class="number" min="0" step="1" value="#q.minutes_awake#">
		</p>
		<p class="row alt">What time was your final awakening?<br>
			<div class="datetime" id="final_awakening" <cfif isDate(q.final_awakening)> 
					data-date="#dateFormat(q.final_awakening,"mm/dd/yyyy")# #timeFormat(q.final_awakening,"HH:mm")#"</cfif>> </div>
		</p>
		<p class="row">What time did you get out of bed for the day?<br>
			<div class="datetime" id="out_of_bed" <cfif isDate(q.out_of_bed)> 
					data-date="#dateFormat(q.out_of_bed,"mm/dd/yyyy")# #timeFormat(q.out_of_bed,"HH:mm")#"</cfif>> </div>
		</p>
		<p  class="row alt"><label for="sleep_quality">How would you rate the quality of your sleep?</label><br>
			<span class="css-select"><select name="sleep_quality"  id="sleep_quality">
				<option value="0">...</option>
				<option value="5" <cfif q.sleep_quality eq 5> selected</cfif>>Very Good</option>
				<option value="4" <cfif q.sleep_quality eq 4> selected</cfif>>Good</option>
				<option value="3" <cfif q.sleep_quality eq 3> selected</cfif>>Fair</option>
				<option value="2" <cfif q.sleep_quality eq 2> selected</cfif>>Poor</option>
				<option value="1" <cfif q.sleep_quality eq 1> selected</cfif>>Very Poor</option>
			</select></span>
		</p>
		<p class="row"><label for="comments">Comments (optional):</label><br>
			<textarea name="comments" id="comments" class="input-text">#q.comments#</textarea>
		</p>
		<p><input type="submit" name="btnSubmit" value="Save">
				<input type="button" name="btnCancel" value="Cancel" onClick="cancelAndReturn();"></p>
		</form>
	<cfelse>
		<h2>Error</h2>
		<p class="alert">Date is not specified.</p>
		<p><input type="button" name="btnCancel" value="Cancel" onClick="location.href='index.cfm';"></p>
	</cfif>
</article>
<footer>
	<p><a href="admin.cfm">Admin</a> | <a href="javascript:void(0);">Edit Profile</a> | <a href="javascript:void(0);" onClick="userLogOut();">Logout #getAuthUser()#</a></p>
	<p>&copy;2014 The Chang School</p>
</footer>
<form name="frmLogout" action="" method="post">
	<input type="hidden" name="logout" value="1">
</form>
</cfoutput>
</body>
</html>