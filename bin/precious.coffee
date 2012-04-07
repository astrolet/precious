#!/usr/bin/env coffee

# This is a convenience script.  Use eden(1) for greater convenience.
#
# It takes a string of json, and calls precious.py with it.
# Only one argument expected.
# Anything extra is ignored.
# See `man precious-json` for format details.
# Anything less (i.e. nothing) means defaults.json will be used.

# What's required.
ut     = require('lin').ut
json   = require('jsonify')
exec   = require('child_process').exec
util   = require('util')


# Fill in the input with convenient niceties / default settings.
convenient = (input) ->

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

  input


# Note the extra parse / stringify just for the sake of easy defaults.
# It isn't the most efficient way to do it, but it does offer convenience.
fetch = (what) ->
  input = convenient json.parse what

  # The call.
  child = exec "#{__dirname}/ephemeris.py '#{JSON.stringify(input)}'",
    (error, stdout, stderr) ->
      if error?
        console.error 'Exec error: \n' + error
      else
        util.print '\n' + stdout + '\n'


# JSON arguments or defaults.json (the latter is just a test).
arguments = process.argv.splice(2)
if arguments.length > 0 then fetch arguments[0]
else require('fs').readFile "#{__dirname}/defaults.json", "utf8", (err, data) ->
  if err then throw err else fetch data

