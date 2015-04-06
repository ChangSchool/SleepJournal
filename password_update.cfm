<!doctype html>
<html>
<head>
<title>Sleep Journal: Reset Password</title>
<cfinclude template="_/head.inc">
<script>
function validateResetForm() {
	var errors = 0, $form;
	$form = $("#frmReset");
			
	errors += validateField("oldpassword", "password", {min:6, max:15, strong:false});
	errors += validateField("password", "password", {min:6, max:15, strong:false});
	errors += validateField('confirm','compare', {field:'password', label:'Password'});
		
	if (errors) {
		$(".invalid:eq(0) input").focus();
		//$(".alert").text("The information you've entered is either incomplete, or contains errors. Please verify your input and try again.").show();
		$(".alert").hide();
		return false;
	} else {
		return true;
	}
}
</script>
</head>

<cfif isDefined("form.oldpassword")>
	<!--- check old password --->
	<cfquery name="qPassword" datasource="sleepjournal">
		SELECT * FROM users
		WHERE username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar">
			AND password = <cfqueryparam value="#hash(form.oldpassword)#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif qPassword.recordCount gt 0>
		<!--- set new password --->
		<cfquery name="qUpdatePassword" datasource="sleepjournal">
			UPDATE users
			SET password = <cfqueryparam value="#hash(form.password)#" cfsqltype="cf_sql_varchar">
			WHERE username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset success = true>
	<cfelse>
		<cfset errorString = "The old password is incorrect.">
	</cfif>
</cfif>

<cfparam name="errorString" default="">
<cfparam name="success" default="no">

<body>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article>
	<cfoutput>
	<form name="frmReset" id="frmReset" action="#cgi.PATH_INFO#" method="post" class="login box" onSubmit="return validateResetForm();">
		<h2>Change Password</h2>
		<p class="alert" role="alert" aria-atomic="true"<cfif errorString gt ""> style="display: block;"</cfif>>#errorString#</p>
		<cfif success is true>
			<p>Your password has been successfully reset.</p>
			<p><input type="button" name="btnCancel" value="Close" onClick="location.href='profile.cfm';"></p>
		<cfelse>
			<p class="required"><label for="oldpassword">Old Password:</label><br>
				<input type="password" name="oldpassword" id="oldpassword" value="" class="input-text"
				onBlur="validateField('oldpassword','password', {min:6,  max:15, strong:false});"></p>
			<p class="required"><label for="password">Password:</label><br>
				<input type="password" name="password" id="password" value="" class="input-text"
				onBlur="validateField('password','password', {min:6,  max:15, strong:false});"></p>
			<p class="required"><label for="confirm">Confirm Password:</label><br>
				<input type="password" name="confirm" id="confirm" value="" class="input-text"
				onBlur="validateField('confirm','compare', {field:'password', label:'Password'});"></p>
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