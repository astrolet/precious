nice  = require('./convenient')
spawn = require('child_process').spawn

# A node implementation may be added straight here in this module.

module.exports = (input, opts = {}) ->

  # When convenient is true, the input is made nice - if it isn't already
  # just fine.  If the caller would rather put less effort, the convenient
  # is nice to help.  This is not about validation, but less input requirements.
  if opts.convenient ? false
    input = nice input

  # The implementation method isn't checked yet.
  # Python is the only one, so far.
  # opts.method ?= "py"
  spawn "python", ["../bin/ephemeris.py", "#{JSON.stringify(input)}"]
                , { cwd: __dirname }

