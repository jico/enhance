expect  = require('expect.js')
fs      = require('fs')
jsdom   = require('jsdom')
Enhance = require('../lib/enhance')

describe 'Enhance', ->
  beforeEach ->
    `window = jsdom.createWindow()`

  describe '#isHiRes', ->
    it 'returns true if devicePixelRatio less than 1.3 by default', (done) ->
      `window.devicePixelRatio = 2.0`
      expect(Enhance().isHiRes()).to.be(true)
      done()

    it 'return true if matchMedia has matches on the media query', (done) ->
      `window.devicePixelRatio = 1.0`
      `window.matchMedia = function() { return { matches: true } }`
      expect(Enhance().isHiRes()).to.be(true)
      done()

    it 'returns false if neither devicePixelRatio nor matchMedia test passes', (done) ->
      `window.devicePixelRatio = 1.0`
      `window.matchMedia = undefined`
      expect(Enhance().isHiRes()).to.be(false)
      done()

    it 'accepts an optional ratio parameter', (done) ->
      `window.devicePixelRatio = 1.5`
      expect(Enhance().isHiRes(1.0)).to.be(true)
      expect(Enhance().isHiRes(2.0)).to.be(false)
      done()

  describe '#render', ->
    describe 'default Apple Retina naming convention', ->
      it 'returns the original filename for non-retina devices', (done) ->
        expect(Enhance().render('image.png')).to.be('image.png')
        done()

      it 'returns a suffixed filename for retina devices', (done) ->
        `window.devicePixelRatio = 2.0`
        expect(Enhance().render('image.png')).to.be('image@2x.png')
        done()

    describe 'suffix option', ->
      it 'appends the given suffix for retina devices', (done) ->
        `window.devicePixelRatio = 2.0`
        expect(Enhance(suffix: '_2x').render('image.png')).to.be('image_2x.png')
        done()
