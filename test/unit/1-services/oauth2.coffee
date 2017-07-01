env = require '../../env.coffee'

describe 'OAuth2 Services', ->

  oauth2 = null
  token = null

  before ->
    oauth2 = sails.config.oauth2

  describe 'token', ->
    it 'request',  ->
      sails.services.oauth2
        .token oauth2.tokenUrl, env.client, env.user, oauth2.scope
        .then (t) ->
          token = t

    it 'verify', ->
      sails.services.oauth2
        .verify oauth2.verifyUrl, oauth2.scope, token
        .then sails.log.debug
