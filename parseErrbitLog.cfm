<cfset request.startTime = getTickCount() />

<cfset filePath = "#ExpandPath("logFiles")#" />
<cfset fileName = "errbitTableData" />
<cfset fullFileName = fileName & ".log" />


<style type="text/css">
    .errs table {
      width: 100%;
      border: 1px solid #000;
    }

    th, td {
      text-align: left;
      vertical-align: top;
      border: 1px solid #000;
      border-collapse: collapse;
      padding: 0.3em;
      caption-side: bottom;
    }

    th {
      background: #eee;
    }
</style>

<script type="text/javascript">
        function zoom() {
            document.body.style.zoom = "75%"
        }
</script>

<cffile action="read" file="#filePath#/#fullFileName#" variable="myxml" />

<cfset errorCountArray = xmlSearch(myxml, "//td[ @class = 'count' ]/a") /><!--- Error Count --->
<cfset lastInstanceArray = xmlSearch(myxml, "//td[ @class = 'latest' ]") /><!--- Last Instance --->
<cfset errorMessageArray = xmlSearch(myxml, "//td[ @class = 'message' ]/a") /><!--- Error Message --->
<cfset errorLocationArray = xmlSearch(myxml, "//td[ @class = 'message' ]/em") /><!--- Error location --->

<cfset errBitErrors = queryNew('Message,Location,LastInstance,Count', 'VarChar,VarChar,VarChar,Double' ) />

<cfloop from="1" to="#arrayLen(errorMessageArray)#" index="i" >
    <cfscript>
        QueryAddRow(errBitErrors);
        QuerySetCell(errBitErrors, 'Message' , Replace(xmlFormat(errorMessageArray[i].xmlText),'&##xe2;','','all'));
        QuerySetCell(errBitErrors, 'Location' , errorLocationArray[i].xmlText);
        QuerySetCell(errBitErrors, 'LastInstance' , lastInstanceArray[i].xmlText);
        QuerySetCell(errBitErrors, 'Count' , errorCountArray[i].xmlText);
    </cfscript>
</cfloop>

<cfset request.self = 'http://' & cgi.server_name & cgi.script_name />
<cfparam name="attributes" default="#form#" />
<cfparam name="attributes.errorType" default="#IIF(structKeyExists(url,'errorType'),Evaluate(DE("url.errorType")),DE(""))#" />
<cfparam name="attributes.sortBy" default="" />
<cfparam name="attributes.sortOrder" default="" />
<cfparam name="attributes.countLow" default="0" />
<cfparam name="attributes.countMax" default="0" />

<body onload="zoom()">
<form action="<cfoutput>#request.self#</cfoutput>" method="post" >
    Error Type:
    <select name="errorType" >
        <option value="database" <cfif attributes.errorType EQ 'database'>selected</cfif>>Database</option>
        <option value="coldfusion" <cfif attributes.errorType EQ 'coldfusion'>selected</cfif>>Coldfusion</option>
    </select>
    Sort By:
    <select name="sortBy" ><cfset sortByList = 'Count,Message,Location' />
        <cfloop list="#sortByList#" index="thisValue" >
            <cfoutput><option value="#thisValue#" <cfif thisValue EQ attributes.sortBy>selected</cfif>>#thisValue#</option></cfoutput>
        </cfloop>
    </select>
    <select name="sortOrder" >
        <option value="asc" <cfif attributes.sortOrder EQ 'asc'>selected</cfif>>Ascending</option>
        <option value="desc" <cfif attributes.sortOrder EQ 'desc'>selected</cfif>>Descending</option>
    </select>
    Count Min:
    <input name="countLow" type="number" value="<cfoutput>#attributes.countLow#</cfoutput>"/>
    Count Max:
    <input name="countMax" type="number" value="<cfoutput>#attributes.countMax#</cfoutput>"/>

    <input name="submit" type="submit" value="Submit" />
</form>

<cfquery name="dbErrors" dbtype="query">
    SELECT
        [count],
        location,
        message,
        lastinstance
    FROM errBitErrors
    <cfif len(trim(attributes.errorType))><!---Filter error type--->
        WHERE message <cfif attributes.errorType EQ 'coldfusion'>NOT </cfif>LIKE '%SQL%'
    </cfif>
    <cfif attributes.countLow GT 0><!--- Filter count --->
        AND [count] > #attributes.countLow#
    </cfif>
    <cfif attributes.countMax GT 0>
        AND [count] < #attributes.countMax#
    </cfif>
    <cfif len(trim(attributes.sortBy))>
    ORDER BY [#attributes.sortBy#] <cfif len(trim(attributes.sortOrder))>#attributes.sortOrder#</cfif>
    </cfif>
</cfquery>

<cfinclude template="sections/act_getErrorCounts.cfm" />

<!--- <cfdump var="#dbErrors#"> --->
<h1>Overall Summary</h1>
<cfoutput>
<table>
    <thead>
        <th>Type</th>
        <th>Total</th>
        <th>Parsed</th>
        <th>Model</th>
        <th>View</th>
    <tr>
        <td>ColdFusion</td>
        <td><a href="#request.self#/?errorType=coldfusion">#request.errors.cfCount.column_0#</a></td>
        <td>#request.errors.parsedCount.column_0#</td>
        <td>#request.errors.modelCount.column_0#</td>
        <td>#request.errors.viewCount.column_0#</td>
    </tr>
    <tr>
        <td>Database</td>
        <td><a href="#request.self#/?errorType=database">#request.errors.dbCount.column_0#</a></td>
        <td colspan="3">N/A</td>
    </tr>
</table>
</cfoutput>

<h1>Your search has resulted in <cfoutput>#dbErrors.recordCount#</cfoutput> errors.</h1>
<table class="errs">
    <thead>
        <th>Count</th>
        <th>Last Instance</th>
        <th>Location</th>
        <th>Message</th>
    </thead>
    <tbody>
<cfoutput query="dbErrors">
        <tr>
            <td>#count#</td>
            <td>#lastinstance#</td>
            <td>#location#</td>
            <td>#message#</td>
        </tr>
</cfoutput>
    </tbody>
</table>
</body>



<!--- <cfquery name="errBitErrors" dbtype="query">
    SELECT
        [count],
        message,
        location
    FROM errBitErrors
    WHERE [count] > <cfqueryparam cfsqltype="CF_SQL_DOUBLE" value="5"/>
    ORDER BY [count] DESC
</cfquery>
 --->
