exec = require('child_process').exec
async = require 'async'

# Executes commands, then a callback with the mapped results.
module.exports = mapExec = (calls = [], cb) ->

  iterator = (item, cbk) ->
    exec item, (err, stdout, stderr) ->
      console.log "ran: #{item}"
      console.log "got: #{stdout}"
      console.log err if err?
      cbk err, stdout

  async.map calls, iterator, cb

