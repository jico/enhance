_ = require('../vendor/lodash/dist/lodash')

_.mixin
  joinURIComponents: ->
    leadingSlashes = arguments[0]?.match(/^[\/]{1,2}/) || ''
    components = _.map arguments, (str, i) ->
      _.trim(str, '/').split(/\/(?!\/)/) if str?

    uri = leadingSlashes + _.flatten(_.compact(components)).join('/')

  trim: (string, characters) ->
    characters ?= '\\s'
    regexp = new RegExp("^[#{characters}]+|[#{characters}]+$", 'g')
    string.replace(regexp, '')

module.exports = _
