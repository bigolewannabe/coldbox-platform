<!-----------------------------------------------------------------------
Author: Luis Majano
Date:   July 28, 2006
Description: This is the framework's simple bean factory.

Modifications:
07/29/2006 - Added more hints.
----------------------------------------------------------------------->
<cfcomponent name="beanFactory" hint="I am a simple bean factory and you can use me if you want." extends="coldbox.system.plugin">

	<!--- ************************************************************* --->
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="controller" required="yes" hint="The reference to the framework controller">
		<cfset super.Init(arguments.controller) />
		<cfreturn this>
	</cffunction>
	<!--- ************************************************************* --->

	<!--- ************************************************************* --->
	<cffunction name="create" hint="Create a named bean, simple as that. This method will append {Bean} to the path+name passed in." access="public" output="false" returntype="Any">
		<!--- ************************************************************* --->
		<cfargument name="bean" required="true" type="string" hint="The type of bean to create and return. Uses full cfc path mapping.Ex: coldbox.beans.exception">
		<!--- ************************************************************* --->
		<cftry>
			<cfreturn createObject("component","#arguments.bean#Bean")>
			<cfcatch type="any">
				<cfthrow type="Framework.plugins.beanFactory.BeanCreationException" message="Error creating bean: #arguments.bean#Bean" detail="#cfcatch.Detail#<br>#cfcatch.message#">
			</cfcatch>
		</cftry>
	</cffunction>
	<!--- ************************************************************* --->

</cfcomponent>