#!/usr/bin/env python

# Used to obtain data from the [Swiss Ephemeris](http://www.astro.com/swisseph).<br/>
# More easily invoked with [Eden](http://astrolin.com/to/eden),
# which also offers extra output options.

import sys
import json
import swisseph as swe

# Expects json as the first and only argument, containing instructions about what is needed.

if not sys.argv[1:]:
  print >>sys.stderr, sys.argv[0] + " is useless without input"
  sys.exit(1)
else:
  try:
    re = json.loads(sys.argv[1])
  except ValueError, e:
    print >>sys.stderr, "Could not load JSON object from argv[1]: " + sys.argv[1]
    sys.exit(1)

# Rarely used, pprint is imported only upon such request for output.
# It also substitutes swe.get_planet_name - can be handy on occasion.

if re["out"] == "pprint":
  from pprint import pprint


if __name__ == "__main__":

    # The data files, which may not be in the
    # [sin repo](https://github.com/astrolet/sin) /
    # [gravity pakage](http://search.npmjs.org/#/gravity).
    swe.set_ephe_path(re["data"])

    # This is a minimal e[phemeris].
    e = {"angles": {}, "things": {}, "minors": {}, "houses": {}}

    # Is using the Gregorian calendar flag correct?
    t = swe.utc_to_jd(re["ut"][0],
                      re["ut"][1],
                      re["ut"][2],
                      re["ut"][3],
                      re["ut"][4],
                      re["ut"][5],
                      1)
    # <!---
    # e["jd-ut1"] = swe.jdut1_to_utc(t[1], 1)
    # --->
    #
    # Ask for what is precious:
    #
    # * angles (ascmc) = 10 doubles (a[8] & a[9] unused)
    # * things (main bodies / points)
    # * minors (other objects)
    # * houses (cusps)  = 13 doubles (c[0] unused)
    #

    for o in [{"what": "things", "offset": 0}, {"what": "minors", "offset": 10000}]:
      for w in re[o["what"]]:
        result = swe.calc_ut(t[1], (w + o["offset"]))
        output = {}
        for out in re["ecliptic"]:
          output[out] = result[out]
        e[o["what"]][w] = output

    # The angles & houses are possible only if given geo location.
    if re["geo"]["lat"] and re["geo"]["lon"]:
      e["houses"], e["angles"] = swe.houses(t[1],
                                            float(re["geo"]["lat"]),
                                            float(re["geo"]["lon"]),
                                            str(re["system"]))

    # Print standard output.
    if re["out"] == "print":
      print(e)
    elif re["out"] == "pprint":
      for (what, offset) in {"things": 0, "minors": 10000}.iteritems():
        replace = {}
        for (key, val) in e[what].iteritems():
          replace[swe.get_planet_name(key + offset)] = val
        e[what] = replace
      pprint(e)
    else:
      print json.JSONEncoder().encode(e)

    # Necessary when called from Node / Eden.
    sys.stdout.flush()
