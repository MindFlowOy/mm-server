// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  /*
  * ---
  *   Utilities module
  *   @name utilities
  *   @api public
  */

  var envType, fs, marked;

  marked = require("marked");

  fs = require("fs");

  envType = require('./config/constants').envType;

  module.exports = {
    /*
    * Helper to get Markdown file as HTML
    * @param {string} path - markup file path
    * @param {function(err,string)} callback - Callback method
    */

    getMarkDownHTML: function(path, callback) {
      return fs.readFile(path, "utf8", function(err, data) {
        if (!err) {
          marked.setOptions({
            gfm: true,
            tables: true,
            breaks: false,
            pedantic: false,
            sanitize: true,
            smartLists: true,
            smartypants: false,
            langPrefix: "language-",
            highlight: function(code, lang) {
              return code;
            }
          });
          data = marked(data);
        }
        return callback(err, data);
      });
    },
    /*
    * Helper to generate ID
    * @return {string} ID as a string
    */

    generateID: function() {
      return ("0000" + (Math.random() * Math.pow(36, 4) << 0).toString(36)).substr(-4);
    },
    /*
    *  env variable
    * @type {String}
    */

    env: process.env.NODE_ENV || envType.DEVELOPMET,
    /*
    *  Test is development environment
    * @return {boolean}
    */

    isDevelopment: function() {
      return process.env.NODE_ENV === envType.DEVELOPMET;
    }
  };

}).call(this);