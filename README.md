# Enhance [![Build Status](https://secure.travis-ci.org/jico/enhance.png?branch=master)](http://travis-ci.org/jico/enhance)

A flexible node.js module for serving high-res images to high pixel density devices.

## Installation

### Via npm

Add `enhance` to your `package.json`, or run `npm install --save`.

If you're using Hem, make sure to add it to your `slug.json` file as a
dependency.

### Via Bower

Add `enhance` to your `bower.json`, or run `bower install --save`.

## Usage

Require _Enhance_ in your app, optionally passing in initialization options, and
typically set to a global variable. In CoffeeScript, it would look something
like:

```coffee
Enhance = require('enhance')(options)
```

You can also use the browserified version by including `build/enhance.js` in
your app and passing in your options to the `Enhance` object on the `window`.

```coffee
Enhance(options).render('image.png')
```

### `render`

Given no [configuration options](#configuration), _Enhance_ falls back to
Apple's convention of suffixing image file names with `@2x` before the
extension if a Retina or other high DPI display is detected.

For example, consider calling the main function `render` on a Retina device:

```coffee
Enhance.render('image.png')
# => "image@2x.png"
```

If the device does not have a high DPI, the call to `render` will simply return
the file name unaltered (unless initialization options have been passed).

### `isHiDPI`

You can use the available method `isHiDPI` to check if a device is one of high
DPI. The default device pixel ratio is 1.3, but `isHiDPI` takes an optional
ratio parameter to use as a threshold.

### `isMobileDevice`

To detect whether a user is on a mobile device, you can call `isMobileDevice`,
which uses `max-width` media queries as a test.

By default, tablets are not considered mobile devices. However, you can consider
them by enabling the `tabletAsMobile` option when initializing _Enhance_:

Additionally, you can override the width breakpoints for both mobile and tablet
devices, see [configuration](#configuration). The default breakpoints are:

```coffee
phoneBreakpoint:  480
tabletBreakpoint: 1024
```

## Configuration

_Enhance_ accepts initial configuration options to provide flexibility if your
app doesn't follow Apple's Retina naming convention.

### host

Prepends the given `host` value to file names passed to the call to `render`.

__Default:__ _null_

```coffee
Enhance = require('enhance')(host: 'http://www.example.com')
Enhance.render('image.png')
# => "http://www.example.com/image@2x.png" (high DPI)
```

### suffix

The string to prepend before the file name extension.

__Default:__ _"@2x"_

```coffee
Enhance = require('enhance')(suffix: '_2x')
Enhance.render('image.png')
# => "image_2x.png" (high DPI)
```

### render

Custom callback function to use in place of the default `render` method. Passes
in a helper object that makes available the following:

* `isHiDPI`
* `_` - [lodash](http://lodash.com) function with additional extensions:
  * `joinURIComponents` - Joins any number of URI string component arguments
  while preserving double slashes (i.e. the case of `http://`)
* `src` - String argument of `render`
* Any and all other parameters passed upon initialization or the call to `render`

```coffee
options =
  host: 'http://example.com/transform'
  suffix: '_2x'
  render: (helpers) ->
    if helpers.isHiDPI()
      path = "#{encodeURIComponent(helpers.src)}/resize/#{helpers.width*2}x#{helpers.height*2}#"
    else
      path = "#{encodeURIComponent(helpers.src)}/resize/#{helpers.width}x#{helpers.height}#"
    helpers._.joinURIComponents(helpers.host, path)

Enhance = require('enhance')(options)

Enhance.render('image.png', width: 50, height: 100)
```

### phoneBreakpoint

Breakpoint for detecting mobile phone devices. Used by `isMobileDevice` method.

__Default__: _480_

### tabletBreakpoint

Breakpoint for detecting mobile tablet devices. Used by `isMobileDevice` method.

__Default__: _1024_

### tabletAsMobile

__Default__: _false_

Enables consideration on tablets as mobile devices.


## License

Copyright 2013 Jico Baligod.

Licensed under the [MIT License](http://github.com/jico/enhance/raw/master/LICENSE).
