# Backbone and Underscore initialization
window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

_.templateSettings =
  interpolate: /\{\{\=(.+?)\}\}/g
  evaluate: /\{\{\%(.+?)\}\}/g
  escape : /\{\{-(.+?)\}\}/g

window.template = (id) ->
  _.template $('#' + id).html()


# Detecting path location
path = window.location.pathname

window.onJobShow = ->
  console.log('window.onJobShow is called')
  /\/jobs\/[0-9]+/.test(path) and parseInt(path.split('/')[2], 10)

window.onJobsList = ->
  console.log('window.onJobsList is called')
  path == '/jobs'
