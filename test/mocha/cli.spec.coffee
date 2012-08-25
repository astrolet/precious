doMatch = require "../helpers/matches_async"
proExec = require "../helpers/promise_exec"
require("mocha-as-promised")()


describe "$ `precious", ->

  matches = {}
  before (done) ->
    doMatch.on "data", (data) -> matches = data
    doMatch.on "ready", -> done()

  describe "` by itself, with no arguments", ->
    it "returns `man precious`", ->
      (proExec "precious").then (result) ->
        result.should.eql matches.man.precious1

  describe "?`, short for help", ->
    it "is same as `man precious-readme`", ->
      (proExec "precious ?").then (result) ->
        result.should.eql matches.man.readme7

  describe "help`", ->
    it "is same as `man precious-readme`", ->
      (proExec "precious help").then (result) ->
        result.should.eql matches.man.readme7

  describe "help json`", ->
    it "is `man precious-json`", ->
      (proExec "precious help json").then (result) ->
        result.should.eql matches.man.json7

