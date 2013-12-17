"use strict"

###
* ---
*
* @name config/index
* @api public
###

serverConf = require('./server')
authConf = require('./authentication')
envType = require('./constants').envType

module.exports =
    envType: envType
    server: serverConf
    authentication: authConf
