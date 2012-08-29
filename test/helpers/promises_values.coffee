Q = require "q"

module.exports = (promises..., callback) ->
  (Q.allResolved promises).then (promises) ->
    results = []
    for promise in promises
      if promise.isFulfilled()
        results.push promise.valueOf()
      else
        throw promise.valueOf().exception
    callback results

