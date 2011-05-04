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

# No time means now.
unless input.ut?
  iso8601Format = /^(\d{4})-(\d{2})-(\d{2})((([T ](\d{2}):(\d{2})(:(\d{2})(\.(\d+))?)?)?)?)?(([-+])(\d{2}):(\d{2}))?(Z)?$/
  t = (new Date Date.now()).toISOString().match(iso8601Format)
  input.ut = [ Number(t[1])
             , Number(t[2])
             , Number(t[3])
             , Number(t[7])
             , Number(t[8])
             , Number("#{t[10]}.#{t[12]}")
             ]

# Call ephemeris.py
child = exec "#{__dirname}/../lib/ephemeris.py '#{JSON.stringify(input)}'", (error, stdout, stderr) ->
    if error?
      console.log 'Exec error: \n' + error
    else
      util.print '\n' + stdout + '\n'
