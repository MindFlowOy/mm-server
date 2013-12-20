"use strict"

###
* ---
*   Server module
*   @name server
*   @api public
###

Hapi = require 'hapi'

exports = module.exports = (config) ->


    validConf = config?.host? and config.port? and config.options? and config.plugins?

    Hapi.utils.assert validConf, "Server module: Invalid configuration object: #{config}"

    # New hapi server based on configs
    serverInst = new Hapi.Server(config.host, config.port, config.options)

    # Insert session and passport etc 'default' hapi pluginConfigs
    pluginConfigs = config.plugins

    # Travelogue uses same infromation that already exist in config
    if pluginConfigs['travelogue-fork']
        pluginConfigs['travelogue-fork'] = config

    serverInst.pack.allow(ext: true).require pluginConfigs, (err) ->
        Hapi.utils.assert not err, "Server module: #{err}"

    serverInst


