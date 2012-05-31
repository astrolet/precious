ut    = require('upon').ut
merge = require('deepmerge')

# Fills in the input with convenient niceties / default settings.

module.exports = (input, further) ->

  # Location of the ephemeris data, unless explicitly elsewhere.
  input.data ?= "node_modules/gravity/data"

  # Insist the data path be absolute - relative means relative to precious.
  unless input.data?.match /^\//
    input.data = "#{__dirname}/../#{input.data}"

  # Unless input.ut is set (unlikely), converts input.utc (optional) to it.
  # No input.utc does _now_.
  input.ut = ut.c(input.utc) unless input.ut?

  # In case nothing specific is asked for.
  # Get the planets - longitude and speed.
  input.stuff ?= [
      [0, 3]
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      []
    ]

  # No houses, unless both geo-coordinates and house system preference given.
  input.houses ?= false

  # Extra needs to be present, because of the deepmerge below.
  input.extra ?= {}

  # Keep it here (last), in part because of a deepmerge bug.
  # Can't merge a key of key that doesn't exist in the first place...
  input = merge input, further if further?

  input
