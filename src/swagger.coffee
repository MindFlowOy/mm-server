"use strict"

###
* ---
*   Swagger module
*   @name swagger
*   @api public
###

Hapi = require 'hapi'

# Package information form package.json
pack = require '../package'

exports = module.exports = (hapiServer, config) ->

    retVal = undefined

    Hapi.utils.assert hapiServer, 'Swagger module: invalid server'
    Hapi.utils.assert config, 'Swagger module: Invalid configuration object'

    swaggerOptions =
        basePath: config.url
        constth: config.url
        apiVersion: pack.version

    hapiServer.pack.allow(ext: true).require 'hapi-swagger', swaggerOptions, (err) ->
        Hapi.utils.assert not err, "Swagger module: #{err}"
        hapiServer.log [ 'init' ], 'Swagger module: hapi-swagger plugin loaded'


