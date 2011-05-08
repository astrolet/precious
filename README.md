precious -- A Minimum kind of Ephemeris
=======================================

## DESCRIPTION

Node package distribution of [pyswisseph](http://pypi.python.org/pypi/pyswisseph).

[Eden](http://www.astrolin.com/to/eden) depends on it.

More to come...


## EXAMPLES

With specific time, and somewhat more readable output:

    cli.js '{"utc": "1974-06-30T21:45Z", "out": "pprint", "extra": true}'

Or data for right now, specific location, and with whole sign houses:

    cli.js '{"geo": {"lat": 43.2166667, "lon": 27.9166667}, "houses": "W"}'

Modify the bin/defaults.json configuration according to preference.  See precious-json(7) and eden(1) for further / friendlier options.


## INSTALL

With the [npm](http://npmjs.org/) prerequisite, do `npm install -g precious`.  The `-g` for global, means the `precious` command can be run regardless of current directory.

### DEPENDENCIES

* node
* npm
* python
* gcc
* gravity


## CAVEATS

Precious isn't meant for Windows.  After Node gets to a stable v6 (v5 is for Windows compatibility), such contribution would be great.  Another one is we would have to distribute precompiled swisseph / pyswisseph.  NPM already makes that possible.

Some day, it is preferable to have Node.js bindings directly to the Swiss Ephemeris, without going through Python or FFI.  This is mostly for performance gain, of-course...


## LICENSE

This is [Unlicensed](http://unlicense.org) (free and unencumbered public domain software), except for LICENSE applying to the copy of [pyswisseph](http://pypi.python.org/pypi/pyswisseph) with [Swiss Ephemeris](http://www.astro.com/swisseph) source and its conditions (located in swe.py/src).


## SEE ALSO

precious(1), precious-coffee(1), precious-json(7), ephemeris-py(3), gravity(6), eden(1)


## NAVIGATE

Home(7)
