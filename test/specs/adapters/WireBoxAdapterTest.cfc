<cfcomponent extends="coldbox.system.testing.BaseTestCase">
<cfscript>
	this.loadcoldbox = false;

	function setup(){
		adapter = getMockBox().createMock("cbioc.model.adapters.WireBoxAdapter");
	}

	function creationTest(){
		adapter.init(definitionFile="test.resources.WireBox");
		adapter.createFactory();

		//assertEquals( false, adapter.containsBean('funkyObject') );
		assertEquals( true, adapter.containsBean('testService') );

		assertEquals( true, isObject(adapter.getBean('testService')) );

		parent = getMockBox().createMock("cbioc.model.adapters.WireBoxAdapter");
		parent.init(definitionFile="test.resources.WireBox");
		parent.createFactory();
		adapter.setParentFactory( parent.getFactory() );
		assertEquals( parent.getFactory(), adapter.getParentFactory() );
	}

</cfscript>
</cfcomponent>