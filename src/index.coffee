"use strict"

###
* ---
*   Server Main
*   @name ndex
*   @api public
###

pack = require '../package'
Hapi = require 'hapi'
utils = require './utilities'
configs  = require('./config')


###
*  Environment variable
* @type {string}
###
env = process.env.NODE_ENV or configs.envType.DEVELOPMET


###
*  Server configurations based on environment variable
* @type {Object.<string, string|number>}
###
serverConfigs = configs.server[env]

###
*  Authentication configurations based on environment variable
* @type {Object.<string, string|number>}
###
authConfigs = configs.authentication[env]

console.log 'configs.authentication ', configs.authentication
console.log 'authConfigs ', authConfigs

# Insert session and passport etc 'default' plugins
plugins =
    yar:
        ttl: 2 * 24 * 60 * 60 * 1000
        cookieOptions:
            password: 'mindsecretflow'
            isSecure: false

    travelogue: serverConfigs

server = new Hapi.Server(serverConfigs.hostname, serverConfigs.port, serverConfigs.options)
server.pack.allow(ext: true).require plugins, (err) ->
    throw err  if err

# MindFlow Authetication plugin
authConfigs.passport = server.plugins.travelogue.passport
server.pack.allow(ext: true).require('mf-auth-api', authConfigs, (err) ->
    if not err and err isnt null
        console.log [ 'error' ], 'mf-auth-api\' load error: ' + err
    else
        console.log [ 'start' ], 'mf-auth-api interface loaded'
)

# Stack trace for dev time
if env is configs.envType.DEVELOPMET
    server.on 'internalError', (event) ->
        console.log 'INTERNAL ERROR'
        console.log event

# Add server routes
server.addRoute
    method: 'GET'
    path: '/home'
    config:
        auth: 'passport'
        handler: (request) ->
            request.reply 'ACCESS GRANTED<br/><br/><a href="/aa/session">Logout</a>'

apiHandler = (request) ->
    utils.getMarkDownHTML __dirname.replace('/lib', '') + '/README.md', (err, data) ->
        request.reply.view 'swagger.html',
            title: pack.name
            markdown: data

server.addRoute
    method: 'GET'
    path: '/'
    config:
        handler: apiHandler

server.addRoute
    method: 'GET'
    path: '/api/{path*}'
    handler:
        directory:
            path: './public'
            listing: false
            index: true

# Start server
server.start ->
    console.log 'server started ', server.info.uri

# Add Swagger plugin
swaggerOptions =
    basePath: configs.server.url(env)
    apiVersion: pack.version

server.pack.allow(ext: true).require('hapi-swagger', swaggerOptions, (err) ->
    if err
        console.log '[ error ], plugin swagger load error: ', err
    else
        console.log '[ start ], swagger interface loaded!'
)
