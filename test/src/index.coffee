Lab = require 'lab'
# Config module
configs  = require '../../lib/config/index'
server = require '../../lib/server'
authentication  = require '../../lib/authentication'
routes = require '../../lib/routes'
#mm = require '../../lib/'

# Test shortcuts
expect = Lab.expect
before = Lab.before
after = Lab.after
describe = Lab.experiment
it = Lab.test

describe "Boom", ->
    it "returns an login redirect when constructed without auth", (done) ->
        #expect(1 + 1).to.equal 3

        hapiServer = server(configs.server)
        hapiServer = hapiServer.server
        # Add server routes
        hapiServer.addRoutes routes

        hapiServer.inject "/home", (res) ->
            #console.log 'res: ', res
            expect(res.statusCode).to.equal 302
            expect(res.headers.location).to.equal 'http://127.0.0.1:3333/login'
            done()


describe "Boom", ->
    it "returns an error with info when constructed using another error", (done) ->
        #expect(1 + 1).to.equal 3

        hapiServer = server(configs.server)
        hapiServer = hapiServer.server

        authModuleError = authentication(hapiServer, configs.authentication)
        expect(authModuleError).to.equal undefined
        # Add server routes
        hapiServer.addRoutes routes

        hapiServer.inject "/home", (res) ->
            console.log 'res: ', res
            expect(res.statusCode).to.equal 302
            expect(res.headers.location).to.equal 'http://127.0.0.1:3333/login'
            done()

