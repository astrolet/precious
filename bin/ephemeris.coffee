exec   = require('child_process').exec
util   = require('util')

module.exports = (input) ->
  exec "#{__dirname}/ephemeris.py '#{JSON.stringify(input)}'",
    (error, stdout, stderr) ->
      if error
        console.error 'Got error from exec of child_process.\n', error
        process.exit(1)
      else
        util.print stdout

