fs = require 'fs'
Promise = require 'bluebird'
pem = Promise.promisifyAll require 'pem'

pem
  .createCertificateAsync
    days: 365
    selfSigned: true
  .then (keys) ->
    key = fs.createWriteStream 'config/env/ssl.key'
    key.write keys.serviceKey
    key.end()
    crt = fs.createWriteStream 'config/env/ssl.crt'
    crt.write keys.certificate
    crt.end()
