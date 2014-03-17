<!doctype html>
<html>

<cfparam name="url.d" default="">
<cfif not isDefined("cookie.sleepjournal.date")>
	<cfcookie name="sleepjournal.date" value="#url.d#">
<cfelse>
	<cfset cookie.sleepjournal.date = url.d>
</cfif>

<head>
<title>Sleep Journal: <cfif isNumeric(url.d)><cfoutput>#dateFormat(url.d, "mmmm dd, yyyy")#</cfoutput><cfelse>Error</cfif></title>
<cfinclude template="_/head.inc">
<script>
$(document).ready(function() {
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
		<h2>#dateFormat(url.d, "mmmm dd, yyyy")#</h2>
		<p class="attention">Note: All times must be entered in 12-hour format, e.g. 12:00 AM for midnight, or 12:00 PM for noon.</p>
		<p class="row"><label for="time_inbed">What time did you get into bed?</label><br>
			<input id="time_inbed" type="time" class="time" value="" placeholder="HH:MM AM/PM">
		</p>
		<p class="row alt"><label for="time_try2sleep">What time did you try to go to sleep?</label><br>
			<input id="time_try2sleep" type="time" class="time" value="" placeholder="HH:MM AM/PM">
		</p>
		<p class="row"><label for="time_min2sleep">How long did it take to fall asleep (in minutes)?</label><br>
			<input id="time_min2sleep" type="number" class="number" min="0" step="1" value="0">
		</p>
		<p class="row alt"><label for="num_wakeup">How many times did you wake up (not counting the final awakening)?</label><br>
			<input id="num_wakeup" type="number" class="number" min="0" step="1" value="0">
		</p>
		<p class="row"><label for="num_totalawake">In total, how long did these awakenings last (in minutes)?</label><br>
			<input id="num_totalawake" type="number" class="number" min="0" step="1" value="0">
		</p>
		<p class="row alt"><label for="time_finalawake">What time was your final awakening?</label><br>
			<input id="time_finalawake" type="time" class="time" value="" placeholder="HH:MM AM/PM">
		</p>
		<p class="row"><label for="time_outoffbed">What time did you get out of bed for the day?</label><br>
			<input id="time_outoffbed" type="time" class="time" value="" placeholder="HH:MM AM/PM">
		</p>
		<p  class="row alt"><label for="sel_sleepquality">How would you rate the quality of your sleep?</label><br>
			<select id="sel_sleepquality">
				<option>--</option>
				<option>Very Poor</option>
				<option>Poor</option>
				<option>Fair</option>
				<option>Good</option>
				<option>Very Good</option>
			</select>
		</p>
		<p class="row"><label for="txt_comments">Comments (optional):</label><br>
			<textarea id="txt_comments" class="input-text"></textarea>
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
	<p><a href="admin.cfm">Admin</a> | <a href="javascript:void(0);">Edit Profile</a> | <a href="javascript:void(0);" onClick="document.forms['frmLogout'].submit();">Logout #getAuthUser()#</a></p>
	<p>&copy;2014 The Chang School</p>
</footer>
<form name="frmLogout" action="" method="post">
	<input type="hidden" name="logout" value="1">
</form>
</cfoutput>
</body>
</html>