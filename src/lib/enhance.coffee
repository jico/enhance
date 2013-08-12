_ = require('./lodash-ext')

Enhance = do ->
  (options) ->

    defaults =
      host:             null
      suffix:           '@2x'
      phoneBreakpoint:  480
      tabletBreakpoint: 1024
      tabletAsMobile:   false

    options = _.merge(defaults, options)

    isHiDPI = (ratio) ->
      ratio ?= 1.3
      query = "only screen and (-moz-min-device-pixel-ratio: #{ratio}), \
        only screen and (-o-min-device-pixel-ratio: #{ratio*2}/2), \
        only screen and (-webkit-min-device-pixel-ratio: #{ratio}), \
        only screen and (min-device-pixel-ratio: #{ratio}), \
        only screen and (min-resolution: #{ratio}dppx)"

      if window.devicePixelRatio > ratio   then return true
      if window.matchMedia?(query).matches then return true
      return false

    isMobileDevice = ->
      mobileDevice = if options.tabletAsMobile then 'tablet' else 'phone'
      breakpoint   = options["#{mobileDevice}Breakpoint"]
      window.matchMedia?("only screen and (max-width: #{breakpoint}px)").matches


    # Helper functions passed into init callbacks
    helpers =
      _:              _
      isHiDPI:        isHiDPI

    render = (src, opts) ->
      if options.render?
        options.render?(_.merge({ src: src }, options, opts, helpers))
      else
        regexp = new RegExp(/(.jpe?g|.png|.gif|.ti?ff?)/i)
        src    = src.replace(regexp, "#{options.suffix}$1") if isHiDPI()
        _.joinURIComponents(options.host, src)


    exports =
      isHiDPI:        isHiDPI
      render:         render
      isMobileDevice: isMobileDevice

module.exports = Enhance
