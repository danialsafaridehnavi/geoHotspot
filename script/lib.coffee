fs = require 'fs'
config = JSON.parse fs.readFileSync './.sailsrc'
Sails = require 'sails'
Promise = require 'promise'

module.exports =
  sailsReady: new Promise (resolve, reject) ->
    Sails.lift config, (err, sails) ->
      if err
        return reject err
      resolve sails
