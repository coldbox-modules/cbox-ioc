component {

	// Module Properties
	this.title 				= "ioc";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "This module integrates third-party DI/IOC engines into ColdBox like ColdSpring and DI/1";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "ioc";
	// Model Namespace
	this.modelNamespace		= "ioc";
	// CF Mapping
	this.cfmapping			= "cbioc";

	function configure(){

		// Mixin our own methods on handlers, interceptors and views via the ColdBox UDF Library File setting
		arrayAppend( controller.getSetting( "UDFLibraryFile" ), "#moduleMapping#/model/mixins.cfm" );

		// IOC integration module
		/**
		Here are the available settings.
			framework 		= "coldspring",
			autoreload 	  	= true,
			definitionFile  = "config/coldspring.xml.cfm",
			parentFactory = {
				framework = "coldspring", definitionFile = "config/parent.xml.cfm"
			}
		**/
		settings = {
			framework = "",
			autoreload = false,
			definitionFile = "",
			parentFactory = {
				// framework = "", definitionFile = ""
			}
		};

		// Register Custom DSL, don't map it because it is too late, mapping DSLs are only good by the parent app
		controller.getWireBox().registerDSL( namespace="ioc", path="#moduleMapping#.model.IOCDSL" );

		// Bind the factory with arguments
		binder.map( "factory@ioc" )
			.to( "cbioc.model.Factory" )
			.initArg( name="settings", value=settings )
			.initArg( name="coldbox", dsl="coldbox" );
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		if( len( settings.framework ) ){
			wirebox.getInstance( "factory@ioc" ).configure();
		}
	}

	/**
	* onRequestCapture interceptor
	*/
	function onRequestCapture( event, interceptData ){
		if( settings.autoReload and len( settings.framework ) ){
			wirebox.getInstance( "factory@ioc" ).configure();
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}