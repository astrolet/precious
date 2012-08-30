ephemeris  = require('../../index').ephemeris
convenient = require('../../index').convenient
fs         = require 'fs'
json       = require 'jsonify'
assertSame = require '../helpers/assert_same'


# Callback to do something with a stream of json data.
# Reports any errors.  Also calls done upon end-of-stream.
ephemerisObject = (stream, done, callback) ->
  stream.on "data", (data) -> callback json.parse data.toString()
  stream.on "error", (err) -> console.error err
  stream.on "end", -> done()


describe "ephemeris", ->

  describe "without any input", ->
    output = {}
    before (done) ->
      stream = ephemeris()
      ephemerisObject stream, done, (o) ->
        output = o

    it "produces results as if convenient option is true", ->
      output.should.have.keys '1'


  describe "with incomplete input and convenient option", ->
    output = {}
    before (done) ->
      stream = ephemeris {whatever: "irrelevant"}, convenient: true
      ephemerisObject stream, done, (o) ->
        output = o

    it "should just as well produce some default results", ->
      output.should.have.keys '1'


  describe "with test json for a nativity", ->
    output = {}
    expect = null
    before (done) ->
      fs.readFile "test/io/out/nativity.json", (err, data) ->
        expect = json.parse data.toString()
        fs.readFile "test/io/for/nativity.json", (err, data) ->
          stream = ephemeris json.parse(data.toString()), convenient: true
          ephemerisObject stream, done, (o) ->
            output = o

    it "should match the corresponding out[put] data", ->
      assertSame [output, expect],
        fixFloats: true

