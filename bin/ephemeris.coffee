spawn = require('child_process').spawn

module.exports = (input) ->
  spawn "python", ["ephemeris.py", "#{JSON.stringify(input)}"]
                , { cwd: __dirname }

