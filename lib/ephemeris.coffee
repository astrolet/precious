_      = require('underscore')
nice   = require('./convenient')
Stream = require('stream').Stream
spawn  = require('child_process').spawn
json   = require('jsonify')
errs   = require('errs')

# A node implementation may be added straight here in this module.

module.exports = (input = {}, opts = {}) ->

  # When convenient is true, the input is made nice - if it isn't already
  # just fine.  If the caller would rather put less effort, the convenient
  # is nice to help.  This is not about validation, but less input requirements.
  # Empty input defaults to convenient as well.
  if _.isEmpty(input) or opts?.convenient is true
    input = nice input

  # The implementation method isn't checked yet.
  # Python is the only one, so far.
  # opts.method ?= "py"

  stream = new Stream
  stream.writable = true

  source = spawn "python"
    , ["../bin/ephemeris.py", "#{json.stringify input}"]
    , { cwd: __dirname }

  source.stdout.on 'data', (stdout) ->
    stream.emit 'data', stdout

  source.stderr.on 'data', (stderr) ->
    stream.emit 'error', errs.create message: stderr

  source.on 'exit', (code) ->
    if code isnt 0
      stream.emit 'error', errs.create
        message: "Spawned child_process exited with code #{code}!"
    stream.emit 'end'

  stream

