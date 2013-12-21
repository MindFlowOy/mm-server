
/* For Nodetime
var hostname      = require('os').hostname();
var processNumber = process.env.INDEX_OF_PROCESS || 0;

var APPLICATION_NAME = {}
APPLICATION_NAME.qa = "MindFlow QA";
APPLICATION_NAME.production = "MindFlow Production";

var options = {
  // time in ms when the event loop is considered blocked
  blockThreshold: 10
};

if (process.env.NODETIME_ACCOUNT_KEY) {
  require('nodetime').profile({
    accountKey: process.env.NODETIME_ACCOUNT_KEY,
    appName: APPLICATION_NAME[process.env.SS_ENV]
  });
}

*/
if (process.env.NODE_ENV === 'development') {
    console.log("Starting /src/index.coffee");
    require('coffee-script'), require('./src/index.coffee');
} else {
    console.log('Starting /lib/index.js')
    require('./lib/index.js')
}

