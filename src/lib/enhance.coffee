Enhance = do ->
  (options) ->
    options ?= {}
    options.suffix or= '@2x'

    isHiRes = (ratio) ->
      ratio ?= 1.3
      query = "only screen and (-moz-min-device-pixel-ratio: #{ratio}), \
        only screen and (-o-min-device-pixel-ratio: #{ratio*2}/2), \
        only screen and (-webkit-min-device-pixel-ratio: #{ratio}), \
        only screen and (min-device-pixel-ratio: #{ratio}), \
        only screen and (min-resolution: #{ratio}dppx)"

      window.devicePixelRatio > ratio || window.matchMedia?(query).matches?

    # TODO: Keep this?
    # parseExtension = (src) ->
      # str = src.split('.').slice(-1)
      # str.match(/jpe?g|png|bmp|gif|ti?ff/i)

    render = (src) ->
      if isHiRes()
        i = src.lastIndexOf('.')
        src.slice(0,i) + options.suffix + src.slice(i)
      else
        src

    exports =
      isHiRes: isHiRes
      render:  render

module.exports = Enhance
