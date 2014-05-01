<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author 	    :	Luis Majano
Date        :	August 21, 2006
Description :
	IoC Plugin, acts as a IoC Factory Adapter
----------------------------------------------------------------------->
<cfcomponent hint="An Inversion Of Control plugin that interfaces with major ColdFusion IoC/DI frameworks"
			 output="false"
			 accessors="true"
			 singleton>

	<!--- Properties --->
	<cfproperty name="adapter">
	<cfproperty name="framework">
	<cfproperty name="definitionFile">
	<cfproperty name="autoreload">
	<cfproperty name="parentFactory">

	<!--- DI --->
	<cfproperty name="log" inject="logbox:logger:{this}">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" access="public" returntype="Factory" output="false" hint="Constructor">
		<!--- ************************************************************* --->
		<cfargument name="settings" type="struct" required="true" hint="The configuration settings struct">
		<cfargument name="coldbox"	type="any"    required="true" hint="The ColdBox controller" inject="coldbox">
		<!--- ************************************************************* --->
		<cfscript>

			// The adapter used by this ioc plugin
			variables.adapter = "";

			// Setup settings
			variables.framework 		= arguments.settings.framework;
			variables.definitionFile 	= arguments.settings.definitionFile;
			variables.autoreload  		= arguments.settings.autoreload;
			variables.parentFactory 	= arguments.settings.parentFactory;
			variables.coldbox 			= arguments.coldbox;

			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- Configure the plugin --->
	<cffunction name="configure" access="public" returntype="void" hint="Configure or Re-Configure the IoC Plugin. Loads the chosen IoC Factory and configures it for usage" output="false">
		<cfscript>
			if( log.canInfo() ){
				log.info( "IOC integration detected, beginning configuration of IOC Factory" );
			}

			// build adapter using application chosen properties
			variables.adapter = buildAdapter( variables.framework, variables.definitionFile );

			// Do we have a parent to build?
			if( structCount( variables.parentFactory ) ){

				if( log.canDebug() ){
					log.debug( "Parent Factory detected: #variables.parentFactory.toString()# and loading...");
				}

				// Build parent adapter and set it on original adapter factory.
				var parentAdapter = buildAdapter( variables.parentFactory.framework, variables.parentFactory.definitionFile );
				variables.adapter.setParentFactory( parentAdapter.getFactory() );
			}
		</cfscript>
	</cffunction>

	<!--- reloadDefinitionFile --->
	<cffunction name="reloadDefinitionFile" access="public" output="false" returntype="void" hint="Reloads the IoC factory. Basically calls configure again. DEPRECATED">
		<cfscript>
			if( log.canInfo() ){
				log.info("Reloading ioc definition files...");
			}
			configure();
		</cfscript>
	</cffunction>

	<!--- Get a Bean --->
	<cffunction name="getBean" access="public" output="false" returntype="any" hint="Get a Bean from the loaded object factory">
		<cfargument name="beanName" required="true" hint="The bean name to retrieve from the object factory">
		<cfscript>
			// get object from adapter factory
			return variables.adapter.getBean( arguments.beanName );
		</cfscript>
	</cffunction>

	<!--- containsBean --->
	<cffunction name="containsBean" access="public" returntype="any" hint="Check if the bean factory contains a bean" output="false" colddoc:generic="boolean">
		<cfargument name="beanName" required="true" hint="The bean name to retrieve from the object factory">
		<cfreturn variables.adapter.containsBean( arguments.beanName )>
	</cffunction>

	<!--- get the IoC Factory in use --->
	<cffunction name="getIoCFactory" access="public" output="false" returntype="any" hint="Returns the IoC Factory in use">
		<cfreturn variables.adapter.getFactory()>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- buildAdapter --->
    <cffunction name="buildAdapter" output="false" access="private" returntype="any" hint="Build an IoC framework adapter and returns it">
    	<cfargument name="framework"		required="true" hint="The framework adapter to build"/>
		<cfargument name="definitionFile" 	required="true" hint="The framework definition file to load"/>
		<cfscript>
			var adapterPath = "";
			var thisAdapter = "";

			switch( arguments.framework ){
				case "coldspring" 	: { adapterPath = "cbioc.model.adapters.ColdSpringAdapter"; break; }
				case "coldspring2" 	: { adapterPath = "cbioc.model.adapters.ColdSpring2Adapter"; break; }
				case "wirebox" 		: { adapterPath = "cbioc.model.adapters.WireBoxAdapter"; break; }
				// Default as custom object class
				default				: { adapterPath = arguments.framework; break;}
			}

			// Create Adapter First
			try{
				thisAdapter = createObject( "component", adapterPath )
					.init( arguments.definitionFile, variables.coldbox.getConfigSettings(), variables.coldbox );

				if( log.canDebug() ){
					log.debug( "ioc factory adapter: #adapterPath# built successfully" );
				}
			}
			catch(Any e){
				log.error( "Error creating ioc factory adapter (#adapterPath#). Arguments: #arguments.toString()#, Message: #e.message# #e.detail# #e.stacktrace#");
				throw(message="Error Creating ioc factory adapter (#adapterPath#) : #e.message#",detail="#e.detail# #e.stacktrace#",type="IOC.AdapterCreationException");
			}

			// Create Adapter Factory it represents second
			try{
				thisAdapter.createFactory();

				if( log.canDebug() ){
					log.debug("ioc framework: #getMetadata( thisAdapter.getFactory() ).name# loaded successfully and ready for operation.");
				}
			}
			catch(Any e){
				log.error("Error creating ioc factory from adapter. Arguments: #arguments.toString()#, Message: #e.message# #e.detail# #e.stacktrace#");
				throw(message="Error Creating ioc factory: #e.message#",detail="#e.detail# #e.stacktrace#",type="IOC.AdapterFactoryCreationException");
			}

			if( log.canInfo() ){
				log.info("IoC factory: #arguments.framework#:#arguments.definitionFile# loaded and configured for operation");
			}

			return thisAdapter;
		</cfscript>
    </cffunction>

</cfcomponent>