<!doctype html>
<html>
<head>
<title>Sleep Journal: Data Entry</title>
<cfinclude template="_/head.inc">
</head>

<body>
<cfoutput>
<header>
	<h1><img src="_/img/sleepjournal@2x.png" width="32" height="32" alt=""> Sleep Journal</h1>
</header>
<article class="box content">
		<form name="frmAdmin" action="" method="post">
		<h2>Admin</h2>
		<p>Under construction...</p>
		<p><input type="button" name="btnCancel" value="Close" onClick="location.href='index.cfm';"></p>
</article>
<footer>
	<p><a href="javascript:void(0);">Admin</a> | <a href="javascript:void(0);">Edit Profile</a> | <a href="javascript:void(0);" onClick="document.forms['frmLogout'].submit();">Logout #getAuthUser()#</a></p>
	<p>&copy;2014 The Chang School</p>
</footer>
<form name="frmLogout" action="" method="post">
	<input type="hidden" name="logout" value="1">
</form>
</cfoutput>
</body>
</html>