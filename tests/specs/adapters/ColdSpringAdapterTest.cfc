<cfcomponent extends="coldbox.system.testing.BaseTestCase">
<cfscript>
	this.loadcoldbox = false;

	function setup(){
		super.setup();
		adapter = getMockBox().createMock("cbioc.models.adapters.ColdSpringAdapter");
	}

	function creationTest(){
		adapter.init(definitionFile=expandPath('/tests/resources/coldspring.xml.cfm'));
		adapter.createFactory();

		assertEquals( false, adapter.containsBean('funkyObject') );
		assertEquals( true, adapter.containsBean('testService') );

		assertEquals( true, isObject(adapter.getBean('testService')) );

		parent = getMockBox().createMock("cbioc.models.adapters.ColdSpringAdapter");
		parent.init(definitionFile=expandPath('/tests/resources/coldspring.xml.cfm'));
		parent.createFactory();
		adapter.setParentFactory( parent.getFactory() );
		assertEquals( parent.getFactory(), adapter.getParentFactory() );
	}
</cfscript>
</cfcomponent>