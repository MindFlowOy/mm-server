"use strict"

###
* ---
*   Server Main
*   @name index
*   @api public
###

# Package information
pack = require '../package'
# Utils module
utils = require './utilities'
# Config module
configs  = require('./config')
# Server module
server  = require('./server')
# Routes module
routes  = require('./routes')


# New hapi server based on configs
hapiServer = server(configs.server)

if not hapiServer.server or hapiServer.error
    throw (hapiServer.server || '[ error ] Index: Unexpected error!' );

hapiServer = hapiServer.server

# MindFlow Authetication plugin
configs.authentication.passport = hapiServer.plugins.travelogue.passport
hapiServer.pack.allow(ext: true).require('mf-auth-api', configs.authentication, (err) ->
    if err
        console.error '[ error ] Index: plugin mf-auth-api load error: ', err
    else
        console.log '[ start ] mf-auth-api plugin loaded'
)


# Stack trace for dev time
if utils.isDevelopment
    hapiServer.on 'internalError', (event) ->
        console.error '[ error ] Index: Internal error!'
        console.error event

# Add server routes
hapiServer.addRoutes routes

# Start server
hapiServer.start ->
    console.log 'server started ', hapiServer.info.uri

# Add Swagger plugin
swaggerOptions =
    basePath: configs.server.url
    constth: configs.server.url
    apiVersion: pack.version

hapiServer.pack.allow(ext: true).require('hapi-swagger', swaggerOptions, (err) ->
    if err
        console.error '[ error ] Index: plugin swagger load error: ', err
    else
        console.log '[ start ] swagger plugin loaded'
)
