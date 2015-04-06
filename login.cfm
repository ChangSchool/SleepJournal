<!doctype html>
<html>

<cfif isDefined("form.username")>
	<cfquery name="qUser" datasource="sleepjournal">
		SELECT * 
		FROM users
		WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
			AND password = <cfqueryparam value="#hash(form.password)#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif qUser.recordCount eq 0>
		<cfset errorString="Either username or password were not recognized by the system. Please try again.">
	<cfelse>
		<cflogin>
			<cfloginuser name="#qUser.username#" password="#qUser.password#" roles="qUser.roles">
		</cflogin>
		<cfset cookie.sleepjournal.user = encrypt(qUser.id, application.key)>
		<cfset theURL = getPageContext().getRequest().GetRequestUrl().toString()>
		<cfif len( CGI.query_string )><cfset theURL = theURL & "?" & CGI.query_string></cfif>
		<cflocation addtoken="no" url="#theURL#">
	</cfif>
</cfif>

<cfparam name="form.username" default="">
<cfparam name="errorString" default="">

<head>
<title>Sleep Journal: Login</title>
<cfinclude template="_/head.inc">
<script>
function validateLoginForm() {
	var errors = 0, $form;
	$form = $("#frmLogin");
	
	errors += validateField("username", "text", {min:2});
	errors += validateField("password", "password", {min:6, max:15, strong:false});
		
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

<body>
<cfoutput>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article>
	<form name="frmLogin" id="frmLogin" action="" method="post" class="login box" onSubmit="return validateLoginForm();">
		<h2>Member Login</h2>
		<p class="alert" role="alert" aria-atomic="true"<cfif errorString gt ""> style="display: block;"</cfif>>#errorString#</p>
		<p class="required"><label for="username">Username:</label><br> 
			<input type="text" name="username" id="username" autocapitalize="off" autocorrect="off" value="#form.username#" class="input-text"
			onBlur="validateField('username','text', {min:2, specialcharacters:false, spaces: false});"></p>
		<p class="required"><label for="password">Password:</label><br>
			<input type="password" name="password" id="password" value="" class="input-text"
			onBlur="validateField('password','password', {min:6,  max:15, strong:false});"></p>
		<p><input type="submit" name="btnSubmit" value="Log In"></p>
		<p>Not a member? <a href="signup.cfm">Sign up here</a>.</p>
		<p><a href="password.cfm">Forgot your password?</a></p>
	</form>
</article>
<footer>
	<p>&copy;2014 The Chang School</p>
</footer>
</body></cfoutput>

</html>