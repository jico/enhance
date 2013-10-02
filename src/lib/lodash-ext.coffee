_ = require('../vendor/lodash/dist/lodash')

_.mixin
  joinURIComponents: ->
    components = _.map(arguments, (str) -> str?.split(/\/(?!\/)/))
    _.flatten(_.compact(components)).join('/')

module.exports = _
