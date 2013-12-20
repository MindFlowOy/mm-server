"use strict"

###
* ---
*   Utilities module
*   @name utilities
*   @api public
###

marked = require("marked")
fs = require("fs")

# Constants
envType  = require('./config/constants').envType

module.exports =
    ###
    * Helper to get Markdown file as HTML
    * @param {string} path - markup file path
    * @param {function(err,string)} callback - Callback method
    ###
    getMarkDownHTML: (path, callback) ->
        fs.readFile path, "utf8", (err, data) ->
            unless err
                marked.setOptions
                    gfm: true
                    tables: true
                    breaks: false
                    pedantic: false
                    sanitize: true
                    smartLists: true
                    smartypants: false
                    langPrefix: "language-"
                    highlight: (code, lang) ->
                        code

                data = marked(data)
            callback err, data



    ###
    *  env variable that defaults to 'development'
    * @type {String}
    ###
    env: process.env.NODE_ENV or envType.DEVELOPMET

    ###
    *  Test is development environment
    * @return {boolean}
    ###
    isDevelopment: ->
        process.env.NODE_ENV is envType.DEVELOPMET
