_ = require 'lodash'
Promise = require 'bluebird'

module.exports =

  tableName: 'poi'

  schema: true

  attributes:

    name:
      type: 'string'
      required: true

    extra:
      type: 'json'
      defaultsTo: {}

    type:
      type: 'string'
      defaultsTo: 'Point'

    coordinates:
      type: 'json'
      required: true

    createdBy:
      model: 'user'
      required: true

    tag:
      collection: 'tag'
      via: 'hotspot'

  findByBox: (box, where = {}, skip = 0, limit = 10) ->
    @nativeAsync()
      .then (hotspot) =>
        center = [(box[0][0] + box[1][0]) / 2, (box[0][1] + box[1][1]) / 2]
        where = _.extend where,
          coordinates:
            $near: 
              $geometry:
                type: 'Point'
                coordinates: center
          coordinates:
            $geoWithin:
              $box: box
        hotspot = Promise.promisifyAll hotspot
        results = new Promise (resolve, reject) ->
          hotspot
            .find where, {id: true}
            .skip skip
            .limit limit
            .toArray (err, results) ->
              if err
                return reject err
              resolve results
       
        Promise
          .all [
            hotspot.countAsync where
            results
              .map (loc) ->
                loc._id
              .then (results) =>
                @findByIdIn results
                  .populateAll()
          ]
          .then (res) ->
            count: res[0]
            results: res[1]
