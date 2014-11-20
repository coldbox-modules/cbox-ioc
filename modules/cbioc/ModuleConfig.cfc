component {

	// Module Properties
	this.title 				= "CBIOC";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "This module integrates third-party DI/IOC engines into ColdBox like ColdSpring and DI/1";
	this.version			= "1.0.0+@build.number@";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbioc";
	// Model Namespace
	this.modelNamespace		= "cbioc";
	// CF Mapping
	this.cfmapping			= "cbioc";

	function configure(){
		// Mixin our own methods on handlers, interceptors and views via the ColdBox UDF Library File setting
		arrayAppend( controller.getSetting( "ApplicationHelper" ), "#moduleMapping#/models/mixins.cfm" );
		// Register Custom DSL, don't map it because it is too late, mapping DSLs are only good by the parent app
		controller.getWireBox().registerDSL( namespace="ioc", path="#moduleMapping#.models.IOCDSL" );
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var configSettings = controller.getConfigSettings();
		//parse parent settings
		parseParentSettings();
		// Bind the factory with arguments
		binder.map( "factory@cbioc" )
			.to( "cbioc.models.Factory" )
			.initArg( name="settings", value=configSettings.ioc )
			.initArg( name="coldbox", dsl="coldbox" );
		// if configured, load the IOC library
		if( len( configSettings.ioc.framework ) ){
			wirebox.getInstance( "factory@cbioc" ).configure();
		}
	}

	/**
	* onRequestCapture interceptor
	*/
	function onRequestCapture( event, interceptData ){
		var configStruct = controller.getConfigSettings();

		if( configStruct.ioc.reload and len( configStruct.ioc.framework ) ){
			wirebox.getInstance( "factory@cbioc" ).configure();
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

	/**
	* Prepare settings and returns true if using i18n else false.
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var ioc 			= oConfig.getPropertyMixin( "ioc", "variables", structnew() );

		//defaults
		configStruct.ioc = {
			framework 		= "",
			reload 			= false,
			definitionFile 	= "",
			parentFactory = {
				framework 		= "",
				definitionFile = ""
			}

		};

		//Check for IOC Framework
		if ( structKeyExists( ioc, "framework" ) ){
			structAppend( configStruct.ioc, ioc, true );
		}

	}

}