# build time tests for simplemcq plugin
# see http://mochajs.org/

simplemcq = require '../client/simplemcq'
expect = require 'expect.js'

describe 'simplemcq plugin', ->

  describe 'expand', ->

    it 'can make itallic', ->
      result = simplemcq.expand 'hello *world*'
      expect(result).to.be 'hello <i>world</i>'
