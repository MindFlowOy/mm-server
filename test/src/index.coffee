Lab = require 'lab'
# Config module
configs  = require '../../lib/config/index'
server = require '../../lib/server'
utils = require '../../lib/utilities'
authentication  = require '../../lib/authentication'
routes = require '../../lib/routes'
_ = require 'lodash'

# Test shortcuts
expect = Lab.expect
before = Lab.before
after = Lab.after
describe = Lab.experiment
it = Lab.test

describe 'Utils isDevelopment', ->
    it 'should return false' , (done) ->
        expect(utils.isDevelopment()).to.be.false
        done()

describe 'Utils getMarkDownHTML', ->
    html = undefined
    before (done)->
        utils.getMarkDownHTML 'API.md', (err, data)->
            expect(err).to.not.exist
            html = data
            done()

    it 'should convert API.md to HTML' , (done) ->
        console.log 'HTML ',html
        expect(html).to.have.string('<h1 id="mirrormonkey-api">')
        done()


describe 'Server', ->
    it 'thorws error if missing host configuration ' , (done) ->
        hapiServer = undefined
        tempServerConfig = _.omit configs.server, 'host'
        expect( ->
            hapiServer = server(tempServerConfig)
        ).to.throw 'Server module: Invalid configuration object'
        done()

    it 'thorws error if missing port configuration ' , (done) ->
        hapiServer = undefined
        tempServerConfig = _.omit configs.server, 'port'
        expect( ->
            hapiServer = server(tempServerConfig)
        ).to.throw 'Server module: Invalid configuration object'
        done()

    it 'thorws error if missing plugins configuration ' , (done) ->
        hapiServer = undefined
        tempServerConfig = _.omit configs.server, 'plugins'
        expect( ->
            hapiServer = server(tempServerConfig)
        ).to.throw 'Server module: Invalid configuration object'
        done()

    it 'returns server if valid configuration ' , (done) ->
        hapiServer = server(configs.server)
        expect(hapiServer).to.exist
        done()


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
