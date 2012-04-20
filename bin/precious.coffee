#!/usr/bin/env coffee

# This is a convenience script.
# Use [eden(1)](http://astrolet.github.com/eden/eden.1.html) for
# greater convenience.
#
# It takes a string of json, and calls precious.py with it.
# Only one argument expected.
# Anything extra is ignored.
# Run `precious json` or visit
# [precious-json(7)](http://astrolet.github.com/precious/json.7.html)
# for format details.  The latter (web documentation) is better.
# Anything less (i.e. nothing) means the [convenient](#section-5)
# defaults will be used.

# What is - required.
ut        = require('lin').ut
json      = require('jsonify')
ephemeris = require('./ephemeris')


# There are several man pages, reused for help.
man = (page) ->
  require('child_process').exec "man #{page}", (err, out) ->
    if err
      console.error "Can't get: `man #{page}`."
      console.error "Go to http://astrolet.github.com/precious/ for help."
      process.exit(1)
    else
      console.log out


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


# This is the call.
# Note the extra parse / stringify just for the sake of easy defaults.
# It isn't the most efficient way to do it, but it does offer convenience.
fetch = (what) ->
  stream = ephemeris convenient json.parse what
  stream.stderr.on 'data', (error) ->
    console.error 'Spawned child_process stderr -- ' + error
    process.exit(1)
  stream.stdout.pipe process.stdout


# Processing of command-line arguments.  Minimal on purpose.
# Expects `<json>` string or `-i <file>`.
# Does help with man pages for precious, precious-json.
arguments = process.argv.splice(2)
if arguments.length > 0
  if arguments[0] is '-i'
    unless arguments[1]?
      console.error "Usage: precious -i <file>"
      process.exit(1)
    require('fs').readFile "./#{arguments[1]}", "utf8", (err, data) ->
      if err
        console.error "
An error has ocurred.  Please double-check the file & path."
        console.error err
        process.exit(1)
      else fetch data
  else if arguments[0] is "json" then man "precious-json"
  else fetch arguments[0]
else man "precious"

