<!doctype html>
<html>
<head>
<title>Sleep Journal: Reset Password</title>
<script>
function validateResetForm() {
	var f, el, e, err = "";
	f = document.forms["frmReset"];
	el = f.elements;
	if (el["password"].value.length < 2) err += "Password is required.\n"; 
	if (el["password"].value != el["confirm"].value) err += "Password and Confirm Password fields must match.";
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
	<!--- update request --->
	<cfquery name="qUpdateRequest" datasource="sleepjournal">
		UPDATE password_requests
		SET password_reset = 1
		WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset success = true>
</cfif>

<cfif isDefined("url.id")>
	<cfquery name="qRequest" datasource="sleepjournal">
		SELECT * 
		FROM password_requests
		WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif qRequest.recordCount gt 0>
		<cfif createODBCDateTime(qRequest.expires) lt now()>
			<cfset errorString = "The link has expired.">
		<cfelseif qRequest.password_reset neq 1>
			<cfset validRequest = "yes">
		</cfif>
	<cfelse>
		<cfset errorString = "The request ID is not valid.">
	</cfif>
<cfelseif not isDefined("form.id")>
	<cfset errorString = "The link is not valid.">
</cfif>

<cfparam name="url.id" default="">
<cfparam name="errorString" default="">
<cfparam name="validRequest" default="no">
<cfparam name="success" default="no">

<body>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article>
	<cfoutput>
	<form name="frmReset" action="#cgi.PATH_INFO#" method="post" class="login box" onSubmit="return validateResetForm();">
		<input type="hidden" name="id" value="#url.id#">
		<h2>Reset Password</h2>
		<cfif errorString gt ""><p class="alert">#errorString#</p></cfif>
		<cfif validRequest is true>
			<p>Enter your new password.</p>
			<p><label for="password">New Password:</label><br>
				<input type="password" name="password" id="password" value="" class="input-text" autocomplete="off"></p>
			<p><label for="confirm">Confirm New Password:</label><br>
				<input type="password" name="confirm" id="confirm" value="" class="input-text" autocomplete="off"></p>
			<p><input type="submit" name="btnSubmit" value="Save">
				<input type="button" name="btnCancel" value="Cancel" onClick="location.href='index.cfm';"></p>
		<cfelse>
			<cfif success is true><p>Your password has been successfully reset.</p></cfif>
			<p><input type="button" name="btnCancel" value="Close" onClick="location.href='index.cfm';"></p>
		</cfif>
	</form>
	</cfoutput>
</article>
<footer>
	&copy;2014 The Chang School
</footer>
</body>
</html>