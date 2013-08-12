expect  = require('expect.js')
jsdom   = require('jsdom')
sinon   = require('sinon')
Enhance = require('../lib/enhance')

describe 'Enhance', ->
  setRetina = ->
    `window.devicePixelRatio = 2.0`

  setNonRetina = ->
    `window.devicePixelRatio = 1.0`

  beforeEach ->
    `window = jsdom.createWindow()`
    `window.matchMedia = function() { return { matches: false } }`

  describe 'init', ->
    describe 'suffix option', ->
      it 'appends the given suffix for retina devices', (done) ->
        setRetina()
        expect(Enhance(suffix: '_2x').render('image.png')).to.be('image_2x.png')
        done()

    describe 'host option', ->
      it 'prepends the given host for non-retina devices', (done) ->
        setNonRetina()
        enhance = Enhance(host: 'http://example.com').render('image.png')
        expect(enhance).to.be('http://example.com/image.png')
        done()

      it 'prepends the given host for retina devices', (done) ->
        setRetina()
        enhance = Enhance(host: 'http://example.com').render('image.png')
        expect(enhance).to.be('http://example.com/image@2x.png')
        done()

    describe 'render callback', ->
      it 'calls the passed render callback instead of the default', (done) ->
        enhance = Enhance(render: (properties) -> return "awesome").render('image.png')
        expect(enhance).to.be('awesome')
        done()

      describe 'the callback enhance object', (done) ->
        it 'has the src filename being rendered', (done) ->
          initOpts =
            render: (enhance) ->
              expect(enhance.src).to.be('image.png')
              done()

          Enhance(initOpts).render('image.png')

        it 'has any enhance passed in at initialization', (done) ->
          initOpts =
            render: (enhance) ->
              expect(enhance.host).to.be('http://example.com')
              expect(enhance.suffix).to.be('_2x')
              done()
            host:   'http://example.com'
            suffix: '_2x'

          Enhance(initOpts).render('image.png')

        it 'has any properties passed in on call to render', (done) ->
          initOpts =
            render: (enhance) ->
              expect(enhance.width).to.be(50)
              expect(enhance.height).to.be(100)
              done()

          Enhance(initOpts).render('image.png', width: 50, height: 100)

        it 'has helper methods available', (done) ->
          initOpts =
            render: (enhance) ->
              expect(enhance._).to.be.a('function')
              expect(enhance.isHiDPI).to.be.a('function')
              done()

          Enhance(initOpts).render('image.png')

  describe '#isHiDPI', ->
    it 'returns true if devicePixelRatio greater than 1.3 by default', (done) ->
      setRetina()
      expect(Enhance().isHiDPI()).to.be(true)
      done()

    it 'return true if matchMedia has matches on the media query', (done) ->
      setNonRetina()
      `window.matchMedia = function() { return { matches: true } }`
      expect(Enhance().isHiDPI()).to.be(true)
      done()

    it 'returns false if neither devicePixelRatio nor matchMedia test passes', (done) ->
      `window.devicePixelRatio = 1.0`
      `window.matchMedia = undefined`
      expect(Enhance().isHiDPI()).to.be(false)
      done()

    it 'accepts an optional ratio parameter', (done) ->
      `window.devicePixelRatio = 1.5`
      expect(Enhance().isHiDPI(1.0)).to.be(true)
      expect(Enhance().isHiDPI(2.0)).to.be(false)
      done()

  describe '#render', ->
    describe 'default Apple Retina naming convention', ->
      it 'returns the original filename for non-retina devices', (done) ->
        expect(Enhance().render('image.png')).to.be('image.png')
        done()

      it 'returns a suffixed filename for retina devices', (done) ->
        setRetina()
        expect(Enhance().render('image.png')).to.be('image@2x.png')
        done()

    describe 'suffixing image formats', ->
      it 'suffixes jpeg and jpg extensions', (done) ->
        setRetina()
        expect(Enhance().render('image.jpg')).to.be('image@2x.jpg')
        expect(Enhance().render('image.jpeg')).to.be('image@2x.jpeg')
        done()

      it 'suffixes png extensions', (done) ->
        setRetina()
        expect(Enhance().render('image.png')).to.be('image@2x.png')
        done()

      it 'suffixes gif extensions', (done) ->
        setRetina()
        expect(Enhance().render('image.gif')).to.be('image@2x.gif')
        done()

      it 'suffixes tiff, tif, and tff extensions', (done) ->
        setRetina()
        expect(Enhance().render('image.tiff')).to.be('image@2x.tiff')
        expect(Enhance().render('image.tif')).to.be('image@2x.tif')
        expect(Enhance().render('image.tff')).to.be('image@2x.tff')
        done()

      it 'does not suffix unrecognized formats', (done) ->
        setRetina()
        expect(Enhance().render('image.pdf')).to.be('image.pdf')
        done()

  describe '#isMobileDevice', ->
    describe 'with tablets not considered mobile devices', ->
      it 'queries the media with a phone breakpoint', (done) ->
        stubMatchMedia = sinon.stub `window`, 'matchMedia', -> { matches: false }
        Enhance().isMobileDevice()
        expect(stubMatchMedia.withArgs('only screen and (max-width: 480px)').calledOnce).to.be(true)
        done()

      it 'allows overriding the phone breakpoint', (done) ->
        stubMatchMedia = sinon.stub `window`, 'matchMedia', -> { matches: false }
        Enhance(phoneBreakpoint: 500).isMobileDevice()
        expect(stubMatchMedia.withArgs('only screen and (max-width: 500px)').calledOnce).to.be(true)
        done()

    describe 'with tablets considered mobile devices', ->
      it 'queries the media with a tablet breakpoint', (done) ->
        stubMatchMedia = sinon.stub `window`, 'matchMedia', -> { matches: false }
        Enhance(tabletAsMobile: true).isMobileDevice()
        expect(stubMatchMedia.withArgs('only screen and (max-width: 1024px)').calledOnce).to.be(true)
        done()

      it 'allows overriding the tablet breakpoint', (done) ->
        stubMatchMedia = sinon.stub `window`, 'matchMedia', -> { matches: false }
        Enhance(tabletBreakpoint: 800, tabletAsMobile: true).isMobileDevice()
        expect(stubMatchMedia.withArgs('only screen and (max-width: 800px)').calledOnce).to.be(true)
        done()
