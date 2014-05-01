<cfscript>
	function getBean( required beanName ){
		return getInstance( "factory@ioc" ).getBean( arguments.beanName );
	}
</cfscript>