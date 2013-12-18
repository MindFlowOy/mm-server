"use strict"

###
* ---
*
* @name config/constants
* @api public
###


###
*  Environment types
* @enum {string}
* @type {string}
###
environmentType =
      DEVELOPMET: 'development'
      PRODUCTION: 'production'
      TEST: 'test'

module.exports =
    envType: environmentType

