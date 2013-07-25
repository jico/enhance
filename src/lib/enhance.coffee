_ = require('lodash/dist/lodash')

Enhance = do ->
  (options) ->

    defaults =
      host:   ''
      suffix: '@2x'

    options = _.merge({}, defaults, options)

    # Utility

    prependHost = (pathname) ->
      pathname = '/' + pathname if options.host.length && pathname[0] != '/'
      options.host + pathname
 
    # Public methods

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

    # Helper functions passed into init callbacks
    helpers =
      isHiDPI:     isHiDPI
      merge:       _.merge
      prependHost: prependHost

    render = (src, opts) ->
      opts           = _.merge({ src: src }, opts)
      enhanceHelpers = _.merge({}, options, opts, helpers)
      if options.render?
        options.render?(enhanceHelpers)
      else
        if isHiDPI()
          i   = src.lastIndexOf('.')
          src = src.slice(0,i) + options.suffix + src.slice(i)
        prependHost(src)


    exports =
      isHiDPI: isHiDPI
      render:  render

module.exports = Enhance
