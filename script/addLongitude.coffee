#!/usr/bin/coffee

Sails = require 'sails'
stream = require 'stream'
Promise = require 'bluebird'
_ = require 'lodash'
lib = require './lib.coffee'
csv = require 'csv-parser'
querystring = require 'querystring'

errCount = 0

format = (data) ->
  ret = []
  _.each data, (value) ->
    ret.push "\"#{value}\""
  return ret.join ','

class GeoForward extends stream.Transform

  constructor: (opts = writableObjectMode: true) ->
    super opts
    @on 'pipe', (src) =>
      src.on 'headers', (header) =>
        @push "#{format ["name", "address", "info", "latitude", "longitude", "tags"]}\n"

  _transform: (data, encoding, cb) ->
    sails.services.geo.forward data.address
      .then (pos) =>
        @push format
          name:       data.name
          address:     data.address
          info:       data.info
          latitude:     pos.lat
          longitude:     pos.lon
          tags:       data.tags
        @push "\n"
      .catch (err) ->
        errCount++
        sails.log.error "#{errCount}. #{err}"
      .finally cb

lib.sailsReady
  .then (sails) ->
    new Promise (resolve, reject) ->
      process.stdin
        .pipe csv()
        .pipe new GeoForward()
        .on 'finish', ->
          sails.log.info 'convert data finish!'
          resolve()
        .pipe process.stdout
  .finally ->
    Sails.lower()
