Lab = require("lab")
mm = require("../../lib")

# Test shortcuts
expect = Lab.expect
before = Lab.before
after = Lab.after
describe = Lab.experiment
it = Lab.test

describe "Boom", ->
  it "returns an error with info when constructed using another error", (done) ->
    expect(1 + 1).to.equal 3
    done()
