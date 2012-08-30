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
errs       = require('../lib/errs')
man        = require('../lib/man')


# The precious commands do complete on tab.
complete
  program: "precious"
  commands:
    stream: {}
    object: {}
    file: {}
    help: {}


# When something goes wrong, let's know what it is.
preciousError = (msg, err, code) ->
  console.log "\n#{msg}\n".red
  console.log errs.merge(err, 'precious').stack + '\n' if err?
  process.exit(code) if code?


# This is the call.  Not too efficient for the sake of easy cli
# defaults / convenience.  For something better use precious as a module lib.
# A future implementation method will not spawn a process at all.
# This `fetch` however will probably stay as it is.
fetch = (what) ->
  stream = ephemeris convenient what, extra: re: {}
  stream.on 'error', (err) ->
    preciousError 'Precious ephemeris stream error event.', err, 1
  stream.pipe process.stdout


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
      preciousError 'Bad JSON, parser error: ', err, 1

    parser.on "data", (data) ->
      data ?= {} # because empty objects parse to undefined data
      fetch data


  # The rest of the options are just for convenience / variety.

  when 'f', 'file'
    unless args[1]?
      preciousError 'Usage: precious -f <file>', null, 1
    require('fs').readFile "./#{args[1]}", "utf8", (err, data) ->
      if err
        preciousError 'Please double-check the file & path.', err, 1
      else fetch json.parse data

  when 'o', 'object'
    if args[1]? then fetch json.parse args[1]
    else
      console.log '\nNo JSON provided, format instructions follow...'.red
      man "json.7", (err, text) ->
        console.log text + "Usage: precious -o '<json>'\n".red
        process.exit(1)

  when '?', 'help'
    switch args[1]
      when "1" then man "precious.1"
      when "json" then man "json.7"
      else man "readme.7"

  else man "precious.1", (err, text) ->
    console.log text + "Usage confusion, see help above.\n".red
    process.exit(1)

# Another way to get help.
# It's common to type a command by itself and expect some usage info.
else man "precious.1"

