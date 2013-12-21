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

aaBody =
    username: 'MindFlow'
    password: 'test'

aaRequest =
    method: 'POST',
    url: '/aa/session',
    payload: JSON.stringify(aaBody)

userRequest =
    method: "GET"
    url: '/users/'
    headers: {}

questionBody =
    question: 'Did you eat food?'
    answer: 'Y'

questionRequest =
    method: 'POST',
    url: '/questions/food',
    payload: JSON.stringify(questionBody)
    headers: {}

describe '/users/', ->
    it 'GET returns an error when requested without auth', (done) ->
        hapiServer = server(configs.server)
        authModuleError = authentication(hapiServer, configs.authentication)
        expect(authModuleError).to.equal undefined
        hapiServer.addRoutes routes

        hapiServer.inject '/users/', (res) ->
            expect(res.statusCode).to.equal 401
            expect(res.result.err).to.equal 'unauthenticated'
            done()

    it 'GET returns user when requested with auth', (done) ->

        hapiServer = server(configs.server)
        authentication(hapiServer, configs.authentication)
        hapiServer.addRoutes routes

        hapiServer.inject aaRequest, (res) ->
            header = res.headers["set-cookie"]
            expect(header).to.exist
            cookie = header[0].match(/(session=[^\x00-\x20\"\,\;\\\x7F]*)/)[1]
            userRequest.headers.cookie = cookie
            expect(res.statusCode).to.equal 200
            hapiServer.inject userRequest, (res) ->
                expect(res.result.username).to.equal "MindFlow"
                done()

describe '/questions/food', ->
    it 'GET returns questions object', (done) ->

        hapiServer = server(configs.server)
        authentication(hapiServer, configs.authentication)
        hapiServer.addRoutes routes


        hapiServer.inject '/questions/food', (res) ->
            expect(res.statusCode).to.equal 200
            expect(res.result.questions[0].Q).to.equal 'Did you eat food?'
            expect(res.result.questions[1].Q).to.equal 'Was it mostly plants?'
            done()

     it 'POST saves questions reply', (done) ->

        hapiServer = server(configs.server)
        authModuleError = authentication(hapiServer, configs.authentication)
        hapiServer.addRoutes routes

        hapiServer.inject aaRequest, (res) ->
            header = res.headers["set-cookie"]
            expect(header).to.exist
            cookie = header[0].match(/(session=[^\x00-\x20\"\,\;\\\x7F]*)/)[1]
            questionRequest.headers.cookie = cookie
            expect(res.statusCode).to.equal 200
            hapiServer.inject questionRequest, (res) ->
                expect(res.result.question).to.equal 1
                done()

describe '/ (root)', ->
    it 'GET returns API documentation', (done) ->

        hapiServer = server(configs.server)
        authModuleError = authentication(hapiServer, configs.authentication)
        hapiServer.addRoutes routes

        hapiServer.inject '/', (res) ->
            expect(res.statusCode).to.equal 200
            expect(res.payload).to.have.string('<a href="/">MirrorMonkey-api</a>')
            done()
