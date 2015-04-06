<cfcomponent>
	
	<cffunction name="getMonthData" access="remote" returntype="query">
		<cfargument name="today" type="date" required="yes">
		<cfargument name="current" type="date" required="yes">
		
		<cftry>
			<cfset userid = decrypt(cookie.sleepjournal.user, application.key)>
			<cfcatch type="any">
				<cfset userid = 0>
			</cfcatch>
		</cftry>
		
		<cfset first = dateFormat(createDate(year(current), month(current), 1), "mm/dd/yyyy")>
		<cfset last = dateFormat(createDate(year(current), month(current), daysInMonth(current)), "mm/dd/yyyy")>
		
		<cfquery name="qUserEntries"  datasource="sleepjournal">
			SELECT * FROM user_entries
			WHERE user_id = <cfqueryparam value="#userid#" cfsqltype="cf_sql_integer">
				AND entry_date BETWEEN <cfqueryparam value="#first#" cfsqltype="cf_sql_datetime">
					AND <cfqueryparam value="#last#" cfsqltype="cf_sql_datetime">
		</cfquery>
		
		<cfset q = queryNew("date, tib, tst, average", "date, integer, integer, decimal")>
		<cfset rows = QueryAddRow(q, daysInMonth(current))>
		
		<cfloop from="#createDate(year(current), month(current), 1)#" to="#createDate(year(current), month(current), daysInMonth(current))#" index="d">
			<cfset n = day(d)>
			<cfset temp = querySetCell(q, "date", d, n)>
			
			<cfquery dbtype="query" name="qEntry">
				SELECT * FROM qUserEntries 
				WHERE entry_date = <cfqueryparam value="#dateFormat(d, "mm/dd/yyyy")#" cfsqltype="cf_sql_datetime">
			</cfquery>
			
			<cfif qEntry.recordCount gt 0>
				<cfset tib = dateDiff("n", qEntry.in_bed, qEntry.out_of_bed)>
				<cfset tst = dateDiff("n", qEntry.try_to_sleep, qEntry.final_awakening) - qEntry.minutes_to_sleep>
				<cfset temp = querySetCell(q, "tib", tib, n)>
				<cfset temp = querySetCell(q, "tst", tst, n)>
			</cfif>
			
			<cfset avg = arrayAvg(listToArray(valueList(q.tst)))>
			<cfset avg = avg eq 0 ? "" : avg >
			<cfset temp = querySetCell(q, "average", avg, n)>
		</cfloop>
		
		<cfreturn q>
	</cffunction>
	
</cfcomponent>