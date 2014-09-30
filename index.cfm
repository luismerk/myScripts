<html>

<head>
    <style type="text/css">
        li {
            display: inline;
        }
    </style>
    <title>MERKS DEV TOOLS</title>
</head>


<cfset projectList = "bhldn,eataly,terrain,uniquephoto,mightyleaf,misook,morganlewis,drsinatra" />

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
            <form id="" name="createNewMigration" action="http://local.#thisSite#.weblinc.com/?dbMigrate=create" method="post">
                    <!---li>
                        <button type="submit" >Create Migration</button>
                        <input type="text" name="migrationName" />
                    </li--->
                </ul>
            </form>
        </cfloop>
    </cfoutput>

</body>

</html>