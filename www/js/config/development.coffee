io.sails.url = 'https://mob.myvnc.com'
io.sails.path = "/hotspot/socket.io"
io.sails.useCORSRouteToGetCookie = false

module.exports =
  isMobile: ->
    /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
  isNative: ->
    /^file/i.test(document.URL)
  platform: ->
    if @isNative() then 'mobile' else 'browser'
  authUrl:   'https://mob.myvnc.com'

  serverUrl: (path = @path) ->
    "https://mob.myvnc.com/#{@path}"
  path: 'hotspot'
  server:
    rest:
      urlRoot:   'https://mob.myvnc.com/org'
    io:
      urlRoot:   'https://mob.myvnc.com/im.app'
  oauth2:
    opts:
      authUrl: "https://mob.myvnc.com/org/oauth2/authorize/"
      response_type:   "token"
      scope:       "https://mob.myvnc.com/org/users"
      client_id:     'util.auth.dev'
  map:
    coords:
      latitude:   22.36633475
      longitude:   114.08627915
    distance:   2
    zoom:   12
    labelAnchor:   "100 0"
  mapSize:
    height:   500

