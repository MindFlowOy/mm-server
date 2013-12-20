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

        # Insert session and passport etc 'default' hapi pluginConfigs
        pluginConfigs = config.plugins

        # Travelogue uses same infromation that already exist in config
        if pluginConfigs['travelogue-fork']
            pluginConfigs['travelogue-fork'] = config

        serverInst.pack.allow(ext: true).require pluginConfigs, (err) ->
            if err
                retVal.error = (err or "Server module: Unexpected error! (hapi.pluginConfigs)")
            else
                retVal.server = serverInst

    else
        retVal.error = "Server module: Invalid configuration object"


    retVal
