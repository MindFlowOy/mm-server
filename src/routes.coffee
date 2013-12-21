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


module.exports = [

    # Questions
    method: "GET"
    path: "/questions/"
    config:
        auth: false
        handler: (request) ->
            request.reply
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
    method: "POST"
    path: "/questions/"
    config:
        auth: true
        validate:
            query: {}
            payload:
                username: Hapi.types.String().required().description 'username'
                password: Hapi.types.String().required().description 'password'
        handler: (request) ->
            console.post "Request ", request

        description: 'Post question'
        notes: 'Save question and answer '
        tags: ['api', 'questions']

,
    # User route requiring authentication
    method: 'GET'
    path: '/users/'
    config:
        auth: 'passport'
        handler: (request) ->
            request.reply request.user
            #request.reply(request.user ).type 'application/json; charset=utf-8'

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
