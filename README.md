# [![Build Status](https://secure.travis-ci.org/astrolet/precious.png)](http://travis-ci.org/astrolet/precious)
# precious -- the minimum kind of ephemeris


## SAY
[Ephemeris](http://en.wikipedia.org/wiki/Ephemeris) data,
from a Node.js library or the command line.


## HOW

### lib/

The programming way.

Give the precious ephemeris(3) some precious-json(7)
and it will return a [stream](https://github.com/substack/stream-handbook)
of what you asked for.  Here is a CoffeeScript example:

    got = require('precious').ephemeris {}, convenient: true
    got.stdout.on 'data', (s) -> console.log JSON.parse s

And a JavaScript equivalent:

    var got = require('precious').ephemeris({}, {convenient: true});
    got.stdout.on('data', function(s) {
      console.log(JSON.parse(s));
    });

### bin/

The precious(1) [command-line-interface][precious.1].

As lazy as possible, fetch ephemeris data with the convenient defaults:

    precious o {}

With specific time, "pprint" for a bit more readable output + names:

    precious o '{"utc": "1974-06-30T21:45Z", "out": "pprint"}'

No "utc" for *right now*, it also fetches the angles, given geo-location:

    precious o '{"geo": {"lat": 43.2166667, "lon": 27.9166667}}'

Copy & change the `test/io/for/example.json` to fit your use-case preferences.
See precious-json(7) and eden(1) for further / friendlier options.

Eden will be the obvious, very convenient way for working with `precious`.
Whether it's for a more usable command-line-interface, exposing the ephemeris(3)
library / stream through various transports, generating precious-json(7) -
or other, beyond the scope of this page, uses.


## ABOUT

Node package distribution of
[pyswisseph](http://pypi.python.org/pypi/pyswisseph).
Python is just the current method for calling the Swiss Ephemeris.
It has been handy for a rapid prototype / bootstrapping.
Direct JavaScript bindings are preferable and will eventually be implemented.
At that point, the Python code is to be ported and retired.
This module's purpose is to make writing astrology apps on _Node.JS_
both possible and straightforward.

[Eden](http://www.astrolin.com/to/eden) depends on it as a matter of personal
choice. As may other libs / interfaces too.

Think of `precious` as a language-neutral, decoupled way to get data from
the Swiss Ephemeris.  Or from any kind of ephemeris for that matter.
For example someone may choose to implement a Moshier substitute, whether
for the sake of using a different license or whatever the reason.

In reality, while it may some day offer varying ephemeris choice,
people are likely to prefer the Swiss Ephemeris anyway.
Furthermore, while it can use various languages through child-process calls --
the performing way would be JavaScript bindings, because it's intended
exclusively for JavaScript use, of-course also CoffeeScript, etc.
It is really just an interface abstraction that affords some potential freedom.
A way of making progress while keeping your options open.

Precious is a precious-json(7) spec about (a limited subset of) what
one may want from an ephemeris, so that requests for data
can be decoupled from the implementation(s) that satisfy them.

The reference implementation and the ephemeris are for the time being
part of `precious` itself, however there is no reason they can't be external
modules / dependencies, especially with regards to varying the
choice of ephemeris or how it's to be called.  There may also be a couple of
ways to call the Swiss Ephemeris - either with bindings for Node or possibly
compiling it to pure JavaScript with [Emscripten](http://emscripten.org) for
example.  The latter will offer the possibility to run practically anywhere.
The former will obviously be preferable when using Node.  The following
[swisseph](https://github.com/mivion/swisseph) library is a promising
candidate for doing just that.

The kind of ephemeris data provided, is currently rather simple and constrained.
Configuration options will progressively be added to include
other more interesting and necessary things.  So,
precious will aim to satisfy a wider range of use-cases.
It will, however, remain an opinionated subset of what an ephemeris can provide.
Not everything that's possible is necessary, though be welcome to add
anything you may wish to contribute for more specialized use-case enablement.


## SETUP

With the [npm](http://npmjs.org/) prerequisite, do `npm install -g precious`.
The `-g` for global, means the `precious` command can be run
regardless of what the current directory is.

### Dependencies:

* node
* npm
* gcc
* python
* pycco
* gravity

There is a `cake install` task that is somewhat useful.  It assumes that
Python, a C compiler and Node.js are already installed.


## TEST

    cake test


## LACKS

It's unknown how the project should be setup for Windows development / use.
Perhaps it just works flawlessly or with just a bit of extra setup effort?
While [installing the stuff](http://dailyjs.com/2012/05/17/windows-and-node-3)
may be relatively straightforward, I'm not too sure all my code would run as is.
Verification / contribution of setup instructions would be great to have.
Of-course, issues are welcome - just as well.

Spawning a process to run a Python script is kind of slow.
Some day, it would be preferable to have Node.js bindings directly to
the Swiss Ephemeris, without going through Python or FFI. Either this
[swisseph](https://github.com/mivion/swisseph) library or (maybe also)
[Emscripten](http://emscripten.org) stand out as possible next steps.


## LAW

This is [Unlicensed](http://astrolet.github.com/precious/UNLICENSE.html) (free
and unencumbered public domain software), except for LICENSE applying to the
copy of [pyswisseph](http://pypi.python.org/pypi/pyswisseph)
with [Swiss Ephemeris](http://www.astro.com/swisseph) source
and its conditions (located in swe/src).


## ALSO

precious(1), precious-coffee(1), precious-json(7), upon(7), gravity(6),
ephemeris(3), ephemeris-py(3), eden(1)


## HOME

Base(7)


[precious.1]: http://astrolet.github.com/precious/precious.1.html

