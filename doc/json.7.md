precious-json(7) -- tells precious what is wanted
=================================================

Data format / expectations about what goes in and out of `precious`.


## DESCRIPTION

A precious sample of valid json input:

    { "data": "node_modules/gravity/data"
    , "out": "json"
    , "stuff": [ [0, 3], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11], [] ]
    , "utc": null
    }

### REQUEST

Specification of the instructions or defaults that `precious` takes.

#### data

A relative or absolute path to the Swiss Ephemeris data files.

#### out

We get "json" by default anyway (same as null).  A bit more human-readable output is "pprint".  Even better is Eden's command line interface.

#### stuff

The kind of stuff to be returned, or null, or empty array(s) [] - mean all the same default equivalent.  The first array `[0, 3]` respectively yields ecliptic position and speed for each item of interest.  These map directly to results of the `swe.calc_ut` function.  The second array contains the main kind of things - returned with key of 1.  The third array contains the minor kind of things - offset by 10,000 and returned with key of 2.

#### utc

Undefined (or null) _utc_ time - means the current moment will be used.  Otherwise provide a string in ISO-8601(7) format.

#### ut

Besides the _utc_ semi-convenience, this _ut_ array of time fragments will be passed on directly to the `swe.utc_to_jd` function (as its arguments).  It takes precedence over the any _utc_ value that it is otherwise derived from.  Such option exists in case an intermediate conversion is not wanted.

#### geo

A value of null for _geo_ location or its _lat_ / _lon_ coordinates (i.e. `"geo": {"lat": null, "lon": null}`) - means there will be no angles (e.g. Asc / Mc) returned.

#### houses

A value of false for the _houses_ means we are not interested in any cusps, rendering any house system irrelevant (for the particular request).  None will be returned, even if the prerequisite geo coordinates are provided.  Check the swiss ephemeris manual for a list of valid house system codes.


### RESPONSE

The corresponding sample of precious output:

    {
        1: {
            0: { 0: 98.70827783123845, 3: 0.9532022042652956 },
            1: { 0: 238.13984880619816, 3: 12.452087297655709 },
            2: { 0: 98.60114469380143, 3: -0.6003120017761042 },
            3: { 0: 65.812762301102, 3: 1.1840328495003745 },
            4: { 0: 133.42642172932844, 3: 0.616988988136803 },
            5: { 0: 347.7929441223906, 3: 0.02179812116697949 },
            6: { 0: 98.3799968014031, 3: 0.13007751871185486 },
            7: { 0: 203.65922951629008, 3: -0.000969922057072429 },
            8: { 0: 247.43838201042857, 3: -0.02209121163048053 },
            9: { 0: 184.1376254881621, 3: 0.009023772953667774 },
            11: { 0: 259.402942463929, 3: 0.02027545162955067 }
        },
        2: {}
    }


## SEE ALSO

precious(1), JSON(7), ISO-8601(7)


## NAVIGATE

Index(7), Home(7)
