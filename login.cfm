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
		<cfset theURL = getPageContext().getRequest().GetRequestUrl().toString()>
		<cfif len( CGI.query_string )><cfset theURL = theURL & "?" & CGI.query_string></cfif>
		<cflocation addtoken="no" url="#theURL#">
	</cfif>
</cfif>

<cfparam name="errorString" default="">

<cfoutput>
<head>
<title>Sleep Journal: Login</title>
<cfinclude template="_/head.inc">
<script>
$(document).ready(function(e) {
	$('a:not([target])').click(function(){
		self.location = $(this).attr('href');
		return false;
	});
});

function validateLoginForm() {
	var f, el, e, err = "";
	f = document.forms["frmLogin"];
	el = f.elements;
	if (el["username"].value.length < 2) err += "Username is required.\n"; 
	if (el["password"].value.length < 2) err += "Password is required.\n";
	if (err.length == 0) { return true; } else { alert(err); return false; }
}
</script>
</head>

<body>

<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article>
	<form name="frmLogin" action="" method="post" class="login box" onSubmit="return validateLoginForm();">
		<h2>Member Login</h2>
		<cfif errorString gt ""><p class="alert">#errorString#</p></cfif>
		<p><label for="username">Username:</label><br> 
			<input type="text" name="username" id="username" autocapitalize="off" autocorrect="off" value="" class="input-text"></p>
		<p><label for="password">Password:</label><br>
			<input type="password" name="password" id="password" value="" class="input-text"></p>
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