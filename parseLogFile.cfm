
<cfset filePath = "#ExpandPath("logFiles")#" />
<cfset fileName = "ecometryAdapterLog" />
<cfset fullFileName = fileName & ".log" />

<cfset FIELDS = 'Severity,ThreadID,Date,Time,Application,Message' />
<cfset DELIMITER = ',"' />

<cfset transactionList = 'wo01,tt0009,tt0021,tt0091,tt0093,tt0095' />

<cfparam name="attributes" default="#form#" />
<!--- <cfparam name="attributes.transactionFilter" default="#transactionList#" /> --->
<cfparam name="attributes.transactionFilter" default="" />

<cfif !directoryExists("#filepath#")>
    <cfset directoryCreate("#filepath#")>
</cfif>

<cfset archivepath = "#ExpandPath("logFiles\archive\")#" />

<cfif !directoryExists("#archivepath#")>
    <cfset directoryCreate("#archivepath#")>
</cfif>

<cfset request.self = 'http://' & cgi.server_name & cgi.script_name />
<cfset row = 0 />
<cfset count = 0 />


<form id="parseErrorLogForm" name="parseErrorLogForm" action="<cfoutput>#request.self#</cfoutput>" method="post">

    <table align="center">
        <tr>
            <td colspan="2" align="center">
                <h1>Ecometry Log Viewer</h1>
            </td>
        <tr>
            <td>
            <label>Date to Start Search:</label>
            </td>
            <td>
            <input type="date" name="startDateTime" />
            </td>
        </tr>
        <tr>
            <td>
            <label>Date to End Search:</label>
            </td>
            <td>
            <input type="date" name="endDateTime" />
            </td>
        </tr>
        <tr>
            <td>
            <label>Please Select Transaction Type:</label>
            </td>
            <td>
            <select name="transactionFilter">
                <option value="">Select Transaction</option>
                <cfloop list="#transactionList#" index="thisValue" >
                    <cfoutput><option value="#thisValue#" <cfif thisValue EQ attributes.transactionFilter>selected</cfif>>#thisValue#</option></cfoutput>
                </cfloop>
            </select>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
            <input type="submit" value="Refresh Results">
            </td>
        </tr>
    </table>
</form>

<cfif len(trim(attributes.transactionFilter))>
    <cfloop file="#filePath#/#fullFileName#" index="line" charset="utf-8">

        <cfif row GTE 3 >
            <cfset importData = structNew() />
            <cfset lineArr = listToArray(line, DELIMITER, true, true) />

            <cfloop list="#FIELDS#" index="field">
                <cfset fieldIndex = listFind(FIELDS, field) />

                <cfif arrayLen(lineArr) GTE fieldIndex>
                    <cfset importData[field] = lineArr[fieldIndex] />
                <cfelse>
                    <cfset importData[field] = '' />
                </cfif>
            </cfloop>

            <cfset request.messageLogArray = ListToArray(importData.message,'|') />

            <cfset request.messageLogged = Replace(ListFirst(importData.message,'|'),'"','') />
            <cfset request.transactionNumber = right(request.messageLogged,2) />

            <cfif NOT listFindNoCase('tt0007',request.messageLogged) AND listFindNoCase(attributes.transactionFilter, request.messageLogged)>

                <cfset count = count + 1 />
                <cfif request.messageLogged EQ 'wo01'>
                    <cfset callIndex = 3 />
                    <cfset request.responseLogged = 'wo' & repeatString("0", 2-len(request.transactionNumber + 1)) & (request.transactionNumber + 1)  />
                <cfelse>
                    <cfset callIndex = 2 />
                    <cfset request.responseLogged = 'tt' & repeatString("0", 4-len(request.transactionNumber + 1)) & (request.transactionNumber + 1)  />
                </cfif>
                <cfset responseIndex = callIndex + 1 />
                Row:<cfdump var="#row#">, Count:<cfdump var="#count#, ">

                <cfset request.ecometryAPICall = Replace(request.messageLogArray[callIndex],'""','"','all') />

                <cfset request.ecometryResponse = Replace(Replace(Replace(Replace(Replace(request.messageLogArray[responseIndex],'""','"','all'),'<?xml version="1.0"?>',''),'> "','>'),'>"','>'),'<!-- ORDER RECAP --> ','') />

                <cfif NOT isXML(request.ecometryResponse)>
                    <cfset request.ecometryResponse = Replace(Replace(Replace(Replace(Replace(request.ecometryResponse,'["<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n','','all'),']"',''),'\r\n\t','','all'),'\t','','all'),'\','','all') />
                </cfif>

                <cfset request.cleanAPICall =  xmlParse(request.ecometryAPICall)/>
                <cfset request.cleanResponse =  xmlParse(request.ecometryResponse)/>

                <cfset request.dataBeingSent =  xmlParse(request.ecometryResponse)/>

                <cfset request.logApplicationSource = Replace(importData.application, """", "", "ALL") />
                <!--- Format the date data properly --->
                <cfset request.logEntryDateTime = Replace(importData.date & ' ' & importData.time, """", "", "ALL") />

                Date:<cfdump var="#request.logEntryDateTime#"><br>
                <!--- Links to the request/response XML dumps --->
                <cfdump var="#request.messageLogged#:">
                <cfdump var="#request.cleanAPICall#" expand="false">
                <cfdump var="#request.responseLogged#:">
                <cfdump var="#request.cleanResponse#" expand="false">

            </cfif>

        </cfif>

        <cfset row = row + 1 />
        <cfflush/>

    </cfloop>

    <cfoutput>
        Successfully Parsed #row# Error Log Lines.
    </cfoutput>

<cfelse>
    No results to show. Please make selections above.
</cfif>

