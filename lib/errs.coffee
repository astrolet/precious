util = require 'util'
errs = require 'errs'

ephemerisError = ->
  @name = "Ephemeris Error"
util.inherits ephemerisError, Error
errs.register 'ephemeris', ephemerisError

module.exports = errs

