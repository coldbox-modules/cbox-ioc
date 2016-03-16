[![Build Status](https://travis-ci.org/ColdBox/cbox-ioc.svg?branch=development)](https://travis-ci.org/ColdBox/cbox-ioc)

# Welcome to the IoC Module
The ColdBox IOC module allows you to integrate third-party dependency injection
and inversion of control frameworks into your ColdBox Applications.

## license
Apache License, Version 2.0.

## Important links
- https://github.com/ColdBox/cbox-ioc
- http://forgebox.io/view/ioc

## Requirements
- Lucee 4.5+
- ColdFusion 9+

# Instructions
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

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
####HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12