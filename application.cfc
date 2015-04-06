<cfcomponent>

	<cfset this.name = "SleepJournal">
	<cfset this.scriptProtect = "all">
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = "#createTimespan(0,0,30,0)#">
	<cfset this.loginStorage = "session">
	<cfset this.applicationTimeout = "#createTimespan(5,0,0,0)#">
	
	<cffunction name="onApplicationStart">
		<cfset application.key = "297_Victoria">
		<cflog file="#this.name#" type="information" 
			text="Application #this.name# started">
	</cffunction>
	
	<cffunction name="onApplicationEnd">
		<cfargument name="applicationScope" required=true >
		<cflog file="#this.name#" type="information" 
			text="Application #applicationScope.applicationName# ended">
	</cffunction>
	
	<cffunction name="onRequestStart">
		<cfargument name="request" required="true">
		<cfif isDefined("form.logout")>
			<cfcookie name="sleepjournal.date" value="#now()#" expires="NOW">
			<cfcookie name="sleepjournal.user" value="#now()#" expires="NOW">
			<cflogout>
			<cflocation addtoken="no" url="index.cfm">
		</cfif>
		<cfset page = listLast(cgi.PATH_INFO,"/")>
		<cfif listFind("password.cfm,password.cfm,password_reset.cfm,signup.cfm", page, ",") eq 0>
			<cfif getAuthUser() eq "">
				<cfinclude template="login.cfm">
				<cfabort>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="onSessionStart">
		<cflog file="#this.name#" type="information" 
			text="Session: #session.sessionId# started">
	</cffunction>
	
	<cffunction name="onSessionEnd">
		<cfargument name = "sessionScope" required=true/>
		<cflog file="#this.Name#" type="information" 
			text="Session: #arguments.sessionScope.sessionid# ended">
	</cffunction>
	
</cfcomponent>
