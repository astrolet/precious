traverse = require 'traverse'

# Floating point numbers fixed to precision,
# suitable for testing across architectures.

precision = 7

module.exports = fixFloats = (obj, digits = precision) ->
  traverse(obj).forEach (val) ->
    if typeof val is 'number' and val % 1 isnt 0
      @update val.toFixed(digits)
  return obj

