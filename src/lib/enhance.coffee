Enhance = do ->
  (options) ->

    isHiRes = (ratio) ->
      ratio ?= 1.3
      query = "only screen and (-moz-min-device-pixel-ratio: #{ratio}), \
        only screen and (-o-min-device-pixel-ratio: #{ratio*2}/2), \
        only screen and (-webkit-min-device-pixel-ratio: #{ratio}), \
        only screen and (min-device-pixel-ratio: #{ratio}), \
        only screen and (min-resolution: #{ratio}dppx)"

      window.devicePixelRatio > ratio || window.matchMedia?(query).matches?

    render = (src) ->
      if isHiRes()
        # TODO
      else
        src

    exports =
      isHiRes: isHiRes
      render:  render

module.exports = Enhance
