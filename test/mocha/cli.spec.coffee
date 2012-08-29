json    = require "jsonify"
mapExec = require "../helpers/map_exec"
doMatch = require "../helpers/async_man"
proExec = require "../helpers/promise_exec"
proVals = require "../helpers/promises_values"
assertSame = require "../helpers/assert_same"


# Paths to commands and data files.

precious = "bin/precious.js"
tis = "test/io/for/nativity.json"
its = "test/io/out/nativity.json"
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
      (proExec "#{precious} ?").then (shorthand) ->
        (proExec "#{precious} help").then (help) ->
          assertSame [shorthand, help, matches.man.readme7]

  describe "help json`", ->
    it "is `man precious-json`", ->
      (proExec "#{precious} help json").then (result) ->
        assertSame [result, matches.man.json7]


  # Stream

  describe "-`, being piped a stream of spec-conforming json", ->
    it "produces the expected output", ->
      proVals (proExec "cat #{tis} | #{precious} -")
            , (proExec "cat #{tis} | #{precious} stream")
            , (proExec "cat #{tis} | #{precious} s")
            , (proExec "cat #{its}")
            , (results) ->
              assertSame results,
                parse: true
                fixFloats: true


  # File

  describe "f[ile]`, given path to a spec-conforming json", ->
    it "produces the expected output", ->
      proVals (proExec "#{precious} f cat #{tis}")
            , (proExec "#{precious} file cat #{tis}")
            , (proExec "cat #{its}")
            , (results) ->
              assertSame results,
                parse: true
                fixFloats: true


  # Object
  describe "o[bject]`, given a spec-conforming json string", ->
    it "produces the expected output", ->
      (proExec "cat #{tis}").then (input) ->
        proVals (proExec "#{precious} o '#{input}'")
              , (proExec "#{precious} object '#{input}'")
              , (proExec "cat #{its}")
              , (results) ->
                assertSame results,
                  parse: true
                  fixFloats: true


  # Consistency

  describe '{*}` re-run with the extra [0]["re"]', ->
    results = []
    before (done) ->
      beginning = "#{precious} f #{tis}"
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

