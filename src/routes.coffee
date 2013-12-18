"use strict"

###
* ---
* Routes module
* @name routes
* @api public
###

# Package information
pack = require '../package'
# Utils module
utils = require('./utilities')
# Hapi types for validation
Types = require('hapi').types



apiHandler = (request) ->
    utils.getMarkDownHTML __dirname.replace('/lib', '') + '/README.md', (err, data) ->
        request.reply.view 'swagger.html',
            title: pack.name
            markdown: data


module.exports = [

    method: 'GET'
    path: '/home'
    config:
        auth: 'passport'
        handler: (request) ->
            request.reply 'ACCESS GRANTED<br/><br/>'

,
    method: 'GET'
    path: '/'
    config:
        handler: apiHandler

,
    method: 'GET'
    path: '/api/{path*}'
    handler:
        directory:
            path: './public'
            listing: false
            index: true


]
