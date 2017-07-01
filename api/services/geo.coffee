Promise = require 'promise'
querystring = require 'querystring'

module.exports =

  geoforward: (data) ->
    if _.isEmpty(data.location.coordinates) or _.isNull data.location.coordinates[1]
      @forward data.address
        .then (geo) ->
          data.location.coordinates[1] = parseFloat(geo.lat)
          data.location.coordinates[0] = parseFloat(geo.lon)
          return data
    else
      data.location.coordinates = [parseFloat(data.location.coordinates[0]), parseFloat(data.location.coordinates[1]) ]
      return Promise.resolve data

  reverse: (data) ->
    #sails.log 'reverse data='+JSON.stringify(data)
    url = sails.config.geo.url
    param =
      format:     'json'
      lat:     data.location.coordinates[1]
      lon:     data.location.coordinates[0]
      #email:    'openstreetmap@gmail.com'
    new Promise (resolve, reject) ->
        sails.services.rest().get "", "#{url}?#{querystring.stringify(param)}"
          .then (res) ->
            if res.body.error
              sails.log.error "reverse lookup #{JSON.stringify(data)} failed"
              resolve data
              #reject new Error("reverse lookup #{JSON.stringify(data)} failed")
            else
              data.address = res.body.display_name
              resolve data
          .catch reject
  # input:
  #  data:
  #    address:  string
  # output:
  #  promise to find latitude & longitude, if latitude & longitude not define
  forward: (address) ->
      url = sails.config.geo.addressUrl
      param =
        format:     'json'
        q:       address
        #email:    'openstreetmap@gmail.com'
      new Promise (resolve, reject) ->
        sails.services.rest().get "", "#{url}?#{querystring.stringify(param)}"
          .then (res) ->
            if res.body.length
              resolve _.pick res.body[0], 'lat', 'lon'
            else
              reject new Error "forward lookup #{address} failed"
