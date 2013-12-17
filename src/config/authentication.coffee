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
            realm: serverConfigs.url(envType.DEVELOPMET)
            returnURL: serverConfigs.url(envType.DEVELOPMET) + 'auth/google/return'


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
            realm: serverConfigs.url(envType.PRODUCTION)
            returnURL: serverConfigs.url(envType.PRODUCTION) + 'auth/google/return'

module.exports = conf
