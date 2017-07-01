_ = require 'lodash'
passport = require 'passport'
bearer = require 'passport-http-bearer'

passport.use 'bearer', new bearer.Strategy {} , (token, done) ->
  oauth2 = sails.config.oauth2
  sails.services.oauth2
    .verify oauth2.verifyUrl, oauth2.scope, token
    .then (info) ->
      sails.models.user
        .findOrCreate _.pick(info.user, 'email')
        .populateAll()
    .then (user) ->
      sails.log.debug user
      done null, user
    .catch (err) ->
      sails.log.debug err
      done null, false, message: err

module.exports = (req, res, next) ->
  middleware = passport.authenticate('bearer', { session: false } )
  middleware req, res, ->
    next()
