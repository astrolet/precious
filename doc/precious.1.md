# precious(1) -- a minimum kind of ephemeris


## ABOUT

Anything less we couldn't do astrology with.

Use eden(1) for a better cli experience.
Better for both precious-json(7) input options and human-readable output.
Either of which could be used individually as well.  See *stream* examples /
usage next.


## USAGE

Running precious from the command line (instead of programming JavaScript)
is not the most efficient nor the most convenient, though it's ok too.
The commands can tab-complete.

Some precious-json(7) must be provided in one of three ways:

1. `-`, `s` or `stream` input though unix pipes - all the rest can be covered
with this approach too, see the double examples for equivalents.

    eden pre | precious -

2. `f` or `file` followed by a json file `<path>`

    precious f test/io/for/example.json

    cat test/io/for/example.json | precious -

3. `o` or `object` given a json string `<'input'>`, even if just `{}`

    precious o {}

    echo {} | precious -

The streams way could do it all,
with just a few extra characters typing.
Though perhaps not using Windows.

Here is how `eden` can help by not only piping input, but also making the output
more readable, streams are awesome:

    eden pre | precious - | eden eat

This is the equivalent of `eden know`.  Pipe any of the `precious` examples into
`eden eat` - and feast on what could be seen, at least.

A global eden is automatically available through `postinstall`.
Go ahead and try it.


## HELP

This is also a man-page and can be read with any one of:

    precious
    man precious
    precious ? 1

Help for precious-json(7) is also available using these:

    precious help json
    man  precious-json

See Index(7) or `precious ?` for the precious
[README](https://github.com/astrolet/precious#readme).


## ALSO

precious-json(7), gravity(6), eden(1)

## HOME

Index(7), Base(7)
