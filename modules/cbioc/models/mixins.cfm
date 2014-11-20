<cfscript>
	function getBean( required beanName ){
		return getInstance( "factory@cbioc" ).getBean( arguments.beanName );
	}
</cfscript>