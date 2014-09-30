<cfsetting requestTimeout="10000" />

<cfset request.startTime = getTickCount() />

<!--- <cfsilent>
    <cfset request.isBot = 0 />
    <cfapplication
        name="myScripts_parseLogError"
        sessionmanagement="yes"
        sessiontimeout="#createTimeSpan(0, 0, 30, 0)#"
        applicationtimeout="#CreateTimeSpan(1,0,0,0)#"
        clientmanagement="no"
    />
</cfsilent> --->

<html>

    <head>
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <!--script language="JavaScript" type="text/javascript" src="/js/jquery-1.10.2.min.js"></script-->
        <style type="text/css">
            .toggle-details {
                display:none;
            }
        </style>

        <script type="text/javascript">//<![CDATA[
            $(document).ready(function(){
                $("body").on('click', '.toggle-title',function (e) {
                    $(this).next(".toggle-details").toggle("fast");
                    e.preventDefault();
                    console.log('hi');
                });
            });//]]>

        </script>

    </head>

    <cfset filePath = "#ExpandPath("logFiles")#" />
    <cfset fileName = "ecometryAdapterLog" />
    <cfset fullFileName = fileName & ".log.4" />

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

<body>

    <cfinclude template="/sections/dsp_form.cfm">


    <cfif len(trim(attributes.transactionFilter))>
        <cfloop file="#filePath#/#fullFileName#" index="line" charset="utf-8">

            <cfif row GTE 2 AND (structKeyExists(attributes,'startFrom') AND (attributes.startFrom GTE 0 AND row GT attributes.startFrom)) >
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

                <cfif (NOT listFindNoCase('tt0007',request.messageLogged) AND listFindNoCase(attributes.transactionFilter, request.messageLogged)) OR transactionList EQ attributes.transactionFilter>

                    <cfset count = count + 1 />
                    <cfif request.messageLogged EQ 'wo01'>
                        <cfset callIndex = 3 />
                        <cfset request.responseLogged = 'wo' & repeatString("0", 2-len(request.transactionNumber + 1)) & (request.transactionNumber + 1)  />
                    <cfelse>
                        <cfset callIndex = 3 />
                        <cfset request.responseLogged = 'tt' & repeatString("0", 4-len(request.transactionNumber + 1)) & (request.transactionNumber + 1)  />
                    </cfif>
                    <cfset responseIndex = callIndex + 1 />
                    Row:<cfdump var="#row#">, Count:<cfdump var="#count#, ">
                    <!--- Parse call/response properly --->
                    <cfset request.ecometryAPICall = Replace(request.messageLogArray[callIndex],'""','"','all') />
                    <cfset request.ecometryResponse = parseResponse(request.messageLogArray[responseIndex]) />
                    <!--- <cfif row EQ 379>
                        <cfdump var="#request.ecometryResponse#"><br>
                        <cfdump var="#FindNoCase('Connection Timeout', request.ecometryResponse)#"><br>
                        <cfdump var="#request.messageLogArray#"><cfabort>
                    </cfif> --->
                    <cfset request.cleanAPICall =  xmlParse(request.ecometryAPICall)/>
                    <cfif FindNoCase('Connection', request.ecometryResponse)>
                        <cfset request.cleanResponse =  (request.ecometryResponse)/>
                    <cfelse>
                        <cfset request.cleanResponse =  xmlParse(request.ecometryResponse)/>
                    </cfif>
                    <cfset request.logApplicationSource = Replace(importData.application, """", "", "ALL") />

                    <!--- Any data related to the current transaction should be grabbed here for summary. --->
                    <!--- Format the date data properly --->
                    <cfset request.logEntryDateTime = Replace(importData.date & ' ' & importData.time, """", "", "ALL") />

                    Date:<cfdump var="#request.logEntryDateTime#"><br>
                    <!--- Links to the request/response XML dumps --->

                    <cfif request.messageLogged EQ 'wo01'>
                        <cfset request.sentTransData = XmlSearch(request.cleanAPICall, '/#request.messageLogged#/sg_data_to_macs') />
                        Payment Type: <cfdump var="#request.sentTransData[1].r20.r20_cc_type.xmlText#" ><br>
                        <cfif request.sentTransData[1].r20.r20_cc_type.xmlText EQ 'PY'>
                            <cfif structKeyExists(request.sentTransData[1].r15,'R15_PURCHASE_ORD')>
                                PURCHASE_ORDER: <cfdump var="#request.sentTransData[1].r15.R15_PURCHASE_ORD.xmlText#" ><br>
                            </cfif>
                            PY_ORDERTRANSID: <cfdump var="#request.sentTransData[1].r20.r20_py_order_transid.xmlText#" ><br>
                            PY_AUTHTRANSID: <cfdump var="#request.sentTransData[1].r20.r20_py_auth_transid.xmlText#" ><br>
                        </cfif>
                    </cfif>

                    <cfoutput>#request.messageLogged#: </cfoutput>
                    <button class="toggle-title">See XML text</button>
                    <div class="toggle-details">
                        <cfdump var="#request.ecometryAPICall#">
                        <cfoutput>#request.messageLogArray[callIndex]#"</cfoutput>
                    </div>
                    <button class="toggle-title">See XML Structure</button>
                    <div class="toggle-details">
                        <cfdump var="#request.cleanAPICall#" expand="true">
                    </div>

                    <cfoutput>#request.responseLogged#: </cfoutput>
                    <button class="toggle-title">See XML text</button>
                    <div class="toggle-details">
                        <cfdump var="#request.ecometryResponse#">
                    </div>
                    <button class="toggle-title">See XML Structure</button>
                    <div class="toggle-details">
                        <cfdump var="#request.cleanResponse#" expand="true">
                    </div>
                    <br><br>

                </cfif>

            </cfif>

            <cfset row = row + 1 />

            <cfflush interval=10 >

            <cfif structKeyExists(attributes,'killCount') AND attributes.killCount GT 1 AND row EQ attributes.killCount>
                <cfbreak>
            </cfif>

        </cfloop>

        <cfoutput>
            Successfully Parsed #row-attributes.startFrom# Error Log Lines.
        </cfoutput>

    <cfelse>
        No results to show. Please make selections above.
    </cfif>

    <cfset request.endTime = getTickCount()/>
    <cfset request.elapsed = request.endTime - request.startTime />
<br>
hours = <cfoutput>#int((request.elapsed) / (3600*1000))#</cfoutput><br>
minutes = <cfoutput>#int(((request.elapsed) / 1000) / 60)#</cfoutput><br>
seconds = <cfoutput>#((request.elapsed) / 1000) - int(((request.elapsed) / 1000) / 60)*60#</cfoutput><br>
Time Elapsed: <cfoutput>#(request.elapsed)/1000# sec</cfoutput><br>


</body>

</html>

<cffunction name="parseResponse" returntype="Any" >
    <cfargument name="responseText" type="string" required="true" />

    <cfset request.ecometryResponse = Replace(Replace(Replace(Replace(Replace(responseText,'""','"','all'),'<?xml version="1.0"?>',''),'> "','>'),'>"','>'),'<!-- ORDER RECAP --> ','') />
    <cfif NOT isXML(request.ecometryResponse)>
        <cfset request.ecometryResponse = Replace(Replace(Replace(Replace(Replace(request.ecometryResponse,'["<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n','','all'),']"',''),'\r\n\t','','all'),'\t','','all'),'\','','all') />
    </cfif>

    <cfreturn request.ecometryResponse >
</cffunction>