// Generated by CoffeeScript 1.6.3
(function() {
  var Enhance, _;

  _ = require('./lodash');

  Enhance = (function() {
    return function(options) {
      var defaults, exports, helpers, isHiDPI, prependHost, render;
      defaults = {
        host: '',
        suffix: '@2x'
      };
      options = _.merge(defaults, options);
      prependHost = function(pathname) {
        if (options.host.length && pathname[0] !== '/') {
          pathname = '/' + pathname;
        }
        return options.host + pathname;
      };
      isHiDPI = function(ratio) {
        var query;
        if (ratio == null) {
          ratio = 1.3;
        }
        query = "only screen and (-moz-min-device-pixel-ratio: " + ratio + "),         only screen and (-o-min-device-pixel-ratio: " + (ratio * 2) + "/2),         only screen and (-webkit-min-device-pixel-ratio: " + ratio + "),         only screen and (min-device-pixel-ratio: " + ratio + "),         only screen and (min-resolution: " + ratio + "dppx)";
        if (window.devicePixelRatio > ratio) {
          return true;
        }
        if (typeof window.matchMedia === "function" ? window.matchMedia(query).matches : void 0) {
          return true;
        }
        return false;
      };
      helpers = {
        isHiDPI: isHiDPI,
        merge: _.merge,
        prependHost: prependHost
      };
      render = function(src, opts) {
        var i;
        opts = _.merge({
          src: src
        }, opts);
        if (options.render != null) {
          return typeof options.render === "function" ? options.render(_.merge({}, options, opts, helpers)) : void 0;
        } else {
          if (isHiDPI()) {
            i = src.lastIndexOf('.');
            src = src.slice(0, i) + options.suffix + src.slice(i);
          }
          return prependHost(src);
        }
      };
      return exports = {
        isHiDPI: isHiDPI,
        render: render
      };
    };
  })();

  module.exports = Enhance;

}).call(this);