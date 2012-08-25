#!/usr/bin/env coffee

# This is a convenience script.
# Use [eden(1)](http://astrolet.github.com/eden/eden.1.html) for
# greater convenience.

# It takes json in various ways and calls precious.py with it.
# Run `precious -h json` or `man precious-json` or visit
# [precious-json(7)](http://astrolet.github.com/precious/json.7.html)
# for format details.  The latter (web documentation) is better.
# Anything less, perhaps even nothing, means the [convenient](convenient.html)
# defaults will be used.


complete   = require('complete')
convenient = require('../index').convenient
ephemeris  = require('../index').ephemeris
JSONStream = require('JSONStream')
json       = require('jsonify')
colors     = require('colors')
man        = require('../lib/man')


# The precious commands do complete on tab.
complete
  program: "precious"
  commands:
    stream: {}
    object: {}
    file: {}
    help: {}


# This is the call.  Not too efficient for the sake of easy cli
# defaults / convenience.  For something better use precious as a module lib.
# Waiting for Node's new child_process streams interface, as well as
# a second implementation method that will not spawn a process at all.
# Will revist / refactor `fetch` then.
fetch = (what) ->
  stream = ephemeris convenient what, extra: re: {}
  stream.stderr.on 'data', (error) ->
    console.error '\nSpawned child_process error.\n'.red + error
    process.exit(1)
  stream.stdout.pipe process.stdout


# Processing of command-line args.  Minimal on purpose.
# Does help with man pages for precious, precious-json.
args = process.argv.splice(2)
if args.length > 0 then switch args[0]

  # Stream pipe, unix style.
  when '-', 's', 'stream'
    process.stdin.resume()
    process.stdin.setEncoding("utf8")

    # A good parser.
    parser = JSONStream.parse true
    process.stdin.pipe parser

    parser.on "error", (err) ->
      console.error "Bad JSON, parser error: ".red + err.message
      process.exit(1)

    parser.on "data", (data) ->
      data ?= {} # because empty objects parse to undefined data
      fetch data


  # The rest of the options are just for convenience / variety.

  when 'f', 'file'
    unless args[1]?
      console.error "Usage: precious -f <file>".red
      process.exit(1)
    require('fs').readFile "./#{args[1]}", "utf8", (err, data) ->
      if err
        console.error "
An error has ocurred.  Please double-check the file & path.".red
        console.error err
        process.exit(1)
      else fetch json.parse data

  when 'o', 'object'
    if args[1]? then fetch json.parse args[1]
    else
      console.error "\nNo JSON provided, format instructions follow...".red
      man "json.7", 1, ->
        console.error "Usage: precious -o '<json>'\n".red

  when '?', 'help'
    switch args[1]
      when "1" then man "precious.1"
      when "json" then man "json.7"
      else man "readme.7"

  else man "precious", 1, ->
    console.error "Usage confusion, see help above.\n".red

# Another way to get help.
# It's common to type a command by itself and expect some usage info.
else man "precious.1"

