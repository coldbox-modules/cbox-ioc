// Skipping as CS2 never went Final
component extends="coldbox.system.testing.BaseTestCase" skip="true"{
	this.loadcoldbox = false;

	function setup(){
		super.setup();
		adapter = getMockBox().createMock("cbioc.models.adapters.ColdSpring2Adapter");
	}

	function creationTest(){
		adapter.init(definitionFile=expandPath('/tests/resources/coldspring.xml.cfm'));
		adapter.createFactory();

		assertEquals( false, adapter.containsBean('funkyObject') );
		assertEquals( true, adapter.containsBean('testService') );

		assertEquals( true, isObject(adapter.getBean('testService')) );

		parent = getMockBox().createMock("cbioc.models.adapters.ColdSpring2Adapter");
		parent.init(definitionFile=expandPath('/tests/resources/coldspring.xml.cfm'));
		parent.createFactory();
		adapter.setParentFactory( parent.getFactory() );
		assertEquals( parent.getFactory(), adapter.getParentFactory() );
	}
}