
<cfset request.FullIMPath = "C:\Program Files\ImageMagick-6.8.7-Q16\convert.exe" /> <!---Might change due to environment --->

<cfset request.formatOptions =  ArrayNew(1) />
<cfset formatOptions[1] = "-unsharp 0x6+0.5+0" />
<cfset formatOptions[2] = "-unsharp 0x0.75+0.75+0.008" />
<cfset formatOptions[3] = "-unsharp 1.5x1+0.7+0.02" />
<cfset formatOptions[4] = "-unsharp 2.166666667x1.471960145+0.5+0.05" />
<cfset unsharpSetting = 4 />

<cfset convertOptions = ArrayNew(1) />
<cfset convertOptions[1] = "-define jpeg:size=" />
<cfset convertOptions[2] = "-auto-orient" />
<cfset convertOptions[3] = "-thumbnail" />
<cfset convertOptions[4] = "-interlace Plane" />
<cfset convertOptions[5] = "-quality 70" />

<cfset request.originalImageFullPath = '/' & '[filename_zoom]' />
<cfset request.finalImageFullPath = '/' & '[filename_detail]' />

<cfset request.thisHeight = '642' />
<cfset request.thisWidth = '350' />

<cfdump var="""#request.originalImageFullPath#"" #convertOptions[1]#2.5*#request.thisWidth#x2.5*#request.thisHeight# #convertOptions[2]# #convertOptions[3]# #request.thisWidth#x#request.thisHeight# #convertOptions[4]# #convertOptions[5]# #formatOptions[unsharpSetting]# ""#request.finalImageFullPath#""" ><cfabort>

<cfif fileExists(request.FullIMPath)>
    <cfexecute
        name="#request.FullIMPath#"
        arguments="""#request.originalImageFullPath#"" #convertOptions[1]#2.5*#request.thisWidth#x2.5*#request.thisHeight# #convertOptions[2]# #convertOptions[3]# #request.thisWidth#x#request.thisHeight# #convertOptions[4]# #convertOptions[5]# #formatOptions[unsharpSetting]# ""#request.finalImageFullPath#"""
    />
</cfif>
