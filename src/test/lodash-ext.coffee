expect = require('expect.js')
_      = require('../lib/lodash-ext')

describe 'lodash extensions', ->
  describe '#joinURIComponents', ->
    it 'returns given string if passed a single URI component', (done) ->
      url = _.joinURIComponents('image.png')
      expect(url).to.be('image.png')
      done()

    it 'joins relative URI components', (done) ->
      url = _.joinURIComponents('/assets', 'large', 'image.png')
      expect(url).to.be('/assets/large/image.png')
      done()

    it 'joins URI components while preserving double slashes', (done) ->
      url = _.joinURIComponents('http://example.com', 'assets', 'images.png')
      expect(url).to.be('http://example.com/assets/images.png')
      done()

    it 'strips leading and trailing forward slashes in URI components', (done) ->
      url = _.joinURIComponents('http://example.com', '/assets/', '/images.png')
      expect(url).to.be('http://example.com/assets/images.png')
      done()

    it 'respects relative protocol URI components', (done) ->
      url = _.joinURIComponents('//example.com', '/assets/', '/images.png')
      expect(url).to.be('//example.com/assets/images.png')
      done()

  describe '#trim', ->
    it 'trims left and right whitespace by default', (done) ->
      trimmedWord = _.trim(' hello   ')
      expect(trimmedWord).to.be('hello')
      done()

    it 'trims left and right specified characters', (done) ->
      trimmedWord = _.trim('/hello//', '/')
      expect(trimmedWord).to.be('hello')
      done()
