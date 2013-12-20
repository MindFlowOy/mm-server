"use strict"

###
* ---
*   Authentication module
*   @name authentication
*   @api public
###

Hapi = require 'hapi'

exports = module.exports = (hapiServer, config) ->

    Hapi.utils.assert hapiServer?.plugins?['travelogue-fork']?.passport?, 'Athentication module: Passport plugin not found'
    Hapi.utils.assert config?, "Athentication module: Invalid configuration object #{config}"

    config.passport = hapiServer.plugins['travelogue-fork'].passport

    hapiServer.pack.allow(ext: true).require 'mf-auth-api', config, (err) ->
        Hapi.utils.assert not err, "Athentication module: #{err}"
        hapiServer.log ['init'], 'Athentication module: mf-auth-api plugin loaded'
