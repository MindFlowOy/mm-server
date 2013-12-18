"use strict"

###
* ---
*
* @name config/index
* @api public
###

env = require('../utilities').env
serverConf = require('./server')
authConf = require('./authentication')


module.exports =
    server: serverConf[env]
    authentication: authConf[env]
