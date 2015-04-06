
<cftry>
	<cfset userid = decrypt(cookie.sleepjournal.user, application.key)>
	<cfcatch type="any">
		<cfset userid = 0>
	</cfcatch>
</cftry>

<cfif isDefined("url.d") and userid gt 0>

	<cftry>
		<cfset userid = decrypt(cookie.sleepjournal.user, application.key)>
		<cfcatch type="any">
			<cfset userid = 0>
		</cfcatch>
	</cftry>
	
	<cfset current = url.d>
	<cfset first = dateFormat(createDate(year(current), month(current), 1), "mm/dd/yyyy")>
	<cfset last = dateFormat(createDate(year(current), month(current), daysInMonth(current)), "mm/dd/yyyy")>
	
	<cfquery name="q"  datasource="sleepjournal">
		SELECT * FROM user_entries
		WHERE user_id = <cfqueryparam value="#userid#" cfsqltype="cf_sql_integer">
			AND entry_date BETWEEN <cfqueryparam value="#first#" cfsqltype="cf_sql_datetime">
				AND <cfqueryparam value="#last#" cfsqltype="cf_sql_datetime">
	</cfquery>
	
	
	<cfset arr = arrayNew(1)>
	<cfset temp = arraySet(arr,1,q.recordCount,0)>
	<cfset temp = queryAddColumn(q,"tib","Integer",arr)>
	
	<cfset arr = arrayNew(1)>
	<cfset temp = arraySet(arr,1,q.recordCount,0)>
	<cfset temp = queryAddColumn(q,"tst","Integer",arr)>
	
	<cfset arr = arrayNew(1)>
	<cfset temp = arraySet(arr,1,q.recordCount,0)>
	<cfset temp = queryAddColumn(q,"se","Decimal",arr)>
	
	<cfloop query="q">
		<cfset n = currentRow>
		<cfset timeInBed = dateDiff("n", in_bed, out_of_bed)>
		<cfset totalSleepTime = dateDiff("n", q.try_to_sleep, q.final_awakening) - q.minutes_to_sleep>
		<cfset temp = querySetCell(q, "tib", timeInBed, n)>
		<cfset temp = querySetCell(q, "tst", totalSleepTime, n)>
		<cfset temp = querySetCell(q, "se", totalSleepTime/timeInBed, n)>
	</cfloop>
	
	<cfsavecontent variable="strExcelData">
			
		<style type="text/css">
			table { font-Family: Arial, sans-serif; font-size: 12px; }
		</style>
		
		<cfif q.recordCount gt 0>
			<table>
				<thead>
					<tr>
						<th>Date</th>
						<th>In bed</th>
						<th>Lights out</th>
						<th>Time before asleep</th>
						<th>Number of awakenings</th>
						<th>Total time awake</th>
						<th>Final awakening</th>
						<th>Out of bed</th>
						<th>Sleep Quality</th>
						<th>Comments</th>
						<th>TIB</th>
						<th>TST</th>
						<th>SE</th>
					</tr>
				</thead>
				<tbody>
				<cfoutput>
					<cfloop query="q">
					<tr>
						<td>#entry_date#</td>
						<td>#in_bed#</td>
						<td>#try_to_sleep#</td>
						<td>#minutes_to_sleep#</td>
						<td>#number_of_wakeups#</td>
						<td>#minutes_awake#</td>
						<td>#final_awakening#</td>
						<td>#out_of_bed#</td>
						<td>#sleep_quality#</td>
						<td>#comments#</td>
						<td>#tib#</td>
						<td>#tst#</td>
						<td>#se#</td>
					</tr>
					</cfloop>
					<tr>
						<td colspan="13" style="color: red;">To format date/time data: (1) Select a corresponding column (2) Go to Format > Cells... (3) Enter custom format "mm/dd/yyyy h:mm AM/PM" and hit OK button.</td>
					</tr>
				</cfoutput>
				</tbody>
			</table>
		</cfif>
		
	</cfsavecontent>

	<cfheader name="Content-Disposition" value="attachement;filename=sleep_data_#dateFormat(url.d,"mmm_yyyy")#.xls"/>
	<cfcontent type="application/msexcel" variable="#ToBinary( ToBase64( strExcelData.Trim() ) )#"/>
	<cflocation addtoken="no" url="index.cfm">
	
<cfelse>
	<h1>Error</h1>
	<p>Could not generate a report.</p>
</cfif>