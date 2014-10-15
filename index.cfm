<cfparam name="form.dbMigrate" default="" />
<cfparam name="form.siteName" default="" />
<cfparam name="form.migrationName" default="" />

<cfset projectList = "bhldn,eataly,terrain,uniquephoto,mightyleaf,misook,morganlewis,drsinatra" />
<cfset count = 0 />

<html>

<head>
    <style type="text/css">
        li {
            display: inline;
        }
    </style>
    <title>MERKS DEV TOOLS</title>
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

<body>

    <h1>Merk's Helpful Stuff</h1>

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
                        <form id="createNewMigration_#count#" name="createNewMigration_#count#" action="" method="post" >
                            <input type="hidden" name="siteName" value="#thisSite#" />
                            <input type="hidden" name="dbMigrate" value="create" />
                            <input type="text" name="migrationName" value="" required="required" />
                            <input class="button" type="submit" name="createMigration" value="Create Migration" />
                        </form>
                    </li>
                </ul>
                <cfset count++ />
        </cfloop>
    </cfoutput>

</body>

</html>
