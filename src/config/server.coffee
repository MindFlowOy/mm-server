"use strict"

###
* ---
*
* @name config/server
* @api public
###

envType = require('./constants').envType

conf = {}

###
* Server development configuration
* @name development
* @api public
###
conf[envType.DEVELOPMET] =
    # Keep in sync
    protocoll: 'http'
    host: 'localhost'
    port: 8000
    url : 'http://localhost:8000/'
    # Keep in sync ends

    options:
        state:
            cookies:
                clearInvalid: true

        timeout:
            server: 50000

        labels: [ 'api' ]
        views:
            path: 'templates'
            engines:
                html: 'handlebars'

            partialsPath: __dirname.replace('/src/config', '') + '/templates/withPartials'
            helpersPath: __dirname.replace('/src/config', '') + '/templates/helpers'
            isCached: false

        cors: true

    excludePaths: [ '/docs/' ]
    plugins:
        # Two days long sessions
        yar:
            ttl: 2 * 24 * 60 * 60 * 1000
            cookieOptions:
                password: 'mindsecretflow'
                isSecure: false

        travelogue: true

###
* Server production configuration
* @name production
* @api public
###
conf[envType.PRODUCTION] =

    # Keep in sync
    protocoll: 'http'
    host: '127.0.0.1'
    port: 3000
    url : 'http://127.0.0.1:3000/'
    # Keep in sync ends

    options:
        state:
            cookies:
                clearInvalid: true

        timeout:
            server: 50000

        labels: [ 'api' ]
        views:
            path: 'templates'
            engines:
                html: 'handlebars'

            partialsPath: __dirname.replace('/lib/config', '') + '/templates/withPartials'
            helpersPath: __dirname.replace('/lib/config', '') + '/templates/helpers'
            isCached: false

        cors: true

    excludePaths: [ '/docs/' ]
    plugins:
        # Two days long sessions
        yar:
            ttl: 2 * 24 * 60 * 60 * 1000
            cookieOptions:
                password: 'mindsecretflow'
                isSecure: false

        travelogue: true




module.exports = conf
