#!/usr/bin/env coffee

# This is a convenience script.  Use eden(1) for greater convenience.
#
# It assembles the precious.json ephemeris instructions.
# Only one argument (json) expected.
# Anything extra is ignored.
# Anything less (i.e. nothing) means it's entirely up to the defaults.

# What's required - not necessarily much...
util    = require('util')
cjson   = require('cjson')
_       = require("massagist")._
ut      = require("lin").ut
exec    = require('child_process').exec

# The starting point - i.e. defaults.
input = cjson.load __dirname + "/defaults.json"

# JSON arguments supersede the default instructions.
arguments = process.argv.splice(2)
if arguments.length > 0
  input = _.allFurther input, JSON.parse(arguments[0])

# Insist the data path be absolute - relative means relative to precious.
unless input.data.match /^\//
  input.data = "#{__dirname}/../#{input.data}"

# Unless input.ut is set (unlikely), converts input.utc (optional) to it.  No input.utc means _now_.
input.ut = ut.c(input.utc) unless input.ut?

# Call ephemeris.py
child = exec "#{__dirname}/../lib/ephemeris.py '#{JSON.stringify(input)}'", (error, stdout, stderr) ->
    if error?
      console.log 'Exec error: \n' + error
    else
      util.print '\n' + stdout + '\n'
