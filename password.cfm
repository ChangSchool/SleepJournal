<!doctype html>
<html>
<head>
<title>Sleep Journal: Request Password Reset</title>
<cfinclude template="_/head.inc">
<script>
function validateResetForm() {
	var f, el, e, err = "";
	f = document.forms["frmReset"];
	el = f.elements;
	if (el["username"].value.length < 2) err += "Username is required.\n"; 
	if (err.length == 0) { return true; } else { alert(err); return false; }
}
</script>
</head>

<cfif isDefined("form.username")>
	<cfquery name="qUser" datasource="sleepjournal">
		SELECT * 
		FROM users
		WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif qUser.recordCount eq 0>
		<cfset errorString="The username was not recognized by the system. Please check your spelling.">
	<cfelse>
		<!--- check for active requests --->
		<cfquery name="q" datasource="sleepjournal">
			SELECT * 
			FROM password_requests
			WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
				AND expires > <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
				AND password_reset = 0
		</cfquery>
		<cfif q.recordCount gt 0>
			<cfset errorString="An email has already been sent to this user. Please check your mailbox.">
		<cfelse>
			<cfset key = hash(GetTickCount())>
			<cfquery name="qRequest" datasource="sleepjournal">
				INSERT INTO password_requests (
					id,
					username)
				VALUES (
					<cfqueryparam value="#key#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">)
			</cfquery>
			<cfmail to="#qUser.email#" from="dehelp@ryerson.ca" subject="Sleep Journal Password Reset" type="html">
				<p>Dear #qUser.first_name# #qUser.last_name#,</p>
				<p>To reset your Sleep Journal password, simply click the link below. That will take you to a web page where you can create a new password.</p>
				<p>Please note that the link will expire three hours after this email was sent.</p>
				<p><a href="https://webapps.de.ryerson.ca/sleepjournal/password_reset.cfm?id=#key#" target="_blank">Reset Sleep Journal password</a></p>
			</cfmail>
		</cfif>
	</cfif>
</cfif>

<cfparam name="form.username" default="">
<cfparam name="key" default="">
<cfparam name="errorString" default="">

<body>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article>
	<cfoutput>
	<form name="frmReset" action="" method="post" class="login box" onSubmit="return validateResetForm();">
		<h2>Reset Password</h2>
		<cfif errorString gt ""><p class="alert">#errorString#</p></cfif>
		<cfif key gt "">
			<p>A link to reset your password has been sent to your email address.</p>
			<p><input type="button" name="btnCancel" value="Close" onClick="location.href='index.cfm';"></p>
		<cfelse>
			<p>Enter your username and we'll email you a link to reset your password.</p>
			<p><label for="username">Username:</label><br> 
				<input type="text" name="username" id="username" autocapitalize="off" autocorrect="off" value="#form.username#" class="input-text" autocomplete="off"></p>
			<p><input type="submit" name="btnSubmit" value="Continue"> 
				<input type="button" name="btnCancel" value="Cancel" onClick="location.href='index.cfm';"></p>
		</cfif>
	</form>
	</cfoutput>
</article>
<footer>
	&copy;2014 The Chang School
</footer>
</body>
</html>