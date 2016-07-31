<!DOCTYPE html>
<cfparam name="form.dbMigrate" default="" />
<cfparam name="form.reparse" default="" />
<cfparam name="form.siteName" default="" />
<cfparam name="form.migrationName" default="" />

<cfset projectList = "bhldn,terrain,uniquephoto,thesak,mavi,sstack" />
<cfset hasStagingList = "bhldn,terrain,uniquephoto,mavi" />
<cfset count = 0 />

<cfset PAGE_TITLE = "COLDFUSION DEV TOOLS" />
<cfset PAGE_HEADER = "CF Dashboard" />
<cfset RESOURCES_DIR = "resources/less/dist/" />

<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <!-- Bootstrap -->
        <link href="<cfoutput>#RESOURCES_DIR#</cfoutput>css/bootstrap.min.css" rel="stylesheet">

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->

        <title><cfoutput>#PAGE_TITLE#</cfoutput></title>
    </head>

    <body>
        <div class="container">

            <div class="row">
                <h1>
                <div class="col-xs-5">
                    <cfoutput>#PAGE_HEADER#</cfoutput>
                </div>
                <div class="col-xs-1">
                    <a href="/">
                    <button type="button" class="btn btn-default btn-lg">
                        <span class="glyphicon glyphicon-repeat" aria-hidden="true"></span> Reset
                    </button>
                </a>
                </div>
                </h1>
            </div>
            <br>
            <!--- PROCESS FORM SUBMISSION --->
            <cfif listFindNoCase(projectList,form.siteName) AND form.dbMigrate EQ 'create' AND len(trim(form.migrationName))>
                <cfset requestURL = "http://local.#form.siteName#.weblinc.com/?dbMigrate=create&migrationName=" & form.migrationName />
                <cfhttp url="#requestURL#" method="get" result="response" ></cfhttp>

                <cfsavecontent variable="request.msg">
                    <cfif response.responseheader.status_code EQ 200 >
                        <h4>You have created a migration for <cfoutput>#form.siteName#</cfoutput>.</h4>
                        <cfoutput>Success message: #trim(response.fileContent)#_up.sql<br/><a href="file:///#Replace(trim(response.fileContent),'creating ','')#_up.sql">Go there</a></cfoutput>
                        <cfset request.msgType = 'success' />
                    <cfelse>
                        <h4>Something went wrong while creating a migration for <cfoutput>#form.siteName#</cfoutput>.</h4>
                        <cfoutput>Error message: #response.statusCode#</cfoutput>
                        <cfset request.msgType = 'danger' />
                    </cfif>
                </cfsavecontent>
            </cfif>

            <cfif listFindNoCase(projectList,form.siteName) AND form.reparse EQ true AND len(trim(form.fuseactionToParse))>
                <cfset requestURL = "http://local.#form.siteName#.weblinc.com/?fusebox.password=d33r1kt&fusebox.load=true&fusebox.parse=true&fusebox.execute=false&fuseaction=" & form.fuseactionToParse />
                <cfhttp url="#requestURL#" method="get" result="response" ></cfhttp>

                <cfsavecontent variable="request.msg">
                    <cfif response.responseheader.status_code EQ 200 >
                        <h4>You have successfully reparsed the '<cfoutput>#form.fuseactionToParse#</cfoutput>' fuseaction for <cfoutput>#form.siteName#</cfoutput>.</h4>
                        <cfoutput>Success message: #response.statusCode#</cfoutput>
                        <cfset request.msgType = 'success' />
                    <cfelse>
                        <h4>Something went wrong while reparsing the '<cfoutput>#form.fuseactionToParse#</cfoutput>' fuseaction for <cfoutput>#form.siteName#</cfoutput>.</h4>
                        <cfoutput>Error message: #response.statusCode#</cfoutput>
                        <cfset request.msgType = 'danger' />
                    </cfif>
                </cfsavecontent>
            </cfif>
            <!--- //PROCESS FORM SUBMISSION --->

            <!-- ERROR MODULE -->
            <cfif structKeyExists(request, "msg") AND len(trim(request.msg))>
                <cfoutput>
                    <div class="alert alert-#request.msgType#" role="alert">
                        #request.msg#
                    </div>
                </cfoutput>
            </cfif>
            <!-- //ERROR MODULE -->

            <h2>Current Projects</h2>
            <cfoutput>

                <ul class="nav nav-pills" role="tablist">
                    <cfloop list="#projectList#" index="thisSite" >
                        <li role="presentation" <cfif thisSite EQ 'bhldn'>class="active"</cfif>><a href="###thisSite#" aria-controls="home" role="tab" data-toggle="tab">#thisSite#</a></li>
                    </cfloop>
                </ul>

                <div class="tab-content">
                    <cfloop list="#projectList#" index="thisSite" >
                        <div role="tabpanel" class="tab-pane<cfif thisSite EQ 'bhldn'> active</cfif>" id="#thisSite#">

                        <h3>#UCase(thisSite)#</h3>
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-default" onclick="window.open('http://local.#thisSite#.weblinc.com/')">Go there</button>
                            <button type="button" class="btn btn-default" onclick="window.open('http://local.#thisSite#.weblinc.com/admin')">ADMIN</button>
                            <cfif NOT thisSite EQ 'morganlewis'>
                                <button type="button" class="btn btn-default" onclick="window.open('http://local.#thisSite#.weblinc.com/?dbMigrate=1')">DB Migrate</button>
                            </cfif>
                            <button type="button" class="btn btn-default" onclick="window.open('http://local.#thisSite#.weblinc.com/?resetApplication=1')">Reset Application</button>
                            <button type="button" class="btn btn-default" onclick="window.open('http://local.#thisSite#.weblinc.com/?resetAssetPackages=1')">Reset Asset Packages</button>
                        </div>
                        <br/><br/>
                            
                        <div class="row">
                            <form id="createNewMigration_#count#" name="createNewMigration_#count#" action="" method="post" >
                                <input type="hidden" name="siteName" value="#thisSite#" />
                                <input type="hidden" name="dbMigrate" value="create" />

                                <div class="col-lg-5">
                                <div class="input-group">
                                  <input type="text" class="form-control" name="migrationName" value="<cfif structKeyExists(form,'migrationName') AND len(trim(form.migrationName))>#form.migrationName#</cfif>" required="required" placeholder="Enter Migration Name">
                                  <span class="input-group-btn">
                                    <input class="btn btn-default" type="submit" name="createMigration"     value="Create Migration" />
                                  </span>
                                </div><!-- /input-group -->
                                </div>
                            </form>
                        </div>
                        <br/>
                        <div class="row">
                            <form id="reparseFuseaction_#count#" name="reparseFuseaction_#count#" action="" method="post" >
                                <input type="hidden" name="siteName" value="#thisSite#" />
                                <input type="hidden" name="reparse" value="true" />

                                <div class="col-lg-5">
                                <div class="input-group">
                                  <input type="text" class="form-control" name="fuseactionToParse" value="<cfif structKeyExists(form,'fuseactionToParse') AND len(trim(form.fuseactionToParse))>#form.fuseactionToParse#</cfif>" required="required" placeholder="Enter circuit.fuseaction">
                                  <span class="input-group-btn">
                                    <input class="button btn btn-default" type="submit" name="reparseFuseaction" value="Reparse Fuseaction" />
                                  </span>
                                </div><!-- /input-group -->
                                </div>
                            </form>
                        </div>
                        <br/>
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-default" onclick="window.open('http://dev.#thisSite#.weblinc.com/')">DEV site</button>
                            <button type="button" class="btn btn-default" onclick="window.open('http://dev.#thisSite#.weblinc.com/admin')">DEV admin</button>
                            <cfif listFindNoCase(hasStagingList,thisSite)>
                                <button type="button" class="btn btn-default" onclick="window.open('http://staging.#thisSite#.com')">STAGING site</button>
                                <button type="button" class="btn btn-default" onclick="window.open('http://staging.#thisSite#.com/admin')">STAGING admin</button>
                            </cfif>
                            <button type="button" class="btn btn-default" onclick="window.open('http://www.#IIF(thisSite EQ 'terrain',DE('shopterrain'),DE(thisSite))#.com/admin')">LIVE admin</button>
                        </div>

                        <cfset count++ />
                    </div>
                </cfloop>

            </cfoutput>
        </div>

        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="<cfoutput>#RESOURCES_DIR#</cfoutput>js/bootstrap.min.js"></script>
    </body>
</html>