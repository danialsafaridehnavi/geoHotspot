config = require './config.json'

module.exports =
  rootUrl: config.ROOTURL
  oauth2:
    authUrl: config.AUTHURL
    scope: config.SCOPE
  map:
    key: config.MAP_KEY
    pos:
      latitude: parseFloat config.LAT
      longitude: parseFloat config.LNG
    zoom: parseInt config.ZOOM
