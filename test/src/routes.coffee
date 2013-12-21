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


describe '/users/', ->
    it 'returns an error when requested without auth', (done) ->
        hapiServer = server(configs.server)
        authModuleError = authentication(hapiServer, configs.authentication)
        expect(authModuleError).to.equal undefined
        hapiServer.addRoutes routes

        hapiServer.inject '/users/', (res) ->
            expect(res.statusCode).to.equal 401
            expect(res.result.err).to.equal 'unauthenticated'
            done()

    it 'returns user when requested with auth', (done) ->
        body =
            username: 'MindFlow'
            password: 'test'

        request =
            method: 'POST',
            url: '/aa/session',
            payload: JSON.stringify(body)


        hapiServer = server(configs.server)
        authModuleError = authentication(hapiServer, configs.authentication)
        expect(authModuleError).to.equal undefined
        hapiServer.addRoutes routes

        hapiServer.inject request, (res) ->
            header = res.headers["set-cookie"]
            expect(header).to.exist
            cookie = header[0].match(/(session=[^\x00-\x20\"\,\;\\\x7F]*)/)
            expect(res.statusCode).to.equal 200
            request2 =
                method: "GET"
                url: '/users/'
                headers:
                    cookie: cookie[1]

            hapiServer.inject request2, (res) ->
                expect(res.result.username).to.equal "MindFlow"
                done()

describe '/questions/', ->
    it 'returns questions object', (done) ->

        hapiServer = server(configs.server)
        authModuleError = authentication(hapiServer, configs.authentication)
        hapiServer.addRoutes routes

        hapiServer.inject '/questions/', (res) ->
            expect(res.statusCode).to.equal 200
            expect(res.result.questions[0].Q).to.equal 'Did you eat food?'
            expect(res.result.questions[1].Q).to.equal 'Was it mostly plants?'
            done()

describe '/', ->
    it 'returns API documentation', (done) ->

        hapiServer = server(configs.server)
        authModuleError = authentication(hapiServer, configs.authentication)
        hapiServer.addRoutes routes

        hapiServer.inject '/', (res) ->
            expect(res.statusCode).to.equal 200
            expect(res.payload).to.have.string('<a href="/">MirrorMonkey-api</a>')
            done()
