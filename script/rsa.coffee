_ = require 'lodash'
fs = require 'fs'

class RSA extends require 'node-rsa'
  constructor: (opts = b: 2048) ->
    super opts

  public: ->
    @exportKey 'public'

  private: ->
    @exportKey 'private'

  exportKeyFile: (format, path) ->
    out = fs.createWriteStream path
    out.write @exportKey format
    out.end()

  toString: ->
    JSON.stringify
      private: @private()
      public: @public()
      crt: @crt()

key = new RSA()
console.log JSON.stringify
  private: key.exportKey 'private'
  public: key.exportKey 'public'
