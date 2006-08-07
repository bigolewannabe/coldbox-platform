<!-----------------------------------------------------------------------Author: Oscar Arevalo (oarevalo@gmail.com) & Luis MajanoDate:   October/2005Description: This tool is used to display information about all components located withinthe same directory. The tools is based on the coldfusion.runtime.TemplateProxyjava object to obtain this information. The tool displays informationregarding comments, methods, return types, and arguments.Additionally, this tool scans each component for specially formatted TODO commentsto allow developers to keep track of pending tasks when developing their components.Modifications:07/29/2006 - Added output=false to missing methods.  Var scope checking. And hint addition.----------------------------------------------><cfcomponent displayname="cfcViewer" hint="This components provides functionality to obtain information about cfcs via introspection." extends="coldbox.system.plugin"><!------------------------------------------- CONSTRUCTOR ------------------------------------------->	<cfset this.dirpath = "">	<cfset this.cfcpath = "">	<cfset this.aCFC = ArrayNew(1)>	<cfset this.aPacks = ArrayNew(1)>	<cfset this.qryTODO = QueryNew("Name,Text")><!------------------------------------------- PUBLIC ------------------------------------------->	<!--- ************************************************************* --->	<cffunction name="init" access="public" returntype="any" output="false">		<cfargument name="controller" required="yes" hint="The reference to the framework controller">			<cfset super.Init(arguments.controller) />			<cfreturn this>	</cffunction>	<!--- ************************************************************* --->	<!--- ************************************************************* --->	<cffunction name="setup" access="public" output="false"				hint="This function takes care of component initialization.						The function takes a relative path as a parameter, and looks for all cfcs within						that path. Also, keeps track of all subdirectories and special TO DO notes						within each component. Use the get* methods to access this data.">		<!--- ************************************************************* --->		<cfargument name="dirpath" type="string" required="yes" hint="Directory path to inspect for cfc's, not expanded, relative path. This path will be expanded.">		<cfargument name="cfcpath" type="string" required="yes" hint="CFMapping path or full to cfc's. The path if you needed to instantiate the cfc.">		<!--- ************************************************************* --->		<cfset var qryCFC = "">		<cfset var i = 0>		<cfset var tmpName = "">		<cfset this.aCFC = ArrayNew(1)>		<cfset this.aPacks = ArrayNew(1)>		<cfset this.qryTODO = QueryNew("Name,Text")>		<cfset this.dirpath = arguments.dirpath>		<cfset this.cfcpath = arguments.cfcpath>		<!--- get the list of cfc files on that directory --->		<cfdirectory action="list" directory="#ExpandPath(this.dirpath)#" name="qryCFC" sort="name">		<cfset this.qryCFC = qryCFC>		<cfscript>			// put components into arrays			for(i=1;i lte qryCFC.RecordCount;i=i+1) {				if(Right(qryCFC.Name[i],4) eq ".cfc" and Left(qryCFC.Name[i],1) neq ".") {					tmpName = ListGetAt(qryCFC.Name[i],1,".");					ArrayAppend(this.aCFC, tmpName);				}				if(qryCFC.Type[i] eq "dir")					ArrayAppend(this.aPacks, qryCFC.Name[i]);			}			// add a slash at the end of the path (needed later)			if(Right(this.dirpath,1) neq "/") this.dirpath = this.dirpath & "/";		</cfscript>	</cffunction>	<!--- ************************************************************* --->	<!--- ************************************************************* --->	<cffunction name="getCFCs" access="public" returntype="array" output="false"				hint="returns an array with the names of all components within the current directory">		<cfreturn this.aCFC>	</cffunction>	<!--- ************************************************************* --->	<!--- ************************************************************* --->	<cffunction name="getPKGs" access="public" returntype="array" output="false"				hint="returns an array with the names of all subdirectories (or packages) in the current directory">		<cfreturn this.aPacks>	</cffunction>	<!--- ************************************************************* --->	<!--- ************************************************************* --->	<cffunction name="getCFCMetaData" access="public" returntype="any" output="false"				hint="returns a structure with information about the given component. This structure contains					information about returntype, methods, parameters, etc.">		<!--- ************************************************************* --->		<cfargument name="cfcName" type="string" required="yes">		<!--- ************************************************************* --->		<cfset var proxy = CreateObject("java", "coldfusion.runtime.TemplateProxy")>		<cfset var cfcPathDot = ListChangeDelims(this.cfcpath,".","/")>		<cfset var cfcloc = cfcPathDot & "." & Arguments.cfcName>		<cfset var md = "">		<cftry>			<cfset md = proxy.getMetaData(cfcloc, getPageContext())>			<cfcatch  type="any">				<cfthrow type="Framework.plugins.cfcViewer.GettingMetaDataException" message="#cfcatch.Message#" detail="#cfcatch.Detail#">			</cfcatch>		</cftry>		<cfreturn md>	</cffunction>	<!--- ************************************************************* ---></cfcomponent>