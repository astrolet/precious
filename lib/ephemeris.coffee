spawn = require('child_process').spawn

# The implementation method isn't checked yet.  So far, python is the only one.
# A node implementation may be added straight here in this module.
# The method could also become part of the input / configuration.
module.exports = (input, method = "py") ->
  spawn "python", ["../bin/ephemeris.py", "#{JSON.stringify(input)}"]
                , { cwd: __dirname }

