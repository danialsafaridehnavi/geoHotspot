_ = require 'lodash'
Promise = require 'bluebird'

module.exports =
  bootstrap: (cb) ->
    _.map sails.models, (model, key) ->
      sails.models[key] = Promise.promisifyAll sails.models[key]

    sails.models.hotspot
      .nativeAsync()
      .then (hotspot) ->
        Promise
          .promisify hotspot.ensureIndex
          .call hotspot, coordinates: '2dsphere'
      .then ->
        cb()
      .catch cb
