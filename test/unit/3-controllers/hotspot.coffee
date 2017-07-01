env = require '../../env.coffee'
req = require 'supertest-as-promised'
Promise = require 'bluebird'

describe 'HotspotController', ->

  id = null
  token = null

  before ->
    oauth2 = sails.config.oauth2
    sails.services.oauth2
      .token oauth2.tokenUrl, env.client, env.user, oauth2.scope
      .then (t) ->
        token = t

  describe 'hotspot', ->
    it 'create record', ->
      req sails.hooks.http.app
        .post('/api/hotspot')
        .set 'Authorization', "Bearer #{token}"
        .send
          name: 'testing'
          lat: 25.043965
          lng: 121.519581
        .expect 201
        .then (res) ->
          id = res.body.id

    it 'list records', ->
      req sails.hooks.http.app
        .get('/api/hotspot')
        .expect 200

    it 'update record', ->
      req sails.hooks.http.app
        .put "/api/hotspot/#{id}"
        .send
          name: 'testing amend'
        .set 'Authorization', "Bearer #{token}"
        .expect 200
        .then (res) ->
          if res.body.name != 'testing amend'
            return Promise.reject "update failed"

    it 'delete record', ->
      req sails.hooks.http.app
        .del "/api/hotspot/#{id}"
        .set 'Authorization', "Bearer #{token}"
        .expect 200
