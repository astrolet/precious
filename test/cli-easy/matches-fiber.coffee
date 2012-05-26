sync    = require('synchronize')
child   = require('child_process')

sync child, 'exec'

matches = man: {}

sync.fiber ->

  for key, page of { precious1: "precious", json7: "precious-json" }
    stdout = child.exec "man #{page}"
    matches.man[key] = "\n#{stdout}\n"

  # console.log matches
  module.exports = matches

