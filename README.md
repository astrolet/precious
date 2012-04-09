precious -- A Minimum kind of Ephemeris
=======================================

## DESCRIPTION

Node package distribution of
[pyswisseph](http://pypi.python.org/pypi/pyswisseph).

[Eden](http://www.astrolin.com/to/eden) depends on it.

More to come...


## EXAMPLES
As lazy as possible, fetch ephemeris data with the convenient defaults:
    precious {}

With specific time, "pprint" for a bit more readable output + names:

    precious '{"utc": "1974-06-30T21:45Z", "out": "pprint"}'

No "utc" for *right now*, it also fetches the angles, given geo-location:

    precious '{"geo": {"lat": 43.2166667, "lon": 27.9166667}}'

Modify the bin/defaults.json configuration according to preference.
See precious-json(7) and eden(1) for further / friendlier options.


## INSTALL

With the [npm](http://npmjs.org/) prerequisite, do `npm install -g precious`.
The `-g` for global, means the `precious` command can be run
regardless of what the current directory is.

### DEPENDENCIES

* node
* npm
* gcc
* python
* pycco
* gravity

There is a `cake install` task that is somewhat useful.  It assumes that
Python, a C compiler and Node.js are already installed.


## CAVEATS

It's unknown how the project should be setup for Windows development / use.
Contribution of such instructions would be great to have.

Some day, it would be preferable to have Node.js bindings directly to
the Swiss Ephemeris, without going through Python or FFI.
[Emscripten](http://emscripten.org) stands out as a likely next step.


## LICENSE

This is [Unlicensed](http://astrolet.github.com/precious/UNLICENSE.html) (free
and unencumbered public domain software), except for LICENSE applying to the
copy of [pyswisseph](http://pypi.python.org/pypi/pyswisseph)
with [Swiss Ephemeris](http://www.astro.com/swisseph) source
and its conditions (located in swe/src).


## SEE ALSO

precious(1), precious-coffee(1), precious-json(7), ephemeris-py(3), gravity(6),
eden(1)


## NAVIGATE

Home(7)
