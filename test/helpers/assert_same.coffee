assert = require 'assert'
diff   = require('difflet')({ comma: 'first', indent: 2, comment: true })

module.exports = assertSame = (one, two) ->
  assert.deepEqual one, two,
    "output not as expected, see diff below\n" + diff.compare one, two

