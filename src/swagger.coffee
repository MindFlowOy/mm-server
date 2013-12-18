"use strict"

###
* ---
*   Swagger module
*   @name swagger
*   @api public
###

# Package information
pack = require '../package'

exports = module.exports = (hapiServer, config) ->

    retVal = undefined

    if config and hapiServer

        swaggerOptions =
            basePath: config.url
            constth: config.url
            apiVersion: pack.version

        hapiServer.pack.allow(ext: true).require('hapi-swagger', swaggerOptions, (err) ->
            if err
                retVal ='[ error ] Swagger: plugin swagger load error: ' + err
            else
                console.log '[ start ] swagger plugin loaded'
        )


    else
        retVal = '[ error ] Swagger : Invalid configuration object'

    retVal
