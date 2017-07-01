Promise = require 'bluebird'

module.exports = (req, res) ->
  sails.services.crud
    .find req
    .then res.ok
    .catch res.serverError
