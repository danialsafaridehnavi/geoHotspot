_ = require 'lodash'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
  find: (req, res) ->
    box = [
      [parseFloat(req.query.west), parseFloat(req.query.south)]
      [parseFloat(req.query.east), parseFloat(req.query.north)]
    ]
    req.query = _.omit req.query, 'east', 'south', 'west', 'north'
    where = actionUtil.parseCriteria req
    skip = actionUtil.parseSkip req
    limit = actionUtil.parseLimit req
    sails.models.hotspot
      .findByBox box, where, skip, limit
      .then res.ok
      .catch res.serverError
