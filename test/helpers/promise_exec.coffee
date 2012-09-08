Q = require "q"
exec = require("child_process").exec

module.exports = (command) ->
  deferred = Q.defer()
  exec command, (err, stdout, stderr) ->
    if err then deferred.reject new Error err
    else deferred.resolve stdout
  deferred.promise

