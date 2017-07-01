actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

# add criteria for tag
module.exports = (req, res, next) ->
  values = actionUtil.parseValues(req)
  name = values.name

  if ! _.isUndefined(name)
    cond =
      name: name

  req.options.criteria = req.options.criteria || {}
  req.options.criteria.blacklist = req.options.criteria.blacklist || ['limit', 'skip', 'sort', 'populate', 'to']
  req.options.where = req.options.where || {}
  _.extend req.options.where, cond

