#INSTRUCTIONS
Just drop into your **modules** folder or use the box-cli to install

`box install cbioc`

The module registers the following mapping in WireBox: `factory@cbioc`
Which abstracts any IoC engine with typical methods like `getBean(), containsBean()`

## Framework support
This module supports out of the box the following DI Engines:

- ColdSpring
- ColdSpring2
- DI/1
- WireBox

## Settings
You will configure the ioc integration via your `Coldbox.cfc` configuration file with an `ioc` structure.

```js
ioc = {
    // The registered name of the IoC engine to use or a class path to the IoC Adapter to use.
	framework 		= "",
    // Auto reload the configuration file and engine on each request
	reload 			= false,
    // The framework definition file
	definitionFile 	= "",
    // If the framework in use supports parent factories, you can register them here.
	parentFactory = {
		framework 		= "",
		definitionFile = ""
	}

};
```

## WireBox DSL: IOC
This module registers a WireBox DSL Namespace: `ioc`, so you can leverage autowiring via this namespace in your handlers:

```js
property name="myBean" inject="ioc:beanID";
```

## Mixins
This module also registers a new method: `getBean( beanName )` on all 
handlers, interceptors, views/layouts so you can easily retrieve objects from your favorite IoC engine.