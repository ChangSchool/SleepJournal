<!doctype html>
<html>
<head>
<title>Sleep Journal: Reset Password</title>
<cfinclude template="_/head.inc">
<script>
function validateResetForm() {
	var errors = 0, $form;
	$form = $("#frmSignup");
			
	errors += validateField("password", "password", {min:6, max:15, strong:false});
	errors += validateField('confirm','compare', {field:'password', label:'Password'});
		
	if (errors) {
		$(".invalid:eq(0) input").focus();
		//$(".alert").text("The information you've entered is either incomplete, or contains errors. Please verify your input and try again.").show();
		return false;
	} else {
		return true;
	}
}
</script>
</head>

<cfif isDefined("form.id")>
	<!--- set new password --->
	<cfquery name="qUpdatePassword" datasource="sleepjournal">
		UPDATE users
		SET password = <cfqueryparam value="#hash(form.password)#" cfsqltype="cf_sql_varchar">
		WHERE username = (SELECT username 
						FROM password_requests
						WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_varchar">)
	</cfquery>
	<!--- update request --->
	<cfquery name="qUpdateRequest" datasource="sleepjournal">
		UPDATE password_requests
		SET was_reset = 1
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
		<cfelseif qRequest.was_reset eq 1>
			<cfset errorString = "The password has been already reset.">
		<cfelse>
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
		<p class="alert" role="alert" aria-atomic="true"<cfif errorString gt ""> style="display: block;"</cfif>>#errorString#</p>
		<cfif validRequest is true>
			<p>Enter your new password.</p>
			<p class="required"><label for="password">Password:</label><br>
				<input type="password" name="password" id="password" value="" class="input-text"
				onBlur="validateField('password','password', {min:6,  max:15, strong:false});"></p>
			<p class="required"><label for="confirm">Confirm Password:</label><br>
				<input type="password" name="confirm" id="confirm" value="" class="input-text"
				onBlur="validateField('confirm','compare', {field:'password', label:'Password'});"></p>
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