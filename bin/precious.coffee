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


# Note the extra parse / stringify just for a couple of trifles.
# It isn't the most efficient way to do it, but it does offer convenience.
fetch = (what) ->
  input = json.parse what

  # Insist the data path be absolute - relative means relative to precious.
  unless input.data?.match /^\//
    input.data = "#{__dirname}/../#{input.data}"

  # Unless input.ut is set (unlikely), converts input.utc (optional) to it.
  # No input.utc does _now_.
  input.ut = ut.c(input.utc) unless input.ut?

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

