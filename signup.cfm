<!doctype html>
<html>
<head>
<title>Sleep Journal: Registration</title>
<cfinclude template="_/head.inc">
<script>
function validateSignupForm() {
	var errors = 0, $form;
	$form = $("#frmSignup");
			
	errors += validateField("first", "text", {min:2});
	errors += validateField("last", "text", {min:2});
	errors += validateField("email", "email", null);
	errors += validateField("username", "text", {min:2});
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

<cfif isDefined("form.first")>
	<!--- check if email exists --->
	<cfquery name="qUsername" datasource="sleepjournal">
		SELECT * 
		FROM users
		WHERE email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">
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
			<cfloginuser name="#form.email#" password="#form.password#" roles = "user">
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
	<form name="frmSignup" id="frmSignup" action="" method="post" class="login box" onSubmit="return validateSignupForm();">
		<input type="hidden" name="signup" value="1">
		<h2>Registration</h2>
		<p class="alert" role="alert" aria-atomic="true"<cfif errorString gt ""> style="display: block;"</cfif>>#errorString#</p>
		<p class="required"><label for="first">First Name:</label><br>
			<input type="text" name="first" id="first" value="#form.first#" class="input-text"  
			onBlur="validateField('first','text', {min:2, specialcharacters:false, spaces: false});"></p>
		<p class="required"><label for="last">Last Name:</label><br>
			<input type="text" name="last" id="last" value="#form.last#" class="input-text"
			onBlur="validateField('last','text', {min:2, specialcharacters:false, spaces: false});"></p>
		<p class="required"><label for="email">Email:</label><br>
			<input type="text" name="email" id="email" autocapitalize="off" autocorrect="off" 
			value="#form.email#" class="input-text" onBlur="validateField('email','email', null);"></p>
		<p class="required"><label for="username">Username:</label><br> 
			<input type="text" name="username" id="username" autocapitalize="off" autocorrect="off" value="" class="input-text"
			onBlur="validateField('username','text', {min:2, specialcharacters:false, spaces: false});"></p>
		<p class="required"><label for="password">Password:</label><br>
			<input type="password" name="password" id="password" value="" class="input-text"
			onBlur="validateField('password','password', {min:6,  max:15, strong:false});"></p>
		<p class="required"><label for="confirm">Confirm Password:</label><br>
			<input type="password" name="confirm" id="confirm" value="" class="input-text"
			onBlur="validateField('confirm','compare', {field:'password', label:'Password'});"></p>
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