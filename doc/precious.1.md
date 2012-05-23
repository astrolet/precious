# precious(1) -- a minimum kind of ephemeris

## SYNOPSIS

Anything less we couldn't do astrology with.

Use eden(1) for a better cli experience.


## USAGE

Running precious from the command line (instead of programming JavaScript)
is not the most efficient nor the most convenient, though it's ok too.

Some precious-json(7) must be provided in one of three ways:

1. `-s` or `--stream` input though unix pipes - all the rest can be covered
with this approach too, see the double examples for equivalents.

    eden precious | precious -s

2. `-f` or `--file` followed by a json file `<path>`

    precious -f bin/example.json

    cat bin/example.json | precious -s

3. `-o` or `--object` given a json string `<'input'>`, even if just `{}`

    precious -o {}

    echo {} | precious -s

The streams way could do it all,
with just a few extra characters typing.
Though perhaps not using Windows.


## HELP

This is also a man-page and can be read with any one of:

    man precious
    precious [-h | --help]

Help for precious-json(7) is also available using these:

    man precious-json
    precious [-h | --help] json

See Index(7) for the precious
[README](https://github.com/astrolet/precious#readme).


## SEE ALSO

precious-json(7), gravity(6), eden(1)

## NAVIGATE

Index(7), Home(7)
