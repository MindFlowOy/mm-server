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

# Add Authetication
if configs.authentication
    authentication(hapiServer, configs.authentication)

# Stack trace for dev time
if utils.isDevelopment()
    hapiServer.on 'log', (event, tags) ->
        if tags.error
            console.error event
        else
            console.log event


# Add server routes
hapiServer.addRoutes routes

# Start server
hapiServer.start ->
    hapiServer.log ['init'], "server started #{hapiServer.info.uri}"

# Add Swagger for API documentation
swaggerError = swagger(hapiServer, configs.server)
if swaggerError
    throw (swaggerError)


