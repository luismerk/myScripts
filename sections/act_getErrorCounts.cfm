<cfquery name="request.errors.dbCount" dbtype="query"><!--- Get database error counts --->
    SELECT
        COUNT(0)
    FROM errBitErrors
    WHERE message LIKE '%SQL%'
</cfquery>

<cfquery name="request.errors.cfCount" dbtype="query"><!--- Get coldfusion error counts --->
    SELECT
        COUNT(0)
    FROM errBitErrors
    WHERE message NOT LIKE '%SQL%' AND  message NOT LIKE '%parsed%'
</cfquery>

<cfquery name="request.errors.modelCount" dbtype="query"><!--- Get model error counts --->
    SELECT
        COUNT(0)
    FROM errBitErrors
    WHERE location LIKE '%_model%'
</cfquery>

<cfquery name="request.errors.viewCount" dbtype="query"><!--- Get view error counts --->
    SELECT
        COUNT(0)
    FROM errBitErrors
    WHERE location LIKE '%_view%'
</cfquery>

<cfquery name="request.errors.parsedCount" dbtype="query"><!--- Get parsed file error counts --->
    SELECT
        COUNT(0)
    FROM errBitErrors
    WHERE location LIKE '%parsed%'
</cfquery>

