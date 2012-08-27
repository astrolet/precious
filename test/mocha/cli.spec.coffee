assertSame = require "../helpers/assert_same"
doMatch = require "../helpers/matches_async"
proExec = require "../helpers/promise_exec"
mapExec = require "../helpers/map_exec"
require("mocha-as-promised")()
json    = require "jsonify"


precious = "bin/precious.js"
jsontool = "node_modules/jsontool/lib/jsontool.js"
jsontool0 = "#{jsontool} -o json-0"

describe "$ `precious", ->

  matches = {}
  before (done) ->
    doMatch.on "data", (data) -> matches = data
    doMatch.on "ready", -> done()


  # Help

  describe "` by itself, with no arguments", ->
    it "returns `man precious`", ->
      (proExec "#{precious}").then (result) ->
        assertSame [result, matches.man.precious1]

  describe "?`, short for help", ->
    it "is same as `man precious-readme`", ->
      (proExec "#{precious} ?").then (result) ->
        assertSame [result, matches.man.readme7]

  describe "help`", ->
    it "is same as `man precious-readme`", ->
      (proExec "#{precious} help").then (result) ->
        assertSame [result, matches.man.readme7]

  describe "help json`", ->
    it "is `man precious-json`", ->
      (proExec "#{precious} help json").then (result) ->
        assertSame [result, matches.man.json7]


  # Stream

  describe "-`, being piped a stream of spec-conforming json", ->
    it "produces the expected output", ->
      (proExec "cat test/io/for/nativity.json | #{precious} -").then (dash) ->
        (proExec "cat test/io/for/nativity.json | #{precious} stream").then (stream) ->
          (proExec "cat test/io/for/nativity.json | #{precious} s").then (s) ->
            (proExec "cat test/io/out/nativity.json").then (expected) ->
                assertSame [dash, stream, s, expected],
                  parse: true
                  fixFloats: true


  # File

  describe "f[ile]`, given path to a spec-conforming json", ->
    it "produces the expected output", ->
      (proExec "#{precious} f test/io/for/nativity.json").then (result) ->
        (proExec "#{precious} file test/io/for/nativity.json").then (also) ->
          (proExec "cat test/io/out/nativity.json").then (expected) ->
            assertSame [result, also, expected],
              parse: true
              fixFloats: true


  # Object
  describe "o[bject]`, given a spec-conforming json string", ->
    it "produces the expected output", ->
      (proExec "cat test/io/for/nativity.json").then (input) ->
        (proExec "#{precious} o '#{input}'").then (result) ->
          (proExec "#{precious} object '#{input}'").then (also) ->
            (proExec "cat test/io/out/nativity.json").then (expected) ->
              assertSame [result, also, expected],
                parse: true
                fixFloats: true


  # Consistency

  describe '{*}` re-run with the extra [0]["re"]', ->
    results = []
    before (done) ->
      beginning = "#{precious} f test/io/for/nativity.json"
      mapExec [
        "#{beginning} | #{jsontool0}"
        "#{beginning} | #{jsontool} 0 | #{jsontool} re | #{jsontool0}
        | bin/precious.js - | #{jsontool0}"
        ], (err, stdouts) ->
          for result in stdouts
            results.push json.parse result
            # Properties get reordered for some reason.
            delete results[results.length-1]["0"]["re"]
          done()

    it "yields the same results", ->
      assertSame [results[0], results[1]]

