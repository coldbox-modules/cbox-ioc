/**
* My BDD Test
*/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		// all your suites go here.
		describe( "IOC Module", function(){

			beforeEach(function( currentSpec ){
				setup();
			});

			it( "should register factory", function(){
				var factory = getFactory();
				expect(	factory ).toBeComponent();
			});

			it( "should retrieve via custom DSL", function(){
				var factory = getFactory();
				factory.setframework( "coldspring" );
				factory.setDefinitionFile( "/test/resources/coldspring.xml.cfm" );
				factory.configure();
				var service = getWireBox().getInstance( dsl="ioc:testService" );
				expect( isObject( service ) ).toBeTrue();
			});
		});
	}

	private function getFactory(){
		return getWireBox().getInstance( "factory@ioc" );
	}

}