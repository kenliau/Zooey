window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

_.templateSettings =
  interpolate: /\{\{\=(.+?)\}\}/g
  evaluate: /\{\{(.+?)\}\}/g
  escape : /\{\{-(.+?)\}\}/g

window.template = (id) ->
  return _.template $('#' + id).html()
