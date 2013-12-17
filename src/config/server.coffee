"use strict"

###
* ---
*
* @name config/server
* @api public
###

envType = require('./constants').envType

conf =
    ###
    * Server url
    * @method url
    * @param {string} env - current environment: should be development | production | devtest
    * @return {string} URL of the server
    * @api public
    ###
    url: (env) ->
        console.log "Getting url ", env
        currentConf = @[env]
        "#{ currentConf.protocoll }://#{ currentConf.host }:#{ currentConf.port }/"


###
* Server development configuration
* @name development
* @api public
###
conf[envType.DEVELOPMET] =
    protocoll: 'http'
    host: 'localhost'
    port: 8000
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

            partialsPath: __dirname.replace('/bin', '') + '/../../templates/withPartials'
            helpersPath: __dirname.replace('/bin', '') + '/../../templates/helpers'
            isCached: false

        cors: true

    excludePaths: [ '/docs/' ]

###
* Server production configuration
* @name production
* @api public
###
conf[envType.PRODUCTION] =
    protocoll: 'https'
    host: 'www.mirrormonkey.com'
    port: 3000
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

            partialsPath: __dirname.replace('/bin', '') + '/../templates/withPartials'
            helpersPath: __dirname.replace('/bin', '') + '/../templates/helpers'
            isCached: false

        cors: true

    excludePaths: [ '/docs/' ]



module.exports = conf
