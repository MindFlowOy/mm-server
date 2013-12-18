"use strict"

###
* ---
*   Server module
*   @name server
*   @api public
###

Hapi = require 'hapi'

exports = module.exports = (config) ->

    retVal =
        server: undefined
        error: undefined

    if config.host and config.port and config.options and config.plugins

        # New hapi server based on configs
        serverInst = new Hapi.Server(config.host, config.port, config.options)

        # Insert session and passport etc 'default' hapi plugins
        plugins = config.plugins

        # Travelogue uses same infromation that already exist in config
        if plugins.travelogue
            plugins.travelogue = config

        serverInst.pack.allow(ext: true).require plugins, (err) ->
            if err
                retVal.error = (err or "Server module: Unexpected error! (hapi.plugins)")
            else
                retVal.server = serverInst

    else
        retVal.error = "Server module: Invalid configuration object"


    retVal
