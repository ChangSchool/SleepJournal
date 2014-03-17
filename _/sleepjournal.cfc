<cfcomponent>
	
	<cffunction name="getSampleData" access="remote" returntype="query">
		<cfargument name="today" type="date" required="yes">
		<cfargument name="current" type="date" required="yes">
		
		<cfset q = queryNew("date, tst, average", "date, decimal, decimal")>
		<cfset rows = QueryAddRow(q, daysInMonth(current))>
		
		<cfloop from="#createDate(year(current), month(current), 1)#" to="#createDate(year(current), month(current), daysInMonth(current))#" index="d">
			<cfset n = day(d)>
			<cfset temp = querySetCell(q, "date", d, n)>
			<cfif year(d) eq year(today) and month(d) eq month(today)>
				<cfif n gt 7 and n lt 16 and n neq 13>
					<cfset temp = querySetCell(q, "tst", 4 + numberFormat(4 * rand(), "9.9"), n)>
				<cfelseif n eq 25>
					<cfset temp = querySetCell(q, "tst", 2 + numberFormat(3 * rand(), "9.9"), n)>
				<cfelseif n gt 26 and n lt 30>
					<cfset temp = querySetCell(q, "tst", 5 + numberFormat(3 * rand(), "9.9"), n)>
				</cfif>
			</cfif>
			<cfset avg = arrayAvg(listToArray(valueList(q.tst)))>
			<cfset avg = avg eq 0 ? "" : avg >
			<cfset temp = querySetCell(q, "average", avg, n)>
		</cfloop>
		<cfreturn q>
	</cffunction>
	
</cfcomponent>