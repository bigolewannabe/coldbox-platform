<cfsetting enablecfoutputonly=true>
<!---
	Name         : ranks.cfm
	Author       : Raymond Camden 
	Created      : August 28, 2005
	Last Updated : 
	History      : 
	Purpose		 : 
--->

<cfoutput>
<!--- Messagebox --->
#getPlugin("messagebox").renderit()#
</cfoutput>
<cfmodule template="../../tags/datatable.cfm" 
		  data="#requestContext.getValue("ranks")#" list="name,minposts" 
		  editlink="?event=#requestContext.getValue("xehRanksEdits")#" linkcol="name" label="Rank" />


<cfsetting enablecfoutputonly=false>