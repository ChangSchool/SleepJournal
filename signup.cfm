<!doctype html>
<html>
<head>
<title>Sleep Journal: Registration</title>
<cfinclude template="_/head.inc">
<script>
function validateSignupForm() {
	var f, el, e, err = "", re = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
	f = document.forms["frmSignup"];
	el = f.elements;
	if (el["first"].value.length < 2) err += "First name is required.\n"; 
	if (el["last"].value.length < 2) err += "Last name is required.\n"; 
	if (!re.test(el["email"].value)) err += "Valid email address is required.\n"; 
	if (el["username"].value.length < 2) err += "Username is required.\n"; 
	if (el["password"].value.length < 2) err += "Password is required.\n"; 
	if (el["password"].value != el["confirm"].value) err += "Password and Confirm Password fields must match.";
	if (err.length == 0) { return true; } else { alert(err); return false; }
}
</script>
</head>

<cfif isDefined("form.first")>
	<!--- check if username exists --->
	<cfquery name="qUsername" datasource="sleepjournal">
		SELECT * 
		FROM users
		WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif qUsername.recordCount eq 0>
		<!--- create user --->
		<cfquery name="qReister" datasource="sleepjournal">
			INSERT INTO users (
				first_name,
				last_name,
				email,
				username,
				password)
			VALUES (
				<cfqueryparam value="#form.first#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#form.last#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#hash(form.password)#" cfsqltype="cf_sql_varchar">)
		</cfquery>
		<!--- login user and redirect to homepage --->
		<cflogin>
			<cfloginuser name="#form.username#" password="#form.password#" roles = "user">
		</cflogin>
		<cflocation addtoken="no" url="index.cfm">
	<cfelse>
		<cfset errorString = "Username """ & form.username & """ is already taken. Please try a different username.">
	</cfif>
</cfif>

<cfparam name="form.first" default="">
<cfparam name="form.last" default="">
<cfparam name="form.email" default="">
<cfparam name="errorString" default="">

<body>
<cfoutput>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article>
	<form name="frmSignup" action="" method="post" class="login box" onSubmit="return validateSignupForm();">
		<input type="hidden" name="signup" value="1">
		<h2>Registration</h2>
		<cfif errorString gt ""><p class="alert">#errorString#</p></cfif>
		<p><label for="first">First Name:</label><br>
			<input type="text" name="first" id="first" value="#form.first#" class="input-text"></p>
		<p><label for="last">Last Name:</label><br>
			<input type="text" name="last" id="last" value="#form.last#" class="input-text"></p>
		<p><label for="email">Email:</label><br>
			<input type="text" name="email" id="email" autocapitalize="off" autocorrect="off" value="#form.email#" class="input-text"></p>
		<p><label for="username">Username:</label><br> 
			<input type="text" name="username" id="username" autocapitalize="off" autocorrect="off" value="" class="input-text"></p>
		<p><label for="password">Password:</label><br>
			<input type="password" name="password" id="password" value="" class="input-text"></p>
		<p><label for="confirm">Confirm Password:</label><br>
			<input type="password" name="confirm" id="confirm" value="" class="input-text"></p>
		<p><input type="submit" name="btnSubmit" value="Sign Up"> 
			<input type="button" name="btnCancel" value="Cancel" onClick="location.href='index.cfm';"></p>
	</form>
</article>
<footer>
	<p>&copy;2014 The Chang School</p>
</footer>
</cfoutput>
</body>
</html>