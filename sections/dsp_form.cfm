    <form id="parseErrorLogForm" name="parseErrorLogForm" action="<cfoutput>#request.self#</cfoutput>" method="post">
        <table align="center">
            <tr>
                <td colspan="2" align="center">
                    <h1>Ecometry Log Viewer</h1>
                </td>
            <!--- <tr>
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
            </tr> --->
            <tr>
                <td>
                <label>Please Select Transaction Type:</label>
                </td>
                <td>
                <select name="transactionFilter">
                    <option value="">Select Transaction</option>
                    <option value="<cfoutput>#transactionList#</cfoutput>">ALL</option>
                    <cfloop list="#transactionList#" index="thisValue" >
                        <cfoutput><option value="#thisValue#" <cfif thisValue EQ attributes.transactionFilter>selected</cfif>>#thisValue#</option></cfoutput>
                    </cfloop>
                </select>
                </td>
            </tr>
            <tr>
                <td>
                    <label>Start output at row ###:</label>
                </td>
                <td>
                    <input type="number" name="startFrom" <cfif structKeyExists(attributes,'startFrom') AND attributes.startFrom GT 0>value="<cfoutput>#attributes.startFrom#</cfoutput>"</cfif> />
                </td>
            </tr>
            <tr>
                <td>
                    <label>Kill output after ### rows:</label>
                </td>
                <td>
                    <input type="number" name="killCount" <cfif structKeyExists(attributes,'killCount') AND attributes.killCount GT 0>value="<cfoutput>#attributes.killCount#</cfoutput>"</cfif> />
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                <input type="submit" value="Refresh Results">
                </td>
            </tr>
        </table>
    </form>

