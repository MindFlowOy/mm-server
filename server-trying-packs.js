var pack = require('./package');
//var mfAuth = reguire('mf-auth-api');
var Hapi = require('hapi');
var pack = new Hapi.Pack();
var utils  = require('./utilities.js');

var config = {
    hostname: 'localhost',
    port: 8000,
    options: {
        state: {
            cookies: {
                clearInvalid: true
            }
        },
        timeout: {
            server: 50000,

        },
        labels: ['api'],
        views: {
            path: 'templates',
            engines: { html: 'handlebars' },
            partialsPath: __dirname.replace('/bin','') + '/templates/withPartials',
            helpersPath: __dirname.replace('/bin','') + '/templates/helpers',
            isCached: false
        },
        cors: true
    },
    urls: {
        successRedirect:  null,
        failureRedirect: null
    },
    google: {
            realm: "http://localhost:8000/",
            returnURL: "http://localhost:8000/auth/google/return"
    },
    excludePaths: ['/docs/']
};


var plugins = {
    yar: {
        ttl: 2*24 * 60 * 60 * 1000, // 2 day session
        cookieOptions: {
            password: "mindsecretflow",
            isSecure: false
        }
    },
    travelogue: config
}

pack.server(config.hostname, config.port, config.options);


pack.allow({ ext: true }).require(plugins, function (err) {
    if (err) {
        throw err;
    }
});

console.log("pack")
console.log(pack._servers[0].plugins.travelogue.passport)

// adds mind flow authentication plugin
pack.allow({ ext: true }).require('mf-auth-api', {Passport: pack._servers[0].plugins.travelogue.passport.Passport}, function (err) {
    if (!err && err !== null) {
        console.log(['error'], 'mf-auth-api" load error: ' + err)
    }else{
        console.log(['start'], 'mf-auth-api interface loaded')
    }
});




if (process.env.DEBUG) {
    server.on('internalError', function (event) {
        // Send to console
        console.log("INTERNAL ERROR");
        console.log(event);
    });
}


// addRoutes
/*

// this is not real route, but more like example
server.addRoute({
    method: 'GET',
    path: '/home',
    config: {
        auth: 'passport' ,
        handler: function (request) {
            // If logged in already, redirect to /home
            // else to /login
            request.reply("ACCESS GRANTED<br/><br/><a href='/aa/session'>Logout</a>");
        }
    }
});


function apiHandler(request) {
    utils.getMarkDownHTML(__dirname.replace('/lib','') + '/README.md', function(err, data){
        request.reply.view('swagger.html', {
            title: pack.name,
            markdown: data
        });
    });
}

server.addRoute({
    method: 'GET',
    path: '/',
    config: {
        handler: apiHandler
    }
});

server.addRoute({
        method: 'GET',
        path: '/api/{path*}',
        handler: {
            directory: {
                path: './public',
                listing: false,
                index: true
            }
        }
});
*/

pack.start(function () {
    console.log('server started');
});

// setup swagger options
var swaggerOptions = {
    basePath: 'http://localhost:8000',
    apiVersion: pack.version
};



// adds swagger self documentation plugin
pack.allow({ ext: true }).require('hapi-swagger', swaggerOptions, function (err) {
    if (!err && err !== null) {
        console.log(['error'], 'plugin "hapi-swagger" load error: ' + err)
    }else{
        console.log(['start'], 'swagger interface loaded')
    }
});

