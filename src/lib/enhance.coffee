Enhance = do ->
  (initOpts) ->
    initOpts ?= {}
    initOpts.host   or= ''
    initOpts.suffix or= '@2x'

    # Utility

    merge = ->
      i = arguments.length
      while --i > 0
        arguments[i-1][key] = val for key, val of arguments[i]
      arguments[0]

    prependHost = (pathname) ->
      pathname = '/' + pathname if initOpts.host.length && pathname[0] != '/'
      initOpts.host + pathname
 
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
      merge:       merge
      prependHost: prependHost

    render = (src, opts) ->
      opts           = merge({ src: src }, opts)
      enhanceHelpers = merge({}, initOpts, opts, helpers)
      if initOpts.render?
        initOpts.render?(enhanceHelpers)
      else
        if isHiDPI()
          i   = src.lastIndexOf('.')
          src = src.slice(0,i) + initOpts.suffix + src.slice(i)
        prependHost(src)


    exports =
      isHiDPI: isHiDPI
      render:  render

module.exports = Enhance
