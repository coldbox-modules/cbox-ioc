/**
* My Event Handler Hint
*/
component{

	// Index
	any function index( event,rc, prc ){
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){
	}

	any function testMixins( event, rc, prc ){
		var factory = getInstance( "factory@cbioc" );
		factory.setframework( "coldspring" );
		factory.setDefinitionFile( "/#getSetting( "appMapping" )#/config/coldspring.xml.cfm" );
		factory.configure();

		return getBean( "TestService" ).sayHello();
	}

}