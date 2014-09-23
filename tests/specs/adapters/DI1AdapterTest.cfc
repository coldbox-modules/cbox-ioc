<cfcomponent extends="coldbox.system.testing.BaseTestCase">
<cfscript>
	this.loadcoldbox = false;

	function setup(){
		super.setup();
		adapter = getMockBox().createMock("cbioc.model.adapters.DI1Adapter");
	}

	function creationTest(){
		adapter.init(definitionFile='/test/resources');
		adapter.createFactory();

		assertEquals( false, adapter.containsBean('funkyObject') );
		assertEquals( true, adapter.containsBean('testService') );

		assertEquals( true, isObject(adapter.getBean('testService')) );

		child = getMockBox().createMock("cbioc.model.adapters.DI1Adapter");
        // this will not include testService:
		child.init(definitionFile='/test/specs/adapters');
		child.createFactory();
		child.setParentFactory( adapter.getFactory() );
        // but we should be able to reach it via the parent:
		assertEquals( true, child.containsBean('testService') );
	}

    function configTest(){
        adapter.init(definitionFile='', {constants={knowledge=42}});
        adapter.createFactory();

        assertEquals( true, adapter.containsBean('knowledge') );
        assertEquals( false, isObject(adapter.getBean('knowledge')) );
        assertEquals( 42, adapter.getBean('knowledge') );
    }
</cfscript>
</cfcomponent>
