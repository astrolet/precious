exec     = require('child_process').exec
parallel = require('async').parallel
Stream   = require("stream").Stream

module.exports = new Stream

man = (page, cb) ->
  exec "man man/#{page}", (err, stdout, stderr) ->
    if err?
      cb err, stderr.toString()
    else
      cb null, "\n#{stdout}\n"

parallel {
  man: (cb) ->
    parallel {
      precious1: (cb) -> man 'precious.1', cb # man precious
      readme7: (cb) -> man 'readme.7', cb # man precious-readme
      json7: (cb) -> man 'json.7', cb # man precious-json
    }, (err, pages) ->
      cb null, pages
  # there could be other stuff to load in parallel to man-pages
}, (err, matches) ->
  module.exports.emit "data", matches
  module.exports.emit "ready"

