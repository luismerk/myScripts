<cfparam name="form.dbMigrate" default="" />
<cfparam name="form.siteName" default="" />
<cfparam name="form.migrationName" default="" />

<cfset projectList = "terrain,uniquephoto,sstack" />
<cfset count = 0 />

<cfset PAGE_TITLE = "COLDFUSION DEV TOOLS" />
<cfset PAGE_HEADER = "Coldfusion Sites - Helpful Stuff" />

<html>

<head>
    <style type="text/css">
        li {
            display: inline;
        }
    </style>
    <title><cfoutput>#PAGE_TITLE#</cfoutput></title>
</head>

<cfif listFindNoCase(projectList,form.siteName) AND form.dbMigrate EQ 'create' AND len(trim(form.migrationName))>
    <cfset requestURL = "http://local.#form.siteName#.weblinc.com/?dbMigrate=create&migrationName=" & form.migrationName />
    <cfhttp url="#requestURL#" method="get" result="response" ></cfhttp>
    <cfif response.responseheader.status_code EQ 200 >
        <h2>You have created a migration for <cfoutput>#form.siteName#</cfoutput>.</h2>
        <cfoutput>Success message: #response.fileContent#</cfoutput>
    <cfelse>
        <h2>Something went wrong while creating a migration for <cfoutput>#form.siteName#</cfoutput>.</h2>
        <cfoutput>Error message: #response.errorDetail#</cfoutput>
    </cfif>
</cfif>

<cfif listFindNoCase(projectList,form.siteName) AND form.reparse EQ true AND len(trim(form.fuseactionToParse))>
    <cfset requestURL = "http://local.#form.siteName#.weblinc.com/?fusebox.password=d33r1kt&fusebox.load=true&fusebox.parse=true&fusebox.execute=false&fuseaction=" & form.fuseactionToParse />
    <cfhttp url="#requestURL#" method="get" result="response" ></cfhttp>

    <cfif response.responseheader.status_code EQ 200 >
        <h2>You have successfully reparsed the '<cfoutput>#form.fuseactionToParse#</cfoutput>' fuseaction for <cfoutput>#form.siteName#</cfoutput>.</h2>
        <cfoutput>Success message: #response.statusCode#</cfoutput>
    <cfelse>
        <h2>Something went wrong while reparsing the '<cfoutput>#form.fuseactionToParse#</cfoutput>' fuseaction for <cfoutput>#form.siteName#</cfoutput>.</h2>
        <cfoutput>Error message: #response.errorDetail#</cfoutput>
    </cfif>
</cfif>

<body>

    <h1><cfoutput>#PAGE_HEADER#</cfoutput></h1>

    <h2>Current Projects</h2>

    <cfoutput>
        <cfloop list="#projectList#" index="thisSite" >
            <h3>#thisSite#</h3>
            <ul>
                <li><button onclick="window.open('http://local.#thisSite#.weblinc.com/')">Go there</button></li>
                <li><button onclick="window.open('http://local.#thisSite#.weblinc.com/admin')">ADMIN</button></li>
                <cfif NOT thisSite EQ 'morganlewis'>
                    <li><button onclick="window.open('http://local.#thisSite#.weblinc.com/?dbMigrate=1')">DB Migrate</button></li>
                </cfif>
                <li><button onclick="window.open('http://local.#thisSite#.weblinc.com/?resetApplication=1')">Reset Application</button></li>
                <li><button onclick="window.open('http://local.#thisSite#.weblinc.com/?resetAssetPackages=1')">Reset Asset Packages</button></li>
                <li>
                    <br/><br/>
                    <form id="createNewMigration_#count#" name="createNewMigration_#count#" action="" method="post" >
                        <input type="hidden" name="siteName" value="#thisSite#" />
                        <input type="hidden" name="dbMigrate" value="create" />
                        Enter Migration Name: <input type="text" name="migrationName" value="" required="required" />
                        <input class="button" type="submit" name="createMigration" value="Create Migration" />
                    </form>
                </li>
                <li>
                    <form id="reparseFuseaction_#count#" name="reparseFuseaction_#count#" action="" method="post" >
                        <input type="hidden" name="siteName" value="#thisSite#" />
                        <input type="hidden" name="reparse" value="true" />
                        Enter circuit.fuseaction: <input type="text" name="fuseactionToParse" value="" required="required" />
                        <input class="button" type="submit" name="reparseFuseaction" value="Reparse Fuseaction" />
                    </form>
                </li>
                <li><button onclick="window.open('http://dev.#thisSite#.weblinc.com/')">DEV site</button></li>
                <li><button onclick="window.open('http://dev.#thisSite#.weblinc.com/admin')">DEV admin</button></li>
                <li><button onclick="window.open('http://www.#IIF(thisSite EQ 'terrain',DE('shopterrain'),DE(thisSite))#.com/')">LIVE site</button></li>
                <li><button onclick="window.open('http://www.#IIF(thisSite EQ 'terrain',DE('shopterrain'),DE(thisSite))#.com/admin')">LIVE admin</button></li>
            </ul>
            <cfset count++ />
        </cfloop>
    </cfoutput>

</body>

</html>
