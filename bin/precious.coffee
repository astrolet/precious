#!/usr/bin/env coffee

# This is a convenience script.
# Use [eden(1)](http://astrolet.github.com/eden/eden.1.html) for
# greater convenience.
#
# It takes json in various ways and calls precious.py with it.
# Run `precious -h json` or `man precious-json` or visit
# [precious-json(7)](http://astrolet.github.com/precious/json.7.html)
# for format details.  The latter (web documentation) is better.
# Anything less (i.e. nothing) means the [convenient](#section-5)
# defaults will be used.

# What is - required.
ut        = require('upon').ut
json      = require('jsonify')
JSONStream = require('JSONStream')
ephemeris = require('./ephemeris')
colors    = require('colors')


# There are several man pages, reused for help.
# Sometimes help is given together with a non-zero exit status, aka _error_.
man = (page, status = 0, cb) ->
  require('child_process').exec "man #{page}", (err, out) ->
    if err
      console.error "Can't get: `man #{page}`.".red
      console.error "Go to http://astrolet.github.com/precious/ for help."
      process.exit(1)
    else
      console.log "\n" + out
      cb() if cb?
      process.exit(status)


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
    console.error '\nSpawned child_process error.\n'.red + error
    process.exit(1)
  stream.stdout.pipe process.stdout


# Processing of command-line args.  Minimal on purpose.
# Does help with man pages for precious, precious-json.
args = process.argv.splice(2)
if args.length > 0 then switch args[0]

  # Stream pipe, unix style.
  when '-s', '--stream'
    process.stdin.resume()
    process.stdin.setEncoding("utf8")

    # A good parser.
    parser = JSONStream.parse /./
    process.stdin.pipe parser

    parser.on "data", (data) ->
      (ephemeris convenient data).stdout.pipe process.stdout

    parser.on "error", (err) ->
      console.error "Bad JSON, parser error: ".red + err.message
      process.exit(1)


  # The rest of the options are just for convenience / variety.

  when '-f', '--file'
    unless args[1]?
      console.error "Usage: precious -f <file>".red
      process.exit(1)
    require('fs').readFile "./#{args[1]}", "utf8", (err, data) ->
      if err
        console.error "
An error has ocurred.  Please double-check the file & path.".red
        console.error err
        process.exit(1)
      else fetch data

  when '-o', '--json'
    if args[1]? then fetch args[1]
    else
      console.error "\nNo JSON provided, format instructions follow...".red
      man "precious-json", 1, ->
        console.error "Usage: precious -o '<json>'\n".red

  when '-h', '--help'
    if args?[1] is "json" then man "precious-json"
    else man "precious"

  else man "precious", 1, ->
    console.error "Usage confusion, see help above.\n".red

# Another way to get help.
# It's common to type a command by itself and expect some usage info.
else man "precious"

