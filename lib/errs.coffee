util = require 'util'
errs = require 'errs'

ephemerisError = ->
  @name = "Ephemeris Error"
util.inherits ephemerisError, Error
errs.register 'ephemeris', ephemerisError

preciousError = ->
  @name = "Precious Error"
util.inherits preciousError, Error
errs.register 'precious', preciousError

module.exports = errs

