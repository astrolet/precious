assert = require 'assert'
diff   = require('difflet')({ comma: 'first', indent: 2, comment: true })
json   = require 'jsonify'

module.exports = assertSame = (one, two, parse = false) ->
  if parse
    one = json.parse one
    two = json.parse two
  assert.deepEqual one, two,
    "output not as expected, see diff below\n" + diff.compare one, two

