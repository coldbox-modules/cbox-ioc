/********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
* The JavaLoader WireBox DSL
*/
component implements="coldbox.system.ioc.dsl.IDSLBuilder" accessors="true"{

	property name="injector";
	property name="log";

	/**
	* Constructor as per interface
	*/
	public any function init( required any injector ) output="false"{
		variables.injector 	= arguments.injector;
		variables.log		= arguments.injector.getLogBox().getLogger( this );

		return this;
	}

	/**
	* Process an incoming DSL definition and produce an object with it.
	*/
	public any function process( required definition, targetObject ) output="false"{
		var DSLNamespace = listFirst( arguments.definition.dsl, ":" );
		switch( DSLNamespace ){
			case "ioc" : { return getIOCDSL( argumentCollection=arguments );}
		}
	}

	/**
	* Get an IOC Dependency
	*/
	function getIOCDSL( required definition, targetObject ){
		var oIOC 			= variables.injector.getInstance( "factory@cbioc" );
		var thisTypeLen 	= listLen( arguments.definition.dsl, ":" );
		var beanName		= "";

		// DSL stages
		switch( thisTypeLen ){
			// ioc only, so get name from definition
			case 1: { beanName = arguments.definition.name; break;}
			// ioc:beanName, so get it from here
			case 2: { beanName = getToken( arguments.definition.dsl, 2, ":" ); break;}
		}

		// Check for Bean existence first
		if( oIOC.containsBean( beanName ) ){
			return oIOC.getBean( beanName );
		}
		else if( variables.log.canDebug() ){
			variables.log.debug("getIOCDSL() cannot find IOC Bean: #beanName# using definition: #arguments.definition.toString()#");
		}
	}

}