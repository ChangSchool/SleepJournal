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
	if (err.length == 0) { return true; } else { alert(err); return false; }
}
</script>
</head>

<cfif isDefined("form.first")>
	<!--- update user --->
	<cfquery name="q" datasource="sleepjournal">
		UPDATE users 
		SET first_name = <cfqueryparam value="#form.first#" cfsqltype="cf_sql_varchar">,
			last_name = <cfqueryparam value="#form.last#" cfsqltype="cf_sql_varchar">,
			email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">
		WHERE username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cfif>

<cfquery name="qUser" datasource="sleepjournal">
	SELECT * 
	FROM users
	WHERE username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfparam name="errorString" default="">

<body>
<cfoutput>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article>
	<form name="frmSignup" action="" method="post" class="login box" onSubmit="return validateSignupForm();">
		<input type="hidden" name="signup" value="1">
		<h2>Edit Profile</h2>
		<cfif errorString gt ""><p class="alert">#errorString#</p></cfif>
		<p><label for="first">First Name:</label><br>
			<input type="text" name="first" id="first" value="#qUser.first_name#" class="input-text"></p>
		<p><label for="last">Last Name:</label><br>
			<input type="text" name="last" id="last" value="#qUser.last_name#" class="input-text"></p>
		<p><label for="email">Email:</label><br>
			<input type="text" name="email" id="email" autocapitalize="off" autocorrect="off" value="#qUser.email#" class="input-text"></p>
		<p><label for="birthday">Date of Birth (mm/dd/yyy):</label><br>
			<input type="date" name="birthday" id="birthday" value=""></p>
		<p><label for="gender">Gender:</label><br>
			<select name="gender" id="gender">
				<option value=""></option>
				<option value="m">Male</option>
				<option value="f">Female</option>
			</select></p>
		
		<p><a href="password_update.cfm">Click here to change password</a></p>
		<p><input type="submit" name="btnSubmit" value="Save"> 
			<input type="button" name="btnCancel" value="Close" onClick="location.href='index.cfm';"></p>
	</form>
</article>
<footer>
	<p>&copy;2014 The Chang School</p>
</footer>
</cfoutput>
</body>
</html>