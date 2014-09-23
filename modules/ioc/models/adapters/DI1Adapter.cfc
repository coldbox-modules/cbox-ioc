<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author 	    :	Sean Corfield
Date        :	May 28, 2014
Description :
	This is a concrete DI/1 Adapter

----------------------------------------------------------------------->
<cfcomponent hint="The ColdBox DI/1 IOC factory adapter"
			 extends="cbioc.models.AbstractIOCAdapter" 
			 output="false">

<!----------------------------------------- CONSTRUCTOR ------------------------------------->			
	
	<!--- Constructor --->
	<cffunction name="init" access="public" returntype="DI1Adapter" hint="Constructor" output="false" >
		<cfargument name="definitionFile" 	type="string" 	required="false" default="" hint="The list of file paths to search for beans"/>
		<cfargument name="properties" 		type="struct" 	required="false" default="#structNew()#" hint="Properties to pass to the factory to create"/>
		<cfargument name="coldbox" 			type="any" 		required="false" default="" hint="A coldbox application that this instance of logbox can be linked to, not used if not using within a ColdBox Application."/>
		<cfscript>
			super.init(argumentCollection=arguments);
			
			// DI/1 Factory Path
			instance.DI1_FACTORY_PATH = "framework.ioc";
			
			return this;
		</cfscript>
	</cffunction>

<!----------------------------------------- PUBLIC ------------------------------------->	

	<!--- createFactory --->
	<cffunction name="createFactory" access="public" returntype="void" hint="Create the DI/1 Factory" output="false" >
		<cfscript>
			var properties = getProperties();
			
			//Create the DI/1 Factory
			instance.factory = createObject("component", instance.DI1_FACTORY_PATH ).init( getDefinitionFile(), properties );

		</cfscript>
	</cffunction>

	<!--- getBean --->
	<cffunction name="getBean" access="public" output="false" returntype="any" hint="Get a Bean from the object factory">
		<cfargument name="beanName" type="string" required="true" hint="The bean name to retrieve from the object factory">
		<cfscript>
			return getFactory().getBean(arguments.beanName);
		</cfscript>
	</cffunction>
	
	<!--- containsBean --->
	<cffunction name="containsBean" access="public" returntype="boolean" hint="Check if the bean factory contains a bean" output="false" >
		<cfargument name="beanName" type="string" required="true" hint="The bean name to retrieve from the object factory">	
		<cfscript>
			return getFactory().containsBean(arguments.beanName);
		</cfscript>
	</cffunction>
	
	<!--- setParentFactory --->
    <cffunction name="setParentFactory" output="false" access="public" returntype="void" hint="Set a parent factory on the adapted factory">
    	<cfargument name="parent" type="any" required="true" hint="The parent factory to add"/>
  		<cfset getFactory().setParent( arguments.parent )>
    </cffunction>
	
	<!--- getParentFactory --->
    <cffunction name="getParentFactory" output="false" access="public" returntype="any" hint="Get the parent factory">
    	<cfthrow message="DI/1 does not support this operation (getParentFactory)">
    </cffunction>

<!----------------------------------------- PRIVATE ------------------------------------->	
	
</cfcomponent>
