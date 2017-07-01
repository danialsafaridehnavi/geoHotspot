#!/usr/bin/coffee

Sails = require 'sails'
lib = require './lib.coffee'
Promise = require 'bluebird'
path = require 'path'
_ = require 'lodash'

if process.argv.length != 4
  console.log "usage: node_modules/.bin/coffee script/createHotspot.coffee $PWD/test/data/data.json email"
  process.exit 1

file = process.argv[2]
tag = path.parse(file).name
email = process.argv[3]

lib.sailsReady
  .then (sails) ->
    newUser = email: email
    newTag = name: tag
    Promise
      .all [
        sails.models.user.findOrCreate newUser, newUser
        sails.models.tag.findOrCreate newTag, newTag
      ]
      .then (res) ->
        user = res[0]
        data = require file
        Promise
          .map data, (loc) ->
            name: loc.name
            coordinates: [parseFloat(loc.lng), parseFloat(loc.lat)]
            extra: loc.extra
          .map (loc) ->
            _.extend loc,
              createdBy: email
              tag: [tag]
            sails.models.hotspot
              .create loc
              .then sails.log.debug
  .catch console.log
  .finally ->
    Sails.lower()
