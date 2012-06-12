ephemeris  = require('../../index').ephemeris
convenient = require('../../index').convenient
fs         = require 'fs'
assert     = require 'assert'
colors     = require 'colors'
json       = require 'jsonify'
diff       = require('difflet')({ comma: 'first', indent: 2, comment: true })
traverse   = require 'traverse'


# Floating point numbers fixed to precision,
# suitable for testing across architectures.
precision = 14
fixFloats = (obj, digits = precision) ->
  traverse(obj).forEach (val) ->
    if typeof val is 'number' and val % 1 isnt 0
      @update val.toFixed(digits)
  return obj


# Call the ephemeris expecting a `(data) -> ...`
# callback to do something with with its stream of data.
ephemerisData = (done, input, opts, cb) ->
  child = ephemeris input, opts
  child.stderr.on "data", (data) ->
    console.log data.toString().red
  child.stdout.on "data", cb
  child.on "exit", (code) -> done()


describe "ephemeris", ->

  describe "without precious input", ->

    it "should fail, with some thrown error", ->
      ephemeris().should.throw()


  describe "with an empty input, and convenient option", ->
    output = {}
    before (done) ->
      ephemerisData done, {}, convenient: true, (data) ->
        output = json.parse data.toString()

    it "should produce some results", ->
      output.should.have.keys '1'


  describe "with test json for a nativity", ->
    output = {}
    expect = null
    before (done) ->
      fs.readFile "test/io/out/nativity.json", (err, data) ->
        expect = fixFloats (json.parse data.toString())
        fs.readFile "test/io/for/nativity.json", (err, data) ->
          ephemerisData done, json.parse(data.toString()), convenient: true, (data) ->
            output = fixFloats (json.parse data.toString())

    it "should match the corresponding out[put] data", ->
      assert.deepEqual output, expect,
        "output not as expected, see diff below\n" + diff.compare output, expect

