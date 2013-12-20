Lab = require 'lab'
# Config module
configs  = require '../../lib/config/index'
server = require '../../lib/server'
authentication  = require '../../lib/authentication'
routes = require '../../lib/routes'

# Test shortcuts
expect = Lab.expect
before = Lab.before
after = Lab.after
describe = Lab.experiment
it = Lab.test

describe "/users/", ->
    it "returns an error when requested without auth", (done) ->
        hapiServer = server(configs.server)
        hapiServer = hapiServer.server
        authModuleError = authentication(hapiServer, configs.authentication)
        expect(authModuleError).to.equal undefined
        hapiServer.addRoutes routes

        hapiServer.inject "/users/", (res) ->
            #console.log 'res: ', res
            expect(res.statusCode).to.equal 401
            expect(res.result.err).to.equal 'unauthenticated'
            done()


describe "/questions/", ->
    it "returns questions object", (done) ->

        hapiServer = server(configs.server)
        hapiServer = hapiServer.server
        authModuleError = authentication(hapiServer, configs.authentication)
        hapiServer.addRoutes routes

        hapiServer.inject "/questions/", (res) ->
            #console.log 'res: ', res
            expect(res.statusCode).to.equal 200
            expect(res.result.questions[0].Q).to.equal 'Did you eat food?'
            expect(res.result.questions[1].Q).to.equal 'Was it mostly plants?'
            done()

