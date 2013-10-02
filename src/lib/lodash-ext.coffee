_ = require('../vendor/lodash/dist/lodash')

_.mixin
  joinURIComponents: ->
    components = _.map arguments, (str, i) ->
      _.trim(str, '/').split(/\/(?!\/)/) if str?

    uri  = if arguments[0]?[0] == '/' then '/' else ''
    uri += _.flatten(_.compact(components)).join('/')

  trim: (string, characters) ->
    characters ?= '\\s'
    regexp = new RegExp("^[#{characters}]+|[#{characters}]+$", 'g')
    string.replace(regexp, '')

module.exports = _
