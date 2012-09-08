assert = require 'assert'
diff   = require('difflet')({ comma: 'first', indent: 2, comment: true })
json   = require 'jsonify'

fixFloats = require './fix_floats'

module.exports = assertSame = (vals, options = {}) ->

  # Must have at least two items in order to assert sameness.
  return unless vals.length > 1

  options.parse ?= false
  options.fixFloats ?= false

  for i in [0..(vals.length-1)]
    if options.parse then vals[i] = json.parse vals[i]
    if options.fixFloats then vals[i] = fixFloats vals[i]

    if i > 0 then assert.deepEqual vals[i-1], vals[i],
      "output not as expected, check diff:\n" + diff.compare vals[i-1], vals[i]

