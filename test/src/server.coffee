Lab = require 'lab'
Hapi = require 'hapi'
http = require 'http'
# Config module
configs  = require '../../lib/config/index'
server = require '../../lib/server'
utils = require '../../lib/utilities'
authentication  = require '../../lib/authentication'
routes = require '../../lib/routes'
# Test shortcuts
expect = Lab.expect
before = Lab.before
after = Lab.after
describe = Lab.experiment
it = Lab.test

# Initialization
describe 'Server', ->
    it 'thorws error if missing host configuration ' , (done) ->
        hapiServer = undefined
        tempServerConfig = Hapi.utils.removeKeys configs.server, 'host'
        expect( ->
            hapiServer = server(tempServerConfig)
        ).to.throw 'Server module: Invalid configuration object'
        done()

    it 'thorws error if missing port configuration ' , (done) ->
        hapiServer = undefined
        tempServerConfig = Hapi.utils.removeKeys configs.server, 'port'
        expect( ->
            hapiServer = server(tempServerConfig)
        ).to.throw 'Server module: Invalid configuration object'
        done()

    it 'thorws error if missing plugins configuration ' , (done) ->
        hapiServer = undefined
        tempServerConfig = Hapi.utils.removeKeys configs.server, 'plugins'
        expect( ->
            hapiServer = server(tempServerConfig)
        ).to.throw 'Server module: Invalid configuration object'
        done()

    it 'returns server if valid configuration ' , (done) ->
        hapiServer = server(configs.server)
        expect(hapiServer).to.exist
        done()

    ###
    dispatch = (req, res) ->
          reply = 'Hello World';

          res.writeHead 200,
            'Content-Type': 'text/plain'
            'Content-Length': reply.length

          res.end reply

    server = Http.createServer dispatch
    ###
