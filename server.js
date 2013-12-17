var pack = require('./package');
var Hapi = require('hapi');
var utils  = require('./utilities.js');

HTTP_PORT = 8001;
HTTP_DOMAIN =  'localhost';
HTTP_PROTOCOL = 'http';

var config = {
    hostname: HTTP_DOMAIN,
    port: HTTP_PORT,
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

var server = new Hapi.Server(config.hostname, config.port, config.options);
server.pack.allow({ ext: true }).require(plugins, function (err) {

    if (err) {
        throw err;
    }
});


// adds authentication plugin
var authConfig = {
    passport: server.plugins.travelogue.passport,
    urls: {
        successRedirect:  null,
        failureRedirect: null
    },
    google: {
            realm: HTTP_PROTOCOL + '://' + HTTP_DOMAIN + ':' + HTTP_PORT + '/',
            returnURL: HTTP_PROTOCOL + '://' + HTTP_DOMAIN + ':' + HTTP_PORT + '/auth/google/return'
    }
}
server.pack.allow({ ext: true }).require('mf-auth-api', authConfig, function (err) {
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


//SWAGGER Routes
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


server.start(function () {
    console.log('server started ' , server.info.uri);
});



// setup swagger options
var swaggerOptions = {
    basePath: HTTP_PROTOCOL + '://' + HTTP_DOMAIN + ':' + HTTP_PORT,
    apiVersion: pack.version
};

// adds swagger self documentation plugin
server.pack.allow({ ext: true }).require('hapi-swagger', swaggerOptions, function (err) {
    if (!err && err !== null) {
        console.log(['error'], 'plugin "hapi-swagger" load error: ' + err)
    }else{
        console.log(['start'], 'swagger interface loaded')
    }
});

