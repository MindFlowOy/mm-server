"use strict"

###
* ---
*   Authentication module
*   @name authentication
*   @api public
###

Hapi = require 'hapi'

exports = module.exports = (hapiServer, config) ->

    retVal = undefined

    if config and hapiServer?.plugins?['travelogue-fork']?.passport

        config.passport = hapiServer.plugins['travelogue-fork'].passport

        hapiServer.pack.allow(ext: true).require('mf-auth-api', config, (err) ->
            if err
                retVal =  '[ error ] Athentication: plugin mf-auth-api load error: ' + err
            else
                console.log '[ start ] mf-auth-api plugin loaded'
        )

    else
        retVal = '[ error ]  Athentication: Invalid configuration object'

    retVal
