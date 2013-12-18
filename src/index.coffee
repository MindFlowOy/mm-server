"use strict"

###
* ---
*   Server Index
*   @name index
*   @api public
###


# Utils module
utils = require './utilities'
# Config module
configs  = require './config'
# Server module
server  = require './server'
# Authentication module
authentication  = require './authentication'
# Routes module
routes  = require './routes'
# Swagger module
swagger  = require './swagger'

# New hapi server based on configs
hapiServer = server(configs.server)

if not hapiServer.server or hapiServer.error
    throw (hapiServer.error || '[ error ] index: Unexpected error!' );

hapiServer = hapiServer.server

# Add Authetication
if configs.authentication
    authModuleError = authentication(hapiServer, configs.authentication)
    if authModuleError
        throw (authModuleError)

# Stack trace for dev time
if utils.isDevelopment
    hapiServer.on 'internalError', (event) ->
        console.error '[ error ] index: Internal error!'
        console.error event

# Add server routes
hapiServer.addRoutes routes

# Start server
hapiServer.start ->
    console.log 'server started ', hapiServer.info.uri

# Add Swagger for API documentation
swaggerError = swagger(hapiServer, configs.server)
if swaggerError
    throw (swaggerError)


