ephemeris = require '../../bin/ephemeris'

describe "ephemeris", ->

  describe "without precious input", ->

    it "should fail, with some thrown error", ->
      ephemeris().should.throw()

