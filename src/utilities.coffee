"use strict"
marked = require("marked")
fs = require("fs")

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
    * Helper to generate ID
    * @return {string} ID as a string
    ###
    generateID: ->
        ("0000" + (Math.random() * Math.pow(36, 4) << 0).toString(36)).substr -4
