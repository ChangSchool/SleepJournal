<!doctype html>
<html>
<head>
<title>Sleep Journal: Reset Password</title>
<cfinclude template="_/head.inc">
<script>
function validateResetForm() {
	var f, el, e, err = "";
	f = document.forms["frmReset"];
	el = f.elements;
	if (el["oldpassword"].value.length < 2) err += "Old password is required.\n"; 
	if (el["password"].value.length < 2) err += "New password is required.\n"; 
	if (el["password"].value != el["confirm"].value) err += "New Password and Confirm Password fields must match.";
	if (err.length == 0) { return true; } else { alert(err); return false; }
}
</script>
</head>

<cfif isDefined("form.id")>
	<!--- set new password --->
	<cfquery name="qUpdatePassword" datasource="sleepjournal">
		UPDATE users
		SET password = <cfqueryparam value="#hash(form.password)#" cfsqltype="cf_sql_varchar">
		WHERE username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset success = true>
</cfif>

<cfparam name="errorString" default="">
<cfparam name="success" default="no">

<body>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article>
	<cfoutput>
	<form name="frmReset" action="#cgi.PATH_INFO#" method="post" class="login box" onSubmit="return validateResetForm();">
		<h2>Change Password</h2>
		<cfif errorString gt ""><p class="alert">#errorString#</p></cfif>
		<cfif success is true>
			<p>Your password has been successfully reset.</p>
			<p><input type="button" name="btnCancel" value="Close" onClick="location.href='profile.cfm';"></p>
		<cfelse>
			<p><label for="password">Old Password:</label><br>
				<input type="password" name="oldpassword" id="oldpassword" value="" class="input-text" autocomplete="off"></p>
			<p><label for="password">New Password:</label><br>
				<input type="password" name="password" id="password" value="" class="input-text" autocomplete="off"></p>
			<p><label for="confirm">Confirm New Password:</label><br>
				<input type="password" name="confirm" id="confirm" value="" class="input-text" autocomplete="off"></p>
			<p><input type="submit" name="btnSubmit" value="Save">
				<input type="button" name="btnCancel" value="Cancel" onClick="location.href='profile.cfm';"></p>
		</cfif>
	</form>
	</cfoutput>
</article>
<footer>
	&copy;2014 The Chang School
</footer>
</body>
</html>