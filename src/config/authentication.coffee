"use strict"

###
* ---
*
* @name config/suthentication
* @api public
###

envType = require('./constants').envType
serverConfigs= require('./server')

conf = {}

###
* Authentication configuration for development
* @name development
* @api public
###
conf[envType.DEVELOPMET] =
    authConfig =
        urls:
            successRedirect: null
            failureRedirect: null

        google:
            realm: serverConfigs[envType.DEVELOPMET].url
            returnURL: serverConfigs[envType.DEVELOPMET].url + 'auth/google/return'


###
* Authentication configuration for production
* @name development
* @api public
###
conf[envType.PRODUCTION] =
    authConfig =
        urls:
            successRedirect: null
            failureRedirect: null

        google:
            realm: serverConfigs[envType.PRODUCTION].url
            returnURL: serverConfigs[envType.PRODUCTION].url + 'auth/google/return'

module.exports = conf
