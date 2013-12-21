Lab = require 'lab'
Shot = require 'shot'
Hapi = require 'hapi'

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
        expect(html).to.have.string('<h1 id="mirrormonkey-api">')
        done()
