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
	<!--- update user --->
	<cfquery name="q" datasource="sleepjournal">
		UPDATE users 
		SET first_name = <cfqueryparam value="#form.first#" cfsqltype="cf_sql_varchar">,
			last_name = <cfqueryparam value="#form.last#" cfsqltype="cf_sql_varchar">,
			email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">,
			birthday = <cfqueryparam value="#form.birthday#" cfsqltype="cf_sql_date">,
			gender = <cfif form.gender gt "">
				<cfqueryparam value="#form.gender#" cfsqltype="cf_sql_char">
			<cfelse>NULL</cfif>
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
	<form name="frmSignup" id="frmSignup" action="" method="post" class="login box" onSubmit="return validateSignupForm();">
		<input type="hidden" name="signup" value="1">
		<h2>Edit Profile</h2>
		<p class="alert" role="alert" aria-atomic="true"<cfif errorString gt ""> style="display: block;"</cfif>>#errorString#</p>
		<p class="required"><label for="first">First Name:</label><br>
			<input type="text" name="first" id="first" value="#qUser.first_name#" class="input-text"  
			onBlur="validateField('first','text', {min:2, specialcharacters:false, spaces: false});"></p>
		<p class="required"><label for="last">Last Name:</label><br>
			<input type="text" name="last" id="last" value="#qUser.last_name#" class="input-text"
			onBlur="validateField('last','text', {min:2, specialcharacters:false, spaces: false});"></p>
		<p class="required"><label for="email">Email:</label><br>
			<input type="text" name="email" id="email" autocapitalize="off" autocorrect="off" 
			value="#qUser.email#" class="input-text" onBlur="validateField('email','email', null);"></p>
		<p><label for="birthday">Date of Birth:</label><br>
			<input type="text" name="birthday" id="birthday" placeholder="MM/DD/YYYY" 
				value="#dateFormat(qUser.birthday,"mm/dd/yyyy")#"></p>
		<p><label for="gender">Gender:</label><br>
			<span class="css-select"><select name="gender" id="gender">
				<option value=""></option>
				<option value="m" <cfif qUser.gender eq "m">selected</cfif>>Male</option>
				<option value="f" <cfif qUser.gender eq "f">selected</cfif>>Female</option>
			</select></span></p>
		
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