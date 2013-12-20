"use strict"

###
* ---
*   Routes module
*   @name routes
*   @api public
###

# Package information
pack = require '../package'
# Utils module
utils = require './utilities'
# Hapi
Hapi = require 'hapi'
# Hapi types for validation
Types = require('hapi').types


apiHandler = (request) ->
    utils.getMarkDownHTML __dirname + '/../API.md', (err, data) ->
        request.reply.view 'swagger.html',
            title: pack.name
            markdown: data

# Helper to render json out to http stream
renderJSON = (request, error, result ) ->
    if error
        request.reply new Hapi.error(500, error)
    else
        request.reply(result).type 'application/json; charset=utf-8'

module.exports = [

    # Example of route requiring authentication
    method: 'GET'
    path: '/home'
    config:
        auth: 'passport'
        handler: (request) ->
            request.reply 'ACCESS GRANTED<br/><br/>'


,
    # Questions
    method: "GET"
    path: "/questions/"
    config:
        auth: false
        handler: (request) ->
            renderJSON request, null,
                questions: [
                    Q: "Did you eat food?"
                    Y: 1
                    N: 0
                ,
                    Q: "Was it mostly plants?"
                    Y: 1
                    N: -1
                ,
                    Q: "Was it 'not too much'?"
                    Y: -1
                    N: 1
                ]

        description: 'Get questions'
        notes: 'Lists questions'
        tags: ['api', 'questions']

,
    # User
    method: 'GET'
    path: '/users/'
    config:
        auth: 'passport'
        handler: (request) ->
            console.log 'Route: /users/ #{request.user}'
            renderJSON request, null, request.user

        description: 'Get user'
        notes: 'Get user data'
        tags: ['api', 'user']

,
    # API documentation root
    method: 'GET'
    path: '/'
    config:
        handler: apiHandler

,
    # API documentation resources
    method: 'GET'
    path: '/api/{path*}'
    handler:
        directory:
            path: './public'
            listing: false
            index: true

,
    # test coverage
    method: 'GET'
    path: '/test/{path*}'
    handler:
        directory:
            path: './test'
            listing: false
            index: true

]
