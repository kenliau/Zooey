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
  _.template $('#' + id).html()

window.onJobShow = () ->
  /\/jobs\/[0-9]+/.test(window.location.pathname)

window.onJobsList = () ->
  window.location.pathname == '/jobs/'
