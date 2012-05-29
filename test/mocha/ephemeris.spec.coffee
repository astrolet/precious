ephemeris  = require('../../index').ephemeris
convenient = require('../../index').convenient
fs         = require 'fs'
assert     = require 'assert'
colors     = require 'colors'
json       = require 'jsonify'
diff       = require('difflet')({ comma: 'first', indent: 2, comment: true })


describe "ephemeris", ->

  describe "without precious input", ->

    it "should fail, with some thrown error", ->
      ephemeris().should.throw()

  describe "with test json for a nativity", ->
    output = {}
    expect = null
    before (done) ->
      fs.readFile "test/io/out/nativity.json", (err, data) ->
        expect = json.parse data.toString()
        fs.readFile "test/io/for/nativity.json", (err, data) ->
          child = ephemeris convenient json.parse data.toString()
          child.stderr.on "data", (data) ->
            console.log data.toString().red
          child.stdout.on "data", (data) ->
            output = json.parse data.toString()
          child.on "exit", (code) ->
            done()

    it "should match the corresponding out[put] data", ->
      assert.deepEqual output, expect,
        "output not as expected, see diff below\n" + diff.compare output, expect

